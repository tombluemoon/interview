import { normalizeEmail, sanitizeNextPath } from "@/modules/auth/auth.helpers";

export interface LoginInput {
  email: string;
  password: string;
  nextPath?: string;
}

export interface SignupInput extends LoginInput {
  displayName: string;
}

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function parseEmail(value: unknown) {
  const email = typeof value === "string" ? normalizeEmail(value) : "";

  if (!email) {
    throw new Error("Email is required.");
  }

  if (!EMAIL_PATTERN.test(email)) {
    throw new Error("Email format is invalid.");
  }

  return email;
}

function parsePassword(value: unknown) {
  const password = typeof value === "string" ? value : "";

  if (!password) {
    throw new Error("Password is required.");
  }

  if (password.length < 8) {
    throw new Error("Password must be at least 8 characters.");
  }

  return password;
}

export function parseLoginInput(input: {
  email?: unknown;
  password?: unknown;
  nextPath?: unknown;
}): LoginInput {
  return {
    email: parseEmail(input.email),
    password: parsePassword(input.password),
    nextPath: sanitizeNextPath(
      typeof input.nextPath === "string" ? input.nextPath : undefined,
    ),
  };
}

export function parseSignupInput(input: {
  displayName?: unknown;
  email?: unknown;
  password?: unknown;
  confirmPassword?: unknown;
  nextPath?: unknown;
}): SignupInput {
  const displayName =
    typeof input.displayName === "string" ? input.displayName.trim() : "";

  if (!displayName) {
    throw new Error("Display name is required.");
  }

  if (displayName.length < 2) {
    throw new Error("Display name must be at least 2 characters.");
  }

  const password = parsePassword(input.password);
  const confirmPassword =
    typeof input.confirmPassword === "string" ? input.confirmPassword : "";

  if (password !== confirmPassword) {
    throw new Error("Passwords do not match.");
  }

  return {
    displayName,
    email: parseEmail(input.email),
    password,
    nextPath: sanitizeNextPath(
      typeof input.nextPath === "string" ? input.nextPath : undefined,
    ),
  };
}
