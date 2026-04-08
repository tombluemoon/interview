import { describe, expect, it } from "vitest";

import {
  parsePasswordChangeInput,
  parseProfileUpdateInput,
} from "@/modules/profile/profile.validation";

describe("profile.validation", () => {
  it("parses a profile update payload", () => {
    expect(
      parseProfileUpdateInput(
        {
          displayName: "Alex Zhang",
          email: " ALEX@EXAMPLE.COM ",
          preferredTracks: ["AI", "SQL", "AI"],
        },
        ["AI", "SQL", "Algorithms"],
      ),
    ).toEqual({
      displayName: "Alex Zhang",
      email: "alex@example.com",
      preferredTracks: ["AI", "SQL"],
    });
  });

  it("rejects unknown preferred tracks", () => {
    expect(() =>
      parseProfileUpdateInput(
        {
          displayName: "Alex Zhang",
          email: "alex@example.com",
          preferredTracks: ["AI", "Unknown"],
        },
        ["AI", "SQL", "Algorithms"],
      ),
    ).toThrow("Preferred tracks are invalid.");
  });

  it("parses a password change payload", () => {
    expect(
      parsePasswordChangeInput({
        currentPassword: "demo1234",
        newPassword: "demo5678",
        confirmPassword: "demo5678",
      }),
    ).toEqual({
      currentPassword: "demo1234",
      newPassword: "demo5678",
    });
  });

  it("rejects unchanged passwords", () => {
    expect(() =>
      parsePasswordChangeInput({
        currentPassword: "demo1234",
        newPassword: "demo1234",
        confirmPassword: "demo1234",
      }),
    ).toThrow("New password must be different from the current password.");
  });

  it("rejects invalid profile updates and password changes", () => {
    expect(() =>
      parseProfileUpdateInput(
        {
          email: "alex@example.com",
          preferredTracks: [],
        },
        ["AI"],
      ),
    ).toThrow("Display name is required.");
    expect(() =>
      parseProfileUpdateInput(
        {
          displayName: "",
          email: "alex@example.com",
          preferredTracks: [],
        },
        ["AI"],
      ),
    ).toThrow("Display name is required.");
    expect(() =>
      parseProfileUpdateInput(
        {
          displayName: "A",
          email: "alex@example.com",
          preferredTracks: [],
        },
        ["AI"],
      ),
    ).toThrow("Display name must be at least 2 characters.");
    expect(() =>
      parseProfileUpdateInput(
        {
          displayName: "Alex",
          preferredTracks: [],
        },
        ["AI"],
      ),
    ).toThrow("Email is required.");
    expect(() =>
      parseProfileUpdateInput(
        {
          displayName: "Alex",
          email: "bad",
          preferredTracks: "AI",
        },
        ["AI"],
      ),
    ).toThrow("Email format is invalid.");
    expect(
      parseProfileUpdateInput(
        {
          displayName: "Alex",
          email: "alex@example.com",
          preferredTracks: undefined,
        },
        ["AI"],
      ),
    ).toEqual({
      displayName: "Alex",
      email: "alex@example.com",
      preferredTracks: [],
    });
    expect(() =>
      parsePasswordChangeInput({
        newPassword: "demo5678",
        confirmPassword: "demo5678",
      }),
    ).toThrow("Current password is required.");
    expect(() =>
      parsePasswordChangeInput({
        currentPassword: "",
        newPassword: "demo5678",
        confirmPassword: "demo5678",
      }),
    ).toThrow("Current password is required.");
    expect(() =>
      parsePasswordChangeInput({
        currentPassword: "demo1234",
        newPassword: "short",
        confirmPassword: "short",
      }),
    ).toThrow("New password must be at least 8 characters.");
    expect(() =>
      parsePasswordChangeInput({
        currentPassword: "demo1234",
        newPassword: "demo5678",
      }),
    ).toThrow("New passwords do not match.");
    expect(() =>
      parsePasswordChangeInput({
        currentPassword: "demo1234",
        newPassword: "demo5678",
        confirmPassword: "wrong5678",
      }),
    ).toThrow("New passwords do not match.");
  });
});
