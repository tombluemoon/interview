#!/usr/bin/env node
/**
 * Parse Notion JSON and generate SQL INSERT statements for questions
 * 
 * Usage:
 *   node scripts/parse-notion-to-sql.mjs
 */

import { readFileSync, writeFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, '..');

// Read the full JSON
const inputFile = join(projectRoot, 'notion_questions_full.json');
const data = JSON.parse(readFileSync(inputFile, 'utf-8'));

// Category mapping
const CATEGORY_MAP = {
  'JVM': { id: 'cat_java', name: 'Java Core' },
  'GC': { id: 'cat_java', name: 'Java Core' },
  'Memory': { id: 'cat_java', name: 'Java Core' },
  'Collection': { id: 'cat_java', name: 'Java Core' },
  'Concurrency': { id: 'cat_java', name: 'Java Core' },
  'Thread': { id: 'cat_java', name: 'Java Core' },
  'Spring': { id: 'cat_java', name: 'Java Core' },
  'MySQL': { id: 'cat_sql', name: 'SQL' },
  'SQL': { id: 'cat_sql', name: 'SQL' },
  'Transaction': { id: 'cat_sql', name: 'SQL' },
  'Redis': { id: 'cat_system', name: 'System Design' },
  'System Design': { id: 'cat_system', name: 'System Design' },
  'Architecture': { id: 'cat_system', name: 'System Design' },
  'Microservice': { id: 'cat_system', name: 'System Design' },
  'Behavioral': { id: 'cat_behavioral', name: 'Behavioral' },
  'AI': { id: 'cat_ai', name: 'AI' },
  'LLM': { id: 'cat_ai', name: 'AI' },
  'RAG': { id: 'cat_ai', name: 'AI' },
  'Backend': { id: 'cat_ai', name: 'AI' },
  'Engineering': { id: 'cat_ai', name: 'AI' },
};

function extractText(richTextArray) {
  if (!richTextArray) return '';
  return richTextArray.map(rt => rt.plain_text || '').join('');
}

function extractBlockText(block) {
  const blockType = block.type;
  if (block[blockType] && block[blockType].rich_text) {
    return extractText(block[blockType].rich_text);
  }
  return '';
}

function slugify(text) {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-')
    .trim()
    .substring(0, 80);
}

function inferDifficulty(text, tags) {
  const lower = text.toLowerCase();
  const tagStr = (tags || []).join(' ').toLowerCase();
  
  if (lower.includes('design') || lower.includes('architect') || 
      lower.includes('advanced') || lower.includes('complex') ||
      tagStr.includes('hard') || tagStr.includes('advanced')) {
    return 'Hard';
  }
  if (lower.includes('basic') || lower.includes('simple') || lower.includes('what is')) {
    return 'Easy';
  }
  return 'Medium';
}

function inferTags(question, category) {
  const tags = [];
  const lower = (question + ' ' + category).toLowerCase();
  
  // JVM tags
  if (lower.includes('gc') || lower.includes('garbage')) tags.push('gc');
  if (lower.includes('heap')) tags.push('heap');
  if (lower.includes('memory')) tags.push('memory');
  if (lower.includes('metaspace')) tags.push('metaspace');
  if (lower.includes('jvm')) tags.push('jvm');
  
  // Java tags
  if (lower.includes('hashmap')) tags.push('hashmap');
  if (lower.includes('collection')) tags.push('collections');
  if (lower.includes('concurrent') || lower.includes('thread')) tags.push('concurrency');
  if (lower.includes('spring')) tags.push('spring');
  
  // Database tags
  if (lower.includes('mysql') || lower.includes('database')) tags.push('database');
  if (lower.includes('index')) tags.push('indexing');
  if (lower.includes('transaction')) tags.push('transactions');
  if (lower.includes('redis')) tags.push('redis');
  
  // System Design tags
  if (lower.includes('microservice')) tags.push('microservices');
  if (lower.includes('scalab')) tags.push('scalability');
  if (lower.includes('design')) tags.push('design');
  
  // AI tags
  if (lower.includes('rag')) tags.push('rag');
  if (lower.includes('llm')) tags.push('llm');
  if (lower.includes('embed')) tags.push('embeddings');
  
  return tags.length > 0 ? tags : ['general'];
}

