import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

import postgres from "postgres";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, "..");

const databaseUrl = process.env.DATABASE_URL;

if (!databaseUrl) {
  console.error("DATABASE_URL is not set.");
  process.exit(1);
}

const sql = postgres(databaseUrl, {
  max: 1,
  onnotice: () => {
    // Keep repeated local initialization runs quiet.
  },
});

const defaultSqlFiles = ["db/schema.sql", "db/seed.sql"];
const sqlFiles = process.argv.slice(2);

async function runSqlFile(relativePath) {
  const absolutePath = path.join(rootDir, relativePath);
  const statement = await fs.readFile(absolutePath, "utf8");

  console.log(`Running ${relativePath}`);
  await sql.unsafe(statement);
}

try {
  for (const sqlFile of sqlFiles.length > 0 ? sqlFiles : defaultSqlFiles) {
    await runSqlFile(sqlFile);
  }
  console.log("Database initialization completed.");
} catch (error) {
  console.error("Database initialization failed.");
  console.error(error);
  process.exitCode = 1;
} finally {
  await sql.end();
}
