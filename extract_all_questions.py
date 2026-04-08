#!/usr/bin/env python3
"""
Notion Interview Question Extractor
====================================
This script fetches all blocks from the specified Notion pages and extracts
interview questions in a structured format.

Usage:
  1. Set the NOTION_API_KEY environment variable
  2. Run: python extract_all_questions.py
  3. Output will be saved to interview_questions_full.txt

Note: This script requires the 'requests' library.
      Install with: pip install requests
"""

import os
import sys
import json
import requests
from datetime import datetime

# Configuration
NOTION_API_KEY = os.environ.get("NOTION_API_KEY", "")

# If no API key, try to read from .env.local
if not NOTION_API_KEY:
    env_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env.local")
    if os.path.exists(env_path):
        with open(env_path, "r") as f:
            for line in f:
                if line.startswith("NOTION_API_KEY="):
                    NOTION_API_KEY = line.split("=", 1)[1].strip()
                    break

if not NOTION_API_KEY:
    print("ERROR: NOTION_API_KEY not found.")
    print("Please set it as an environment variable or add it to .env.local")
    sys.exit(1)

# Page definitions
PAGES = [
    {
        "id": "32d71c6c-d06e-8172-a472-e2a2b547601f",
        "name": "Week 1: JVM / Core Java / Collections / Concurrency"
    },
    {
        "id": "32d71c6c-d06e-8170-89ce-d89dcfb09c08",
        "name": "Week 2: Spring / MySQL / Redis / Transactions"
    },
    {
        "id": "32d71c6c-d06e-8169-ac3b-d96e2e0ae587",
        "name": "Week 3: System Design / Microservices"
    },
    {
        "id": "32d71c6c-d06e-81d6-b3e2-c122100ce604",
        "name": "Week 4: Behavioral"
    },
    {
        "id": "32d71c6c-d06e-8153-ad9c-e556347eb1f6",
        "name": "AI Expanded Question Bank"
    },
    {
        "id": "33a71c6c-d06e-8123-9f1f-d1a892126cf9",
        "name": "AI Engineering & Backend Question Bank"
    }
]

HEADERS = {
    "Authorization": f"Bearer {NOTION_API_KEY}",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json"
}

BASE_URL = "https://api.notion.com/v1"


def fetch_all_blocks(page_id):
    """Fetch all blocks from a page with pagination."""
    all_blocks = []
    start_cursor = None
    
    while True:
        url = f"{BASE_URL}/blocks/{page_id}/children"
        params = {"page_size": 100}
        if start_cursor:
            params["start_cursor"] = start_cursor
        
        response = requests.get(url, headers=HEADERS, params=params)
        
        if response.status_code != 200:
            print(f"  ERROR: Failed to fetch blocks: {response.status_code}")
            print(f"  {response.text}")
            break
        
        data = response.json()
        blocks = data.get("results", [])
        all_blocks.extend(blocks)
        
        if data.get("has_more") and data.get("next_cursor"):
            start_cursor = data["next_cursor"]
        else:
            break
    
    return all_blocks


def extract_text(rich_text):
    """Extract plain text from Notion rich_text array."""
    if not rich_text:
        return ""
    return "".join(item.get("plain_text", "") for item in rich_text)


def is_question(text):
    """Check if text looks like a question."""
    text = text.strip()
    if not text:
        return False
    
    # Ends with question mark
    if text.endswith("?"):
        return True
    
    # Starts with question words
    question_starts = [
        "what", "how", "why", "when", "where", "which", "who",
        "explain", "describe", "compare", "difference", "tell me",
        "walk me", "can you", "could you", "would you", "do you",
        "is there", "are there", "what's", "how's"
    ]
    
    text_lower = text.lower()
    for start in question_starts:
        if text_lower.startswith(start):
            return True
    
    return False


