import { createHash, randomBytes, scrypt, timingSafeEqual } from "node:crypto";
import { promisify } from "node:util";

import type { UserRole } from "@/types/domain";

const scryptAsync = promisify(scrypt);

export const DEFAULT_USER_REDIRECT = "/app/today";
export const DEFAULT_ADMIN_REDIRECT = "/admin/questions";
export const SESSION_MAX_AGE_SECONDS = 60 * 60 * 24 * 30;

export async function hashPassword(password: string) {
  const salt = randomBytes(16).toString("hex");
  const derivedKey = (await scryptAsync(password, salt, 64)) as Buffer;

  return `scrypt$${salt}$${derivedKey.toString("hex")}`;
}

export async function verifyPassword(
  password: string,
  storedHash: string,
) {
  const [algorithm, salt, expectedHash] = storedHash.split("$");

  if (algorithm !== "scrypt" || !salt || !expectedHash) {
    return false;
  }

  const derivedKey = (await scryptAsync(
    password,
    salt,
    expectedHash.length / 2,
  )) as Buffer;
  const expectedBuffer = Buffer.from(expectedHash, "hex");

  if (derivedKey.length !== expectedBuffer.length) {
    return false;
  }

  return timingSafeEqual(derivedKey, expectedBuffer);
}

export function createSessionToken() {
  return randomBytes(32).toString("hex");
}

export function hashSessionToken(token: string) {
  return createHash("sha256").update(token).digest("hex");
}

export function normalizeEmail(email: string) {
  return email.trim().toLowerCase();
}

export function sanitizeNextPath(nextPath?: string | null) {
  if (!nextPath || !nextPath.startsWith("/") || nextPath.startsWith("//")) {
    return undefined;
  }

  return nextPath;
}

export function getDefaultRedirectPath(role: UserRole) {
  return role === "ADMIN" ? DEFAULT_ADMIN_REDIRECT : DEFAULT_USER_REDIRECT;
}

export function getPostAuthRedirectPath(role: UserRole, nextPath?: string | null) {
  return sanitizeNextPath(nextPath) ?? getDefaultRedirectPath(role);
}
