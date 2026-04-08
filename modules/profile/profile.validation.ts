import { normalizeEmail } from "@/modules/auth/auth.helpers";

export interface ProfileUpdateInput {
  displayName: string;
  email: string;
  preferredTracks: string[];
}

export interface PasswordChangeInput {
  currentPassword: string;
  newPassword: string;
}

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function parseRequiredPassword(value: unknown, fieldName: string) {
  const password = typeof value === "string" ? value : "";

  if (!password) {
    throw new Error(`${fieldName} is required.`);
  }

  if (password.length < 8) {
    throw new Error(`${fieldName} must be at least 8 characters.`);
  }

  return password;
}

function parseProfileEmail(value: unknown) {
  const email = typeof value === "string" ? normalizeEmail(value) : "";

  if (!email) {
    throw new Error("Email is required.");
  }

  if (!EMAIL_PATTERN.test(email)) {
    throw new Error("Email format is invalid.");
  }

  return email;
}

export function parseProfileUpdateInput(
  input: {
    displayName?: unknown;
    email?: unknown;
    preferredTracks?: unknown;
  },
  validTrackNames: string[],
): ProfileUpdateInput {
  const displayName =
    typeof input.displayName === "string" ? input.displayName.trim() : "";

  if (!displayName) {
    throw new Error("Display name is required.");
  }

  if (displayName.length < 2) {
    throw new Error("Display name must be at least 2 characters.");
  }

  const preferredTracks = Array.isArray(input.preferredTracks)
    ? Array.from(
        new Set(
          input.preferredTracks
            .filter((track): track is string => typeof track === "string")
            .map((track) => track.trim())
            .filter(Boolean),
        ),
      )
    : [];

  if (
    preferredTracks.some((track) => !validTrackNames.includes(track))
  ) {
    throw new Error("Preferred tracks are invalid.");
  }

  return {
    displayName,
    email: parseProfileEmail(input.email),
    preferredTracks,
  };
}

export function parsePasswordChangeInput(input: {
  currentPassword?: unknown;
  newPassword?: unknown;
  confirmPassword?: unknown;
}): PasswordChangeInput {
  const currentPassword = parseRequiredPassword(
    input.currentPassword,
    "Current password",
  );
  const newPassword = parseRequiredPassword(input.newPassword, "New password");
  const confirmPassword =
    typeof input.confirmPassword === "string" ? input.confirmPassword : "";

  if (newPassword !== confirmPassword) {
    throw new Error("New passwords do not match.");
  }

  if (currentPassword === newPassword) {
    throw new Error("New password must be different from the current password.");
  }

  return {
    currentPassword,
    newPassword,
  };
}
