import postgres, { type Sql } from "postgres";

declare global {
  var __interviewReviewSql: Sql | undefined;
}

const connectionString = process.env.DATABASE_URL;

const sqlInstance = connectionString
  ? global.__interviewReviewSql ??
    postgres(connectionString, {
      max: 1,
      idle_timeout: 5,
      connect_timeout: 10,
      onnotice: () => {
        // Keep local bootstrapping output quiet.
      },
    })
  : undefined;

if (connectionString && process.env.NODE_ENV !== "production") {
  global.__interviewReviewSql = sqlInstance;
}

export function isDatabaseConfigured() {
  return Boolean(connectionString);
}

export function getSql() {
  if (!sqlInstance) {
    throw new Error("DATABASE_URL is not configured.");
  }

  return sqlInstance;
}
