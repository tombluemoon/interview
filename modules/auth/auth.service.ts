import { randomUUID } from "node:crypto";

import { getSql, isDatabaseConfigured } from "@/lib/db";
import {
  createSessionToken,
  hashPassword,
  hashSessionToken,
  normalizeEmail,
  SESSION_MAX_AGE_SECONDS,
  verifyPassword,
} from "@/modules/auth/auth.helpers";
import type { LoginInput, SignupInput } from "@/modules/auth/auth.validation";
import type { UserProfile } from "@/types/domain";

const DEFAULT_TRACKS = ["Java Core", "SQL", "Algorithms", "AI"];

interface UserRow {
  id: string;
  displayName: string;
  email: string;
  role: "USER" | "ADMIN";
  preferredTracks: string[];
  passwordHash: string;
}

interface SessionUserRow {
  id: string;
  displayName: string;
  email: string;
  role: "USER" | "ADMIN";
  preferredTracks: string[];
}

export class AuthServiceError extends Error {
  code: string;
  status: number;

  constructor(message: string, code: string, status: number) {
    super(message);
    this.name = "AuthServiceError";
    this.code = code;
    this.status = status;
  }
}

function mapUserRow(row: SessionUserRow): UserProfile {
  return {
    id: row.id,
    displayName: row.displayName,
    email: row.email,
    role: row.role,
    preferredTracks: row.preferredTracks,
  };
}

function requireDatabaseForAuth() {
  if (!isDatabaseConfigured()) {
    throw new AuthServiceError(
      "Authentication requires DATABASE_URL to be configured.",
      "AUTH_UNAVAILABLE",
      503,
    );
  }
}

export function isAuthServiceError(error: unknown): error is AuthServiceError {
  return error instanceof AuthServiceError;
}

export async function createUserAccount(input: SignupInput) {
  requireDatabaseForAuth();

  const sql = getSql();
  const email = normalizeEmail(input.email);
  const existing = await sql<{ id: string }[]>`
    SELECT id
    FROM users
    WHERE email = ${email}
    LIMIT 1
  `;

  if (existing[0]) {
    throw new AuthServiceError(
      "An account with this email already exists.",
      "EMAIL_TAKEN",
      409,
    );
  }

  const passwordHash = await hashPassword(input.password);
  const rows = await sql<SessionUserRow[]>`
    INSERT INTO users (
      id,
      display_name,
      email,
      role,
      preferred_tracks,
      password_hash
    )
    VALUES (
      ${`user_${randomUUID().replaceAll("-", "").slice(0, 12)}`},
      ${input.displayName},
      ${email},
      'USER',
      ${DEFAULT_TRACKS},
      ${passwordHash}
    )
    RETURNING
      id,
      display_name AS "displayName",
      email,
      role,
      preferred_tracks AS "preferredTracks"
  `;

  if (!rows[0]) {
    throw new AuthServiceError(
      "Account creation failed.",
      "SIGNUP_FAILED",
      500,
    );
  }

  return mapUserRow(rows[0]);
}

export async function authenticateUser(input: LoginInput) {
  requireDatabaseForAuth();

  const sql = getSql();
  const email = normalizeEmail(input.email);
  const rows = await sql<UserRow[]>`
    SELECT
      id,
      display_name AS "displayName",
      email,
      role,
      preferred_tracks AS "preferredTracks",
      password_hash AS "passwordHash"
    FROM users
    WHERE email = ${email}
    LIMIT 1
  `;
  const user = rows[0];

  if (!user?.passwordHash) {
    throw new AuthServiceError(
      "Invalid email or password.",
      "INVALID_CREDENTIALS",
      401,
    );
  }

  const passwordMatches = await verifyPassword(input.password, user.passwordHash);

  if (!passwordMatches) {
    throw new AuthServiceError(
      "Invalid email or password.",
      "INVALID_CREDENTIALS",
      401,
    );
  }

  return mapUserRow(user);
}

export async function createUserSession(userId: string) {
  requireDatabaseForAuth();

  const sql = getSql();
  const token = createSessionToken();
  const tokenHash = hashSessionToken(token);
  const expiresAt = new Date(Date.now() + SESSION_MAX_AGE_SECONDS * 1000);

  await sql`
    DELETE FROM user_sessions
    WHERE user_id = ${userId}
      AND expires_at <= NOW()
  `;

  await sql`
    INSERT INTO user_sessions (
      id,
      user_id,
      token_hash,
      expires_at
    )
    VALUES (
      ${`session_${randomUUID().replaceAll("-", "").slice(0, 16)}`},
      ${userId},
      ${tokenHash},
      ${expiresAt.toISOString()}
    )
  `;

  return {
    token,
    expiresAt,
  };
}

export async function getUserBySessionToken(token: string) {
  requireDatabaseForAuth();

  const sql = getSql();
  const tokenHash = hashSessionToken(token);
  const rows = await sql<SessionUserRow[]>`
    SELECT
      u.id,
      u.display_name AS "displayName",
      u.email,
      u.role,
      u.preferred_tracks AS "preferredTracks"
    FROM user_sessions s
    INNER JOIN users u
      ON u.id = s.user_id
    WHERE s.token_hash = ${tokenHash}
      AND s.expires_at > NOW()
    LIMIT 1
  `;

  if (!rows[0]) {
    await sql`
      DELETE FROM user_sessions
      WHERE token_hash = ${tokenHash}
        OR expires_at <= NOW()
    `;

    return null;
  }

  return mapUserRow(rows[0]);
}

export async function deleteUserSession(token: string) {
  if (!isDatabaseConfigured()) {
    return;
  }

  const sql = getSql();

  await sql`
    DELETE FROM user_sessions
    WHERE token_hash = ${hashSessionToken(token)}
  `;
}
