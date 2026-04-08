import { afterEach, describe, expect, it } from "vitest";

import { hashPassword } from "@/modules/auth/auth.helpers";
import type {
  LoginInput,
  SignupInput,
} from "@/modules/auth/auth.validation";

import {
  importWithDbMock,
  importWithoutDb,
  restoreModuleMocks,
} from "@/tests/test-utils";

const signupInput: SignupInput = {
  displayName: "Alex",
  email: "alex@example.com",
  password: "demo1234",
  nextPath: undefined,
};

const loginInput: LoginInput = {
  email: "alex@example.com",
  password: "demo1234",
  nextPath: undefined,
};

describe("auth.service", () => {
  afterEach(() => {
    restoreModuleMocks();
  });

  it("detects auth service errors", async () => {
    const authService = await importWithoutDb<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
    );

    expect(
      authService.isAuthServiceError(
        new authService.AuthServiceError("Boom", "AUTH", 500),
      ),
    ).toBe(true);
    expect(authService.isAuthServiceError(new Error("boom"))).toBe(false);
  });

  it("requires a configured database for auth-only operations", async () => {
    const authService = await importWithoutDb<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
    );

    await expect(authService.createUserAccount(signupInput)).rejects.toMatchObject({
      code: "AUTH_UNAVAILABLE",
      status: 503,
    });
    await expect(authService.authenticateUser(loginInput)).rejects.toMatchObject({
      code: "AUTH_UNAVAILABLE",
      status: 503,
    });
    await expect(authService.createUserSession("user_demo")).rejects.toMatchObject({
      code: "AUTH_UNAVAILABLE",
      status: 503,
    });
    await expect(authService.getUserBySessionToken("token")).rejects.toMatchObject({
      code: "AUTH_UNAVAILABLE",
      status: 503,
    });
    await expect(authService.deleteUserSession("token")).resolves.toBeUndefined();
  });

  it("creates a new user account", async () => {
    const { module: authService } = await importWithDbMock<
      typeof import("@/modules/auth/auth.service")
    >("@/modules/auth/auth.service", [
      [],
      [
        {
          id: "user_new",
          displayName: "Alex",
          email: "alex@example.com",
          role: "USER",
          preferredTracks: ["Java Core", "SQL", "Algorithms", "AI"],
        },
      ],
    ]);

    await expect(authService.createUserAccount(signupInput)).resolves.toEqual({
      id: "user_new",
      displayName: "Alex",
      email: "alex@example.com",
      role: "USER",
      preferredTracks: ["Java Core", "SQL", "Algorithms", "AI"],
    });
  });

  it("rejects duplicate signup emails and empty inserts", async () => {
    let loaded = await importWithDbMock<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
      [[{ id: "existing" }]],
    );

    await expect(loaded.module.createUserAccount(signupInput)).rejects.toMatchObject({
      code: "EMAIL_TAKEN",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
      [[], []],
    );

    await expect(loaded.module.createUserAccount(signupInput)).rejects.toMatchObject({
      code: "SIGNUP_FAILED",
      status: 500,
    });
  });

  it("authenticates valid users and rejects invalid credentials", async () => {
    const validHash = await hashPassword("demo1234");
    let loaded = await importWithDbMock<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
      [
        [
          {
            id: "user_demo",
            displayName: "Alex Zhang",
            email: "alex@example.com",
            role: "USER",
            preferredTracks: ["AI"],
            passwordHash: validHash,
          },
        ],
      ],
    );

    await expect(loaded.module.authenticateUser(loginInput)).resolves.toEqual({
      id: "user_demo",
      displayName: "Alex Zhang",
      email: "alex@example.com",
      role: "USER",
      preferredTracks: ["AI"],
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
      [[{ id: "user_demo", displayName: "Alex", email: "alex@example.com", role: "USER", preferredTracks: [], passwordHash: "" }]],
    );

    await expect(loaded.module.authenticateUser(loginInput)).rejects.toMatchObject({
      code: "INVALID_CREDENTIALS",
      status: 401,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
      [
        [
          {
            id: "user_demo",
            displayName: "Alex Zhang",
            email: "alex@example.com",
            role: "USER",
            preferredTracks: ["AI"],
            passwordHash: await hashPassword("wrong-pass"),
          },
        ],
      ],
    );

    await expect(loaded.module.authenticateUser(loginInput)).rejects.toMatchObject({
      code: "INVALID_CREDENTIALS",
      status: 401,
    });
  });

  it("creates and deletes sessions", async () => {
    const { module: authService } = await importWithDbMock<
      typeof import("@/modules/auth/auth.service")
    >("@/modules/auth/auth.service", [[], []]);

    const session = await authService.createUserSession("user_demo");

    expect(session.token).toHaveLength(64);
    expect(session.expiresAt).toBeInstanceOf(Date);

    await expect(authService.deleteUserSession(session.token)).resolves.toBeUndefined();
  });

  it("loads users by session token and clears missing sessions", async () => {
    let loaded = await importWithDbMock<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
      [
        [
          {
            id: "user_demo",
            displayName: "Alex Zhang",
            email: "alex@example.com",
            role: "USER",
            preferredTracks: ["AI"],
          },
        ],
      ],
    );

    await expect(loaded.module.getUserBySessionToken("token")).resolves.toEqual({
      id: "user_demo",
      displayName: "Alex Zhang",
      email: "alex@example.com",
      role: "USER",
      preferredTracks: ["AI"],
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/auth/auth.service")>(
      "@/modules/auth/auth.service",
      [[], []],
    );

    await expect(loaded.module.getUserBySessionToken("missing")).resolves.toBeNull();
  });
});
