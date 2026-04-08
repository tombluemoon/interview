import { afterEach, describe, expect, it, vi } from "vitest";

import type { UserProfile } from "@/types/domain";

import { restoreModuleMocks } from "@/tests/test-utils";

function redirectError(path: string) {
  return new Error(`REDIRECT:${path}`);
}

async function importAuthWithMocks(options?: {
  databaseConfigured?: boolean;
  cookieToken?: string;
  userByToken?: UserProfile | null;
  createSessionResult?: { token: string; expiresAt: Date };
}) {
  const cookieStore = {
    get: vi.fn((key: string) =>
      options?.cookieToken && key === "interview_review_session"
        ? { value: options.cookieToken }
        : undefined,
    ),
    set: vi.fn(),
    delete: vi.fn(),
  };
  const getUserBySessionToken = vi.fn(async () => options?.userByToken ?? null);
  const createUserSession = vi.fn(
    async () =>
      options?.createSessionResult ?? {
        token: "session-token",
        expiresAt: new Date("2026-05-01T00:00:00Z"),
      },
  );
  const deleteUserSession = vi.fn(async () => undefined);
  const redirect = vi.fn((path: string) => {
    throw redirectError(path);
  });

  vi.resetModules();
  vi.doMock("@/lib/db", () => ({
    isDatabaseConfigured: () => options?.databaseConfigured ?? true,
  }));
  vi.doMock("next/headers", () => ({
    cookies: vi.fn(async () => cookieStore),
  }));
  vi.doMock("next/navigation", () => ({
    redirect,
  }));
  vi.doMock("@/modules/auth/auth.service", () => ({
    getUserBySessionToken,
    createUserSession,
    deleteUserSession,
  }));

  const auth = await import("@/lib/auth");

  return {
    auth,
    cookieStore,
    getUserBySessionToken,
    createUserSession,
    deleteUserSession,
    redirect,
  };
}

