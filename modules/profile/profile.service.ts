import { demoAdmin, demoUser } from "@/lib/mock-data";
import { getSql, isDatabaseConfigured } from "@/lib/db";
import {
  hashPassword,
  normalizeEmail,
  verifyPassword,
} from "@/modules/auth/auth.helpers";
import type {
  PasswordChangeInput,
  ProfileUpdateInput,
} from "@/modules/profile/profile.validation";

interface ProfileRow {
  id: string;
  displayName: string;
  email: string;
  role: "USER" | "ADMIN";
  preferredTracks: string[];
}

interface PasswordRow {
  id: string;
  passwordHash: string;
}

export class ProfileServiceError extends Error {
  code: string;
  status: number;

  constructor(message: string, code: string, status: number) {
    super(message);
    this.name = "ProfileServiceError";
    this.code = code;
    this.status = status;
  }
}

function getMockProfile(userId?: string) {
  if (userId === demoAdmin.id) {
    return demoAdmin;
  }

  return demoUser;
}

export function isProfileServiceError(
  error: unknown,
): error is ProfileServiceError {
  return error instanceof ProfileServiceError;
}

export async function getProfile(userId?: string) {
  if (!isDatabaseConfigured()) {
    return getMockProfile(userId);
  }

  if (!userId) {
    throw new Error("User context is required.");
  }

  const sql = getSql();
  const rows = await sql<ProfileRow[]>`
    SELECT
      id,
      display_name AS "displayName",
      email,
      role,
      preferred_tracks AS "preferredTracks"
    FROM users
    WHERE id = ${userId}
    LIMIT 1
  `;

  if (!rows[0]) {
    throw new Error("Profile not found.");
  }

  return rows[0];
}

export async function updateProfile(
  userId: string,
  input: ProfileUpdateInput,
) {
  if (!isDatabaseConfigured()) {
    const currentProfile = getMockProfile(userId);
    const otherProfile = currentProfile.id === demoUser.id ? demoAdmin : demoUser;
    const normalizedEmail = normalizeEmail(input.email);

    if (normalizeEmail(otherProfile.email) === normalizedEmail) {
      throw new ProfileServiceError(
        "That email is already in use.",
        "EMAIL_TAKEN",
        409,
      );
    }

    currentProfile.displayName = input.displayName;
    currentProfile.email = normalizedEmail;
    currentProfile.preferredTracks = input.preferredTracks;

    return currentProfile;
  }

  const sql = getSql();
  const email = normalizeEmail(input.email);
  const existingRows = await sql<{ id: string }[]>`
    SELECT id
    FROM users
    WHERE email = ${email}
      AND id <> ${userId}
    LIMIT 1
  `;

  if (existingRows[0]) {
    throw new ProfileServiceError(
      "That email is already in use.",
      "EMAIL_TAKEN",
      409,
    );
  }

  const rows = await sql<ProfileRow[]>`
    UPDATE users
    SET
      display_name = ${input.displayName},
      email = ${email},
      preferred_tracks = ${input.preferredTracks}
    WHERE id = ${userId}
    RETURNING
      id,
      display_name AS "displayName",
      email,
      role,
      preferred_tracks AS "preferredTracks"
  `;

  if (!rows[0]) {
    throw new ProfileServiceError("Profile not found.", "NOT_FOUND", 404);
  }

  return rows[0];
}

export async function changePassword(
  userId: string,
  input: PasswordChangeInput,
) {
  if (!isDatabaseConfigured()) {
    const mockPassword = userId === demoAdmin.id ? "admin1234" : "demo1234";

    if (input.currentPassword !== mockPassword) {
      throw new ProfileServiceError(
        "Current password is incorrect.",
        "CURRENT_PASSWORD_INVALID",
        400,
      );
    }

    return;
  }

  const sql = getSql();
  await sql.begin(async (transaction) => {
    const rows = await transaction<PasswordRow[]>`
      SELECT
        id,
        password_hash AS "passwordHash"
      FROM users
      WHERE id = ${userId}
      LIMIT 1
    `;
    const user = rows[0];

    if (!user) {
      throw new ProfileServiceError("Profile not found.", "NOT_FOUND", 404);
    }

    const passwordMatches = await verifyPassword(
      input.currentPassword,
      user.passwordHash,
    );

    if (!passwordMatches) {
      throw new ProfileServiceError(
        "Current password is incorrect.",
        "CURRENT_PASSWORD_INVALID",
        400,
      );
    }

    const passwordHash = await hashPassword(input.newPassword);

    await transaction`
      UPDATE users
      SET password_hash = ${passwordHash}
      WHERE id = ${userId}
    `;
    await transaction`
      DELETE FROM user_sessions
      WHERE user_id = ${userId}
    `;
  });
}
