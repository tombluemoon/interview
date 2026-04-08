import { vi } from "vitest";

type SqlResult = unknown | Error;

function isQueryStatement(source: string) {
  return /^(SELECT|INSERT|UPDATE|DELETE)\b/i.test(source);
}

export function createSqlMock(results: SqlResult[] = []) {
  const queue = [...results];
  const executedStatements: string[] = [];

  const sql = vi.fn((strings: TemplateStringsArray, ...values: unknown[]) => {
    const statement = strings.join(" ").replace(/\s+/g, " ").trim();

    if (!isQueryStatement(statement)) {
      return {
        __fragment: true,
        statement,
        values,
      };
    }

    executedStatements.push(statement);
    const nextResult = queue.shift();

    if (nextResult instanceof Error) {
      return Promise.reject(nextResult);
    }

    return Promise.resolve(nextResult ?? []);
  });

  Object.assign(sql, {
    begin: async <T>(callback: (transaction: typeof sql) => Promise<T>) =>
      callback(sql),
  });

  return {
    sql: sql as typeof sql & {
      begin: <T>(callback: (transaction: typeof sql) => Promise<T>) => Promise<T>;
    },
    executedStatements,
    queue,
  };
}

export async function importWithDbMock<T>(
  modulePath: string,
  results: SqlResult[] = [],
) {
  vi.resetModules();
  const sqlState = createSqlMock(results);

  vi.doMock("@/lib/db", () => ({
    getSql: () => sqlState.sql,
    isDatabaseConfigured: () => true,
  }));

  const importedModule = (await import(modulePath)) as T;

  return {
    module: importedModule,
    ...sqlState,
  };
}

export async function importWithoutDb<T>(modulePath: string) {
  vi.resetModules();

  vi.doMock("@/lib/db", () => ({
    getSql: () => {
      throw new Error("DATABASE_URL is not configured.");
    },
    isDatabaseConfigured: () => false,
  }));

  return (await import(modulePath)) as T;
}

export function restoreModuleMocks() {
  vi.doUnmock("@/lib/db");
  vi.doUnmock("next/headers");
  vi.doUnmock("next/navigation");
  vi.clearAllMocks();
  vi.unstubAllEnvs();
}

export function snapshotArray<T>(items: T[]) {
  return items.map((item) =>
    typeof item === "object" && item !== null
      ? structuredClone(item)
      : item,
  );
}

export function restoreArray<T>(target: T[], snapshot: T[]) {
  target.splice(0, target.length, ...snapshotArray(snapshot));
}