function escapeSQL(str) {
  if (!str) return null;
  return str.replace(/'/g, "''");
}

const allQuestions = [];
let globalIndex = 0;

for (const page of data.pages) {
  console.log(`Processing: ${page.name} (${page.blocks.length} blocks)`);
  
  let currentCategory = '';
  let currentSubcategory = '';
  let currentQuestion = null;
  let questionCount = 0;
  
  for (let i = 0; i < page.blocks.length; i++) {
    const block = page.blocks[i];
    const blockType = block.type;
    
    // heading_2 = subcategory
    if (blockType === 'heading_2') {
      const text = extractBlockText(block).trim();
      if (text) {
        currentSubcategory = text;
        
        // Determine category from text
        for (const [keyword, catInfo] of Object.entries(CATEGORY_MAP)) {
          if (text.includes(keyword)) {
            currentCategory = catInfo;
            break;
          }
        }
      }
    }
    
    // heading_3 = question
    if (blockType === 'heading_3') {
      if (currentQuestion) {
        allQuestions.push(currentQuestion);
      }
      
      const questionText = extractBlockText(block).trim();
      if (questionText) {
        const cleanText = questionText.replace(/^Q\d+\.\s*/, '');
        const tags = inferTags(cleanText, currentSubcategory);
        
        currentQuestion = {
          title: cleanText,
          category: currentCategory || { id: 'cat_java', name: 'Java Core' },
          subcategory: currentSubcategory,
          body: '',
          hint: '',
          referenceAnswer: '',
          tags: tags,
          difficulty: inferDifficulty(cleanText, tags),
          index: globalIndex++,
        };
        questionCount++;
      }
    }
    
    // Collect answer content from various block types
    if (currentQuestion) {
      const text = extractBlockText(block).trim();
      
      if (blockType === 'bulleted_list_item' && text) {
        if (currentQuestion.referenceAnswer) {
          currentQuestion.referenceAnswer += '\n' + text;
        } else {
          currentQuestion.referenceAnswer = text;
        }
      }
      
      if (blockType === 'numbered_list_item' && text) {
        if (currentQuestion.referenceAnswer) {
          currentQuestion.referenceAnswer += '\n' + text;
        } else {
          currentQuestion.referenceAnswer = text;
        }
      }
      
      if (blockType === 'paragraph' && text && text.length > 20) {
        if (!currentQuestion.body) {
          currentQuestion.body = text;
        } else {
          currentQuestion.body += '\n' + text;
        }
      }
      
      if (blockType === 'quote' && text) {
        currentQuestion.hint = text;
      }
      
      // to_do blocks might contain checklists with hints
      if (blockType === 'to_do' && text) {
        if (currentQuestion.hint) {
          currentQuestion.hint += '\n' + text;
        } else {
          currentQuestion.hint = text;
        }
      }
    }
  }
  
  // Don't forget last question
  if (currentQuestion) {
    allQuestions.push(currentQuestion);
  }
  
  console.log(`  Extracted ${questionCount} questions`);
}

console.log(`\nTotal questions extracted: ${allQuestions.length}`);

// Generate SQL file
const sqlLines = [];
sqlLines.push('-- Interview Questions Imported from Notion');
sqlLines.push(`-- Generated: ${new Date().toISOString()}`);
sqlLines.push(`-- Total Questions: ${allQuestions.length}`);
sqlLines.push('');

// Add category if it doesn't exist
sqlLines.push("-- Ensure behavioral category exists");
sqlLines.push(`INSERT INTO question_categories (id, name, slug, description)
VALUES ('cat_behavioral', 'Behavioral', 'behavioral', 'Behavioral and situational interview questions.')
ON CONFLICT (id) DO NOTHING;`);
sqlLines.push('');

// Insert questions
for (const q of allQuestions) {
  const id = `notion_q_${q.index}`;
  const slug = `${slugify(q.title)}-${q.index}`;
  const excerpt = q.referenceAnswer 
    ? q.referenceAnswer.split('\n')[0].substring(0, 200)
    : q.title.substring(0, 200);
  const body = q.body || q.referenceAnswer || q.title;
  
  const tagsArray = `ARRAY[${q.tags.map(t => `'${t}'`).join(', ')}]::TEXT[]`;
  
  sqlLines.push(`-- ${q.title.substring(0, 80)}...`);
  sqlLines.push(`INSERT INTO questions (
  id,
  slug,
  title,
  category_id,
  difficulty,
  tags,
  excerpt,
  body,
  hint,
  reference_answer,
  related_slugs,
  visibility,
  content_status
) VALUES (
  '${id}',
  '${escapeSQL(slug)}',
  '${escapeSQL(q.title)}',
  '${q.category.id}',
  '${q.difficulty}',
  ${tagsArray},
  '${escapeSQL(excerpt)}',
  '${escapeSQL(body)}',
  ${q.hint ? `'${escapeSQL(q.hint)}'` : 'NULL'},
  ${q.referenceAnswer ? `'${escapeSQL(q.referenceAnswer)}'` : 'NULL'},
  ARRAY[]::TEXT[],
  'PUBLIC',
  'PUBLISHED'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  body = EXCLUDED.body,
  reference_answer = EXCLUDED.reference_answer,
  hint = EXCLUDED.hint,
  difficulty = EXCLUDED.difficulty,
  category_id = EXCLUDED.category_id;`);
  sqlLines.push('');
}

// Write SQL file
const outputFile = join(projectRoot, 'db', 'import-notion-questions.sql');
writeFileSync(outputFile, sqlLines.join('\n'), 'utf-8');

console.log(`\n✓ SQL file generated: ${outputFile}`);
console.log(`  Total INSERT statements: ${allQuestions.length}`);

// Also generate a summary
const summary = {
  generated: new Date().toISOString(),
  totalQuestions: allQuestions.length,
  byCategory: {},
  byDifficulty: {},
  questions: allQuestions.map(q => ({
    index: q.index,
    title: q.title,
    category: q.category.name,
    difficulty: q.difficulty,
    tags: q.tags,
  })),
};

for (const q of allQuestions) {
  const catName = q.category.name;
  summary.byCategory[catName] = (summary.byCategory[catName] || 0) + 1;
  summary.byDifficulty[q.difficulty] = (summary.byDifficulty[q.difficulty] || 0) + 1;
}

const summaryFile = join(projectRoot, 'notion-import-summary.json');
writeFileSync(summaryFile, JSON.stringify(summary, null, 2), 'utf-8');

console.log(`✓ Summary generated: ${summaryFile}`);
console.log(`\nCategory breakdown:`);
for (const [cat, count] of Object.entries(summary.byCategory)) {
  console.log(`  ${cat}: ${count}`);
}
console.log(`\nDifficulty breakdown:`);
for (const [diff, count] of Object.entries(summary.byDifficulty)) {
  console.log(`  ${diff}: ${count}`);
}
