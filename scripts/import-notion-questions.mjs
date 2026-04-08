#!/usr/bin/env node
/**
 * Import interview questions from Notion JSON into PostgreSQL database
 * 
 * Usage:
 *   node scripts/import-notion-questions.mjs
 * 
 * Environment variables:
 *   DATABASE_URL - PostgreSQL connection string (from .env.local)
 */

import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import postgres from 'postgres';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, '..');

// Load environment variables
try {
  const envLocal = readFileSync(join(projectRoot, '.env.local'), 'utf-8');
  envLocal.split('\n').forEach(line => {
    const match = line.match(/^(\w+)=(.*)$/);
    if (match) {
      process.env[match[1]] = match[2].replace(/^["']|["']$/g, '');
    }
  });
} catch (e) {
  console.log('No .env.local file found, using environment variables');
}

const DATABASE_URL = process.env.DATABASE_URL;

if (!DATABASE_URL) {
  console.error('ERROR: DATABASE_URL environment variable is required');
  process.exit(1);
}

// Read the SQL file
const sqlFile = join(projectRoot, 'db', 'import-notion-questions.sql');
const sqlContent = readFileSync(sqlFile, 'utf-8');

console.log('Starting import from Notion questions...');
console.log(`SQL file size: ${(sqlContent.length / 1024).toFixed(2)} KB`);

// Connect to database
const sql = postgres(DATABASE_URL, {
  max: 1,
  idle_timeout: 5,
  connect_timeout: 10,
});

try {
  console.log('Connected to database');
  
  // Execute the entire SQL file
  await sql.unsafe(sqlContent);
  
  console.log('\n✓ Import completed successfully!');
  
  // Get count of imported questions
  const result = await sql`SELECT COUNT(*) as count FROM questions WHERE id LIKE 'notion_q_%'`;
  console.log(`Total Notion questions in database: ${result[0].count}`);
  
} catch (error) {
  console.error('✗ Import failed:', error.message);
  process.exit(1);
} finally {
  await sql.end();
}
