/**
 * Lightweight markdown renderer for question content.
 * Supports: headings, bold, italic, code blocks, inline code, lists, links, images, blockquotes, horizontal rules.
 */

function escapeHtml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function renderInline(text: string): string {
  // Images: ![alt](url)
  text = text.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img src="$2" alt="$1" class="qb-md-img" />');
  // Links: [text](url)
  text = text.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank" rel="noopener noreferrer">$1</a>');
  // Bold + Italic: ***text*** or ___text___
  text = text.replace(/\*\*\*([^*]+)\*\*\*/g, "<strong><em>$1</em></strong>");
  text = text.replace(/___([^_]+)___/g, "<strong><em>$1</em></strong>");
  // Bold: **text** or __text__
  text = text.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  text = text.replace(/__([^_]+)__/g, "<strong>$1</strong>");
  // Italic: *text* or _text_
  text = text.replace(/\*([^*]+)\*/g, "<em>$1</em>");
  text = text.replace(/(?<![a-zA-Z0-9])_([^_]+)_(?![a-zA-Z0-9])/g, "<em>$1</em>");
  // Inline code: `code`
  text = text.replace(/`([^`]+)`/g, "<code class=\"qb-md-inline-code\">$1</code>");
  return text;
}

export function renderMarkdown(text: string): string {
  const lines = text.split("\n");
  const output: string[] = [];
  let inCodeBlock = false;
  let codeContent: string[] = [];
  let inList = false;
  let listItems: string[] = [];

  function closeList() {
    if (inList && listItems.length > 0) {
      output.push(`<ul class="qb-md-list">${listItems.map((item) => `<li>${item}</li>`).join("")}</ul>`);
      listItems = [];
      inList = false;
    }
  }

  function closeCodeBlock() {
    if (inCodeBlock && codeContent.length > 0) {
      output.push(`<pre class="qb-md-code"><code>${escapeHtml(codeContent.join("\n"))}</code></pre>`);
      codeContent = [];
      inCodeBlock = false;
    }
  }

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    // Code block: ```lang ... ```
    if (line.trimStart().startsWith("```")) {
      if (inCodeBlock) {
        closeCodeBlock();
      } else {
        closeList();
        inCodeBlock = true;
      }
      continue;
    }

    if (inCodeBlock) {
      codeContent.push(line);
      continue;
    }

    // Headings
    const headingMatch = line.match(/^(#{1,3})\s+(.+)$/);
    if (headingMatch) {
      closeList();
      const level = headingMatch[1].length;
      const content = renderInline(headingMatch[2]);
      output.push(`<h${level + 2} class="qb-md-h">${content}</h${level + 2}>`);
      continue;
    }

    // Horizontal rule
    if (/^(-{3,}|\*{3,}|_{3,})$/.test(line.trim())) {
      closeList();
      output.push('<hr class="qb-md-hr" />');
      continue;
    }

    // Blockquote
    if (line.trimStart().startsWith(">")) {
      closeList();
      const content = renderInline(line.trimStart().replace(/^>\s?/, ""));
      output.push(`<blockquote class="qb-md-quote">${content}</blockquote>`);
      continue;
    }

    // Unordered list
    if (/^\s*[-*+]\s+/.test(line)) {
      inList = true;
      const content = renderInline(line.replace(/^\s*[-*+]\s+/, ""));
      listItems.push(content);
      continue;
    } else {
      closeList();
    }

    // Ordered list
    if (/^\s*\d+\.\s+/.test(line)) {
      closeList();
      const content = renderInline(line.replace(/^\s*\d+\.\s+/, ""));
      output.push(`<p class="qb-md-p">${content}</p>`);
      continue;
    }

    // Empty line
    if (line.trim() === "") {
      closeList();
      continue;
    }

    // Regular paragraph
    closeList();
    const content = renderInline(line);
    // Check if line contains an image
    if (content.includes('<img')) {
      output.push(`<div class="qb-md-img-wrapper">${content}</div>`);
    } else {
      output.push(`<p class="qb-md-p">${content}</p>`);
    }
  }

  closeList();
  closeCodeBlock();

  return output.join("\n");
}
