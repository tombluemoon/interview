import fs from "node:fs/promises";
import path from "node:path";

import postgres, { type Sql } from "postgres";
import { afterAll, beforeAll, beforeEach, expect, vi } from "vitest";

type CachedSql = {
  end: () => Promise<void>;
};

type GlobalWithCachedSql = typeof globalThis & {
  __interviewReviewSql?: CachedSql;
};

interface CookieEntry {
  value: string;
  options?: Record<string, unknown>;
}

interface MutableCookieStore {
  get: ReturnType<typeof vi.fn>;
  set: ReturnType<typeof vi.fn>;
  delete: ReturnType<typeof vi.fn>;
  snapshot: () => Record<string, string>;
}

let sql: Sql | null = null;
let schemaSql = "";
let seedSql = "";

function requireDatabaseUrl() {
  const databaseUrl = process.env.DATABASE_URL;

  if (!databaseUrl) {
    throw new Error(
      "DATABASE_URL must be set before running integration tests.",
    );
  }

  return databaseUrl;
}

async function loadSqlFile(relativePath: string) {
  return fs.readFile(path.resolve(process.cwd(), relativePath), "utf8");
}

async function closeCachedAppSql() {
  const globalWithCachedSql = globalThis as GlobalWithCachedSql;

  if (globalWithCachedSql.__interviewReviewSql) {
    await globalWithCachedSql.__interviewReviewSql.end();
    globalWithCachedSql.__interviewReviewSql = undefined;
  }
}

async function resetTestDatabase() {
  if (!sql) {
    throw new Error("Integration database connection is not ready.");
  }

  await sql.unsafe("DROP SCHEMA IF EXISTS public CASCADE;");
  await sql.unsafe("CREATE SCHEMA public;");
  await sql.unsafe(schemaSql);
  await sql.unsafe(seedSql);
}

function resetModuleState() {
  vi.doUnmock("next/headers");
  vi.doUnmock("next/navigation");
  vi.resetModules();
  vi.clearAllMocks();
}

export function setupIntegrationDatabase() {
  beforeAll(async () => {
    schemaSql = await loadSqlFile("db/schema.sql");
    seedSql = await loadSqlFile("db/seed.sql");
    sql = postgres(requireDatabaseUrl(), {
      max: 1,
      onnotice: () => {
        // Keep test output focused.
      },
    });

    await resetTestDatabase();
  });

  beforeEach(async () => {
    resetModuleState();
    await closeCachedAppSql();
    await resetTestDatabase();
  });

  afterAll(async () => {
    resetModuleState();
    await closeCachedAppSql();

    if (sql) {
      await sql.end();
      sql = null;
    }
  });
}

export function createCookieStore(): MutableCookieStore {
  const entries = new Map<string, CookieEntry>();

  return {
    get: vi.fn((name: string) => {
      const entry = entries.get(name);

      if (!entry) {
        return undefined;
      }

      return {
        name,
        value: entry.value,
      };
    }),
    set: vi.fn(
      (name: string, value: string, options?: Record<string, unknown>) => {
        entries.set(name, {
          value,
          options,
        });
      },
    ),
    delete: vi.fn((name: string) => {
      entries.delete(name);
    }),
    snapshot: () =>
      Object.fromEntries(
        Array.from(entries.entries()).map(([name, entry]) => [name, entry.value]),
      ),
  };
}

export function mockNextRequestContext(cookieStore = createCookieStore()) {
  const redirect = vi.fn((path: string) => {
    throw new Error(`REDIRECT:${path}`);
  });

  vi.doMock("next/headers", () => ({
    cookies: vi.fn(async () => cookieStore),
  }));
  vi.doMock("next/navigation", () => ({
    redirect,
  }));

  return {
    cookieStore,
    redirect,
  };
}

export function createJsonRequest(
  url: string,
  body: Record<string, unknown>,
  method = "POST",
) {
  return new Request(url, {
    method,
    headers: {
      "content-type": "application/json",
    },
    body: JSON.stringify(body),
  });
}

export async function loginAs(
  email: string,
  password: string,
  cookieStore = createCookieStore(),
) {
  const context = mockNextRequestContext(cookieStore);
  const loginRoute = await import("@/app/api/v1/auth/login/route");
  const response = await loginRoute.POST(
    createJsonRequest("http://localhost/api/v1/auth/login", {
      email,
      password,
    }),
  );

  expect(response.status).toBe(200);

  return {
    ...context,
    response,
  };
}

export async function readJson<T>(response: Response): Promise<T> {
  return (await response.json()) as T;
}
