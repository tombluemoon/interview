import { afterEach, describe, expect, it, vi } from "vitest";

describe("lib/db", () => {
  afterEach(() => {
    vi.resetModules();
    vi.doUnmock("postgres");
    vi.unstubAllEnvs();
    delete global.__interviewReviewSql;
  });

  it("reports when the database is not configured", async () => {
    vi.stubEnv("DATABASE_URL", "");

    const { getSql, isDatabaseConfigured } = await import("@/lib/db");

    expect(isDatabaseConfigured()).toBe(false);
    expect(() => getSql()).toThrow("DATABASE_URL is not configured.");
  });

  it("creates and caches a sql instance in development", async () => {
    vi.stubEnv("DATABASE_URL", "postgresql://example.test/app");
    vi.stubEnv("NODE_ENV", "development");

    const fakeSql = { kind: "sql" };
    const postgresMock = vi.fn(() => fakeSql);

    vi.doMock("postgres", () => ({
      default: postgresMock,
    }));

    const { getSql, isDatabaseConfigured } = await import("@/lib/db");

    expect(isDatabaseConfigured()).toBe(true);
    expect(getSql()).toBe(fakeSql);
    expect(global.__interviewReviewSql).toBe(fakeSql);
    expect(postgresMock).toHaveBeenCalledWith(
      "postgresql://example.test/app",
      expect.objectContaining({
        max: 1,
        idle_timeout: 5,
        connect_timeout: 10,
        onnotice: expect.any(Function),
      }),
    );

    const options = postgresMock.mock.calls[0]?.[1] as { onnotice: () => void };
    expect(() => options.onnotice()).not.toThrow();
  });

  it("reuses the global sql instance when already present", async () => {
    vi.stubEnv("DATABASE_URL", "postgresql://example.test/app");
    vi.stubEnv("NODE_ENV", "development");

    const cachedSql = { kind: "cached" };
    global.__interviewReviewSql = cachedSql as never;
    const postgresMock = vi.fn(() => ({ kind: "new" }));

    vi.doMock("postgres", () => ({
      default: postgresMock,
    }));

    const { getSql } = await import("@/lib/db");

    expect(getSql()).toBe(cachedSql);
    expect(postgresMock).not.toHaveBeenCalled();
  });

  it("does not write to the global cache in production", async () => {
    vi.stubEnv("DATABASE_URL", "postgresql://example.test/app");
    vi.stubEnv("NODE_ENV", "production");

    const fakeSql = { kind: "prod" };
    const postgresMock = vi.fn(() => fakeSql);

    vi.doMock("postgres", () => ({
      default: postgresMock,
    }));

    const { getSql } = await import("@/lib/db");

    expect(getSql()).toBe(fakeSql);
    expect(global.__interviewReviewSql).toBeUndefined();
  });
});
