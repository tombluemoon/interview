import { describe, expect, it } from "vitest";

import {
  createSessionToken,
  getDefaultRedirectPath,
  getPostAuthRedirectPath,
  hashSessionToken,
  hashPassword,
  sanitizeNextPath,
  verifyPassword,
} from "@/modules/auth/auth.helpers";

describe("auth helpers", () => {
  it("hashes and verifies passwords", async () => {
    const hash = await hashPassword("demo1234");

    await expect(verifyPassword("demo1234", hash)).resolves.toBe(true);
    await expect(verifyPassword("wrong-pass", hash)).resolves.toBe(false);
    await expect(verifyPassword("demo1234", "invalid")).resolves.toBe(false);
    await expect(verifyPassword("demo1234", "scrypt$salt$zz")).resolves.toBe(
      false,
    );
  });

  it("sanitizes next paths", () => {
    expect(sanitizeNextPath("/questions/rag-service")).toBe(
      "/questions/rag-service",
    );
    expect(sanitizeNextPath("https://example.com")).toBeUndefined();
    expect(sanitizeNextPath("//evil.example.com")).toBeUndefined();
    expect(sanitizeNextPath(undefined)).toBeUndefined();
  });

  it("uses role-specific default redirects and token helpers", () => {
    const token = createSessionToken();

    expect(token).toHaveLength(64);
    expect(hashSessionToken(token)).toHaveLength(64);
    expect(getDefaultRedirectPath("USER")).toBe("/app/today");
    expect(getDefaultRedirectPath("ADMIN")).toBe("/admin/questions");
    expect(getPostAuthRedirectPath("USER", "/questions")).toBe("/questions");
    expect(getPostAuthRedirectPath("ADMIN", null)).toBe("/admin/questions");
  });
});
