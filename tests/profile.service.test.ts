import { afterEach, describe, expect, it } from "vitest";

import { hashPassword } from "@/modules/auth/auth.helpers";
import type {
  PasswordChangeInput,
  ProfileUpdateInput,
} from "@/modules/profile/profile.validation";

import {
  importWithDbMock,
  importWithoutDb,
  restoreModuleMocks,
} from "@/tests/test-utils";

const updateInput: ProfileUpdateInput = {
  displayName: "Updated Alex",
  email: "updated@example.com",
  preferredTracks: ["AI", "SQL"],
};

const passwordInput: PasswordChangeInput = {
  currentPassword: "demo1234",
  newPassword: "demo5678",
};

describe("profile.service", () => {
  afterEach(() => {
    restoreModuleMocks();
  });

  it("detects profile service errors", async () => {
    const profileService = await importWithoutDb<
      typeof import("@/modules/profile/profile.service")
    >("@/modules/profile/profile.service");

    expect(
      profileService.isProfileServiceError(
        new profileService.ProfileServiceError("Boom", "PROFILE", 500),
      ),
    ).toBe(true);
    expect(profileService.isProfileServiceError(new Error("boom"))).toBe(false);
  });

  it("handles mock-mode profile reads and updates", async () => {
    const profileService = await importWithoutDb<
      typeof import("@/modules/profile/profile.service")
    >("@/modules/profile/profile.service");

    await expect(profileService.getProfile()).resolves.toMatchObject({
      id: "user_demo",
      email: "alex@example.com",
    });
    await expect(profileService.getProfile("admin_demo")).resolves.toMatchObject({
      id: "admin_demo",
      email: "admin@example.com",
    });
    await expect(profileService.updateProfile("user_demo", updateInput)).resolves.toMatchObject({
      displayName: "Updated Alex",
      email: "updated@example.com",
      preferredTracks: ["AI", "SQL"],
    });
    await expect(
      profileService.updateProfile("admin_demo", {
        ...updateInput,
        email: "updated@example.com",
      }),
    ).rejects.toMatchObject({
      code: "EMAIL_TAKEN",
      status: 409,
    });
  });

  it("handles mock-mode password changes", async () => {
    const profileService = await importWithoutDb<
      typeof import("@/modules/profile/profile.service")
    >("@/modules/profile/profile.service");

    await expect(profileService.changePassword("user_demo", passwordInput)).resolves.toBeUndefined();
    await expect(
      profileService.changePassword("admin_demo", {
        currentPassword: "admin1234",
        newPassword: "demo5678",
      }),
    ).resolves.toBeUndefined();
    await expect(
      profileService.changePassword("user_demo", {
        ...passwordInput,
        currentPassword: "wrong-pass",
      }),
    ).rejects.toMatchObject({
      code: "CURRENT_PASSWORD_INVALID",
      status: 400,
    });
  });

  it("reads and updates profiles in database mode", async () => {
    let loaded = await importWithDbMock<typeof import("@/modules/profile/profile.service")>(
      "@/modules/profile/profile.service",
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

    await expect(loaded.module.getProfile("user_demo")).resolves.toEqual({
      id: "user_demo",
      displayName: "Alex Zhang",
      email: "alex@example.com",
      role: "USER",
      preferredTracks: ["AI"],
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/profile/profile.service")>(
      "@/modules/profile/profile.service",
      [[]],
    );

    await expect(loaded.module.getProfile("missing")).rejects.toThrow("Profile not found.");
    await expect(loaded.module.getProfile()).rejects.toThrow("User context is required.");

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/profile/profile.service")>(
      "@/modules/profile/profile.service",
      [
        [],
        [
          {
            id: "user_demo",
            displayName: "Updated Alex",
            email: "updated@example.com",
            role: "USER",
            preferredTracks: ["AI", "SQL"],
          },
        ],
      ],
    );

    await expect(loaded.module.updateProfile("user_demo", updateInput)).resolves.toEqual({
      id: "user_demo",
      displayName: "Updated Alex",
      email: "updated@example.com",
      role: "USER",
      preferredTracks: ["AI", "SQL"],
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/profile/profile.service")>(
      "@/modules/profile/profile.service",
      [[{ id: "other_user" }]],
    );

    await expect(loaded.module.updateProfile("user_demo", updateInput)).rejects.toMatchObject({
      code: "EMAIL_TAKEN",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/profile/profile.service")>(
      "@/modules/profile/profile.service",
      [[], []],
    );

    await expect(loaded.module.updateProfile("missing", updateInput)).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });
  });

  it("changes passwords in database mode", async () => {
    let loaded = await importWithDbMock<typeof import("@/modules/profile/profile.service")>(
      "@/modules/profile/profile.service",
      [
        [
          {
            id: "user_demo",
            passwordHash: await hashPassword("demo1234"),
          },
        ],
        [],
        [],
      ],
    );

    await expect(loaded.module.changePassword("user_demo", passwordInput)).resolves.toBeUndefined();
    expect(
      loaded.executedStatements.some((statement) =>
        statement.includes("UPDATE users"),
      ),
    ).toBe(true);
    expect(
      loaded.executedStatements.some((statement) =>
        statement.includes("DELETE FROM user_sessions"),
      ),
    ).toBe(true);

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/profile/profile.service")>(
      "@/modules/profile/profile.service",
      [[]],
    );

    await expect(loaded.module.changePassword("missing", passwordInput)).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/profile/profile.service")>(
      "@/modules/profile/profile.service",
      [
        [
          {
            id: "user_demo",
            passwordHash: await hashPassword("wrong-pass"),
          },
        ],
      ],
    );

    await expect(loaded.module.changePassword("user_demo", passwordInput)).rejects.toMatchObject({
      code: "CURRENT_PASSWORD_INVALID",
      status: 400,
    });
  });
});