describe("lib/auth", () => {
  afterEach(() => {
    restoreModuleMocks();
  });

  it("blocks protected sessions when the database is disabled", async () => {
    const { auth } = await importAuthWithMocks({
      databaseConfigured: false,
    });

    await expect(auth.getSession()).resolves.toBeNull();
    await expect(auth.requireSession()).rejects.toThrow(
      "REDIRECT:/login?error=auth_unavailable",
    );
    await expect(auth.requireAdminSession()).rejects.toThrow(
      "REDIRECT:/login?error=auth_unavailable",
    );
    await expect(
      auth.startSession({
        id: "user_demo",
        displayName: "Alex Zhang",
        email: "alex@example.com",
        role: "USER",
        preferredTracks: ["AI"],
      }),
    ).resolves.toMatchObject({
      role: "USER",
      demoMode: true,
    });
    await expect(
      auth.startSession({
        id: "admin_demo",
        displayName: "Content Admin",
        email: "admin@example.com",
        role: "ADMIN",
        preferredTracks: ["AI"],
      }),
    ).resolves.toMatchObject({
      role: "ADMIN",
      demoMode: true,
    });
  });

  it("reads authenticated sessions from cookies", async () => {
    let loaded = await importAuthWithMocks({
      cookieToken: "",
      userByToken: null,
    });

    await expect(loaded.auth.getSession()).resolves.toBeNull();

    restoreModuleMocks();

    loaded = await importAuthWithMocks({
      cookieToken: "token",
      userByToken: null,
    });

    await expect(loaded.auth.getSession()).resolves.toBeNull();
    expect(loaded.getUserBySessionToken).toHaveBeenCalledWith("token");

    restoreModuleMocks();

    loaded = await importAuthWithMocks({
      cookieToken: "token",
      userByToken: {
        id: "admin_demo",
        displayName: "Content Admin",
        email: "admin@example.com",
        role: "ADMIN",
        preferredTracks: ["AI"],
      },
    });

    await expect(loaded.auth.getSession("USER")).resolves.toBeNull();
    await expect(loaded.auth.getSession()).resolves.toEqual({
      user: {
        id: "admin_demo",
        displayName: "Content Admin",
        email: "admin@example.com",
        role: "ADMIN",
        preferredTracks: ["AI"],
      },
      role: "ADMIN",
      demoMode: false,
    });
    await expect(loaded.auth.requireAdminSession()).resolves.toEqual({
      user: {
        id: "admin_demo",
        displayName: "Content Admin",
        email: "admin@example.com",
        role: "ADMIN",
        preferredTracks: ["AI"],
      },
      role: "ADMIN",
      demoMode: false,
    });
  });

  it("redirects unauthenticated and unauthorized requests", async () => {
    let loaded = await importAuthWithMocks({
      cookieToken: "",
      userByToken: null,
    });

    await expect(loaded.auth.requireSession()).rejects.toThrow("REDIRECT:/login");
    await expect(loaded.auth.requireAdminSession()).rejects.toThrow(
      "REDIRECT:/login",
    );

    restoreModuleMocks();

    loaded = await importAuthWithMocks({
      cookieToken: "token",
      userByToken: {
        id: "user_demo",
        displayName: "Alex Zhang",
        email: "alex@example.com",
        role: "USER",
        preferredTracks: ["AI"],
      },
    });

    await expect(loaded.auth.requireSession()).resolves.toMatchObject({
      role: "USER",
      demoMode: false,
    });
    await expect(loaded.auth.requireAdminSession()).rejects.toThrow(
      "REDIRECT:/app/today",
    );
  });

  it("creates and clears persistent sessions", async () => {
    const expiresAt = new Date("2026-05-01T00:00:00Z");
    const loaded = await importAuthWithMocks({
      cookieToken: "existing-token",
      userByToken: {
        id: "user_demo",
        displayName: "Alex Zhang",
        email: "alex@example.com",
        role: "USER",
        preferredTracks: ["AI"],
      },
      createSessionResult: {
        token: "session-token",
        expiresAt,
      },
    });

    await expect(
      loaded.auth.startSession({
        id: "user_demo",
        displayName: "Alex Zhang",
        email: "alex@example.com",
        role: "USER",
        preferredTracks: ["AI"],
      }),
    ).resolves.toEqual({
      user: {
        id: "user_demo",
        displayName: "Alex Zhang",
        email: "alex@example.com",
        role: "USER",
        preferredTracks: ["AI"],
      },
      role: "USER",
      demoMode: false,
    });
    expect(loaded.createUserSession).toHaveBeenCalledWith("user_demo");
    expect(loaded.cookieStore.set).toHaveBeenCalledWith(
      "interview_review_session",
      "session-token",
      expect.objectContaining({
        httpOnly: true,
        sameSite: "lax",
        secure: false,
        path: "/",
        expires: expiresAt,
      }),
    );

    await expect(loaded.auth.endSession()).resolves.toBeUndefined();
    expect(loaded.deleteUserSession).toHaveBeenCalledWith("existing-token");
    expect(loaded.cookieStore.delete).toHaveBeenCalledWith(
      "interview_review_session",
    );

    restoreModuleMocks();

    const withoutToken = await importAuthWithMocks({
      cookieToken: "",
      userByToken: null,
    });

    await expect(withoutToken.auth.endSession()).resolves.toBeUndefined();
    expect(withoutToken.deleteUserSession).not.toHaveBeenCalled();
    expect(withoutToken.cookieStore.delete).toHaveBeenCalledWith(
      "interview_review_session",
    );
  });

  it("marks cookies as secure in production", async () => {
    vi.stubEnv("NODE_ENV", "production");

    const expiresAt = new Date("2026-05-01T00:00:00Z");
    const loaded = await importAuthWithMocks({
      createSessionResult: {
        token: "prod-session-token",
        expiresAt,
      },
    });

    await expect(
      loaded.auth.startSession({
        id: "admin_demo",
        displayName: "Content Admin",
        email: "admin@example.com",
        role: "ADMIN",
        preferredTracks: ["AI"],
      }),
    ).resolves.toMatchObject({
      role: "ADMIN",
      demoMode: false,
    });
    expect(loaded.cookieStore.set).toHaveBeenCalledWith(
      "interview_review_session",
      "prod-session-token",
      expect.objectContaining({
        secure: true,
        expires: expiresAt,
      }),
    );
  });
});