def process_blocks(blocks, page_name):
    """Process Notion blocks and extract questions."""
    questions = []
    current_category = None
    current_subcategory = None
    current_question = None
    
    for block in blocks:
        block_type = block.get("type", "")
        
        if block_type == "heading_1":
            text = extract_text(block.get("heading_1", {}).get("rich_text", []))
            current_category = text
            current_subcategory = None
            if current_question:
                questions.append(current_question)
                current_question = None
            continue
        
        elif block_type == "heading_2":
            text = extract_text(block.get("heading_2", {}).get("rich_text", []))
            if text.lower() == "how to use this page":
                current_subcategory = None
            else:
                current_subcategory = text
            if current_question:
                questions.append(current_question)
                current_question = None
            continue
        
        elif block_type == "heading_3":
            text = extract_text(block.get("heading_3", {}).get("rich_text", []))
            current_subcategory = text
            if current_question:
                questions.append(current_question)
                current_question = None
            continue
        
        elif block_type in ("quote", "divider"):
            continue
        
        elif block_type == "callout":
            text = extract_text(block.get("callout", {}).get("rich_text", []))
            if current_question:
                if "hint" in text.lower() or "tip" in text.lower():
                    current_question["hint"] = text
                elif current_question["answer"]:
                    current_question["answer"] += "\n" + text
                else:
                    current_question["answer"] = text
            continue
        
        elif block_type == "paragraph":
            text = extract_text(block.get("paragraph", {}).get("rich_text", []))
            if current_question:
                if current_question["answer"]:
                    current_question["answer"] += "\n" + text
                else:
                    current_question["answer"] = text
            continue
        
        elif block_type in ("numbered_list_item", "bulleted_list_item"):
            text = extract_text(block.get(block_type, {}).get("rich_text", []))
            
            if is_question(text):
                if current_question:
                    questions.append(current_question)
                current_question = {
                    "category": current_category or page_name,
                    "subcategory": current_subcategory,
                    "question": text,
                    "answer": "",
                    "hint": None
                }
            elif current_question:
                if current_question["answer"]:
                    current_question["answer"] += "\n" + text
                else:
                    current_question["answer"] = text
            continue
        
        elif block_type == "to_do":
            text = extract_text(block.get("to_do", {}).get("rich_text", []))
            if current_question:
                if current_question["answer"]:
                    current_question["answer"] += "\n" + text
                else:
                    current_question["answer"] = text
            continue
        
        elif block_type == "code":
            text = extract_text(block.get("code", {}).get("rich_text", []))
            language = block.get("code", {}).get("language", "")
            code_block = f"```{language}\n{text}\n```"
            if current_question:
                if current_question["answer"]:
                    current_question["answer"] += "\n\n" + code_block
                else:
                    current_question["answer"] = code_block
            continue
        
        elif block_type == "toggle":
            text = extract_text(block.get("toggle", {}).get("rich_text", []))
            if current_question:
                if current_question["answer"]:
                    current_question["answer"] += "\n" + text
                else:
                    current_question["answer"] = text
            continue
    
    # Don't forget the last question
    if current_question:
        questions.append(current_question)
    
    return questions


def format_output(all_questions):
    """Format questions for output."""
    output = []
    output.append("=" * 80)
    output.append("INTERVIEW QUESTIONS EXTRACTED FROM NOTION")
    output.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    output.append("=" * 80)
    
    for page_data in all_questions:
        page_name = page_data["name"]
        questions = page_data["questions"]
        
        output.append("")
        output.append("=" * 80)
        output.append(f"PAGE: {page_name}")
        output.append(f"Total questions found: {len(questions)}")
        output.append("=" * 80)
        
        current_cat = None
        current_sub = None
        q_num = 0
        
        for q in questions:
            if q["category"] != current_cat:
                current_cat = q["category"]
                current_sub = None
                output.append("")
                output.append("#" * 60)
                output.append(f"Category: {current_cat}")
                output.append("#" * 60)
                q_num = 0
            
            if q["subcategory"] and q["subcategory"] != current_sub:
                current_sub = q["subcategory"]
                output.append("")
                output.append("-" * 40)
                output.append(f"  Subcategory: {current_sub}")
                output.append("-" * 40)
            
            q_num += 1
            output.append("")
            output.append(f"  Q{q_num}: {q['question']}")
            
            if q["answer"]:
                output.append(f"  Answer:")
                # Split answer into lines for readability
                for line in q["answer"].split("\n"):
                    output.append(f"    {line}")
            
            if q["hint"]:
                output.append(f"  Hint: {q['hint']}")
    
    return "\n".join(output)


def main():
    """Main function."""
    print("Notion Interview Question Extractor")
    print("=" * 40)
    
    all_questions = []
    
    for page in PAGES:
        print(f"\nFetching: {page['name']}...")
        try:
            blocks = fetch_all_blocks(page["id"])
            print(f"  Retrieved {len(blocks)} blocks")
            
            questions = process_blocks(blocks, page["name"])
            print(f"  Extracted {len(questions)} questions")
            
            all_questions.append({
                "name": page["name"],
                "questions": questions
            })
        except Exception as e:
            print(f"  ERROR: {str(e)}")
    
    # Format and save output
    output = format_output(all_questions)
    
    output_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "interview_questions_full.txt")
    with open(output_file, "w") as f:
        f.write(output)
    
    print(f"\n{'=' * 40}")
    print(f"Questions saved to: {output_file}")
    print(f"Total pages processed: {len(all_questions)}")
    total_questions = sum(len(p["questions"]) for p in all_questions)
    print(f"Total questions extracted: {total_questions}")


if __name__ == "__main__":
    main()
