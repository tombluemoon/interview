import { describe, expect, it } from "vitest";

import {
  parseLoginInput,
  parseSignupInput,
} from "@/modules/auth/auth.validation";

describe("auth validation", () => {
  it("parses login input", () => {
    expect(
      parseLoginInput({
        email: "  Alex@Example.com ",
        password: "demo1234",
        nextPath: "/questions",
      }),
    ).toEqual({
      email: "alex@example.com",
      password: "demo1234",
      nextPath: "/questions",
    });
  });

  it("rejects invalid login email", () => {
    expect(() =>
      parseLoginInput({
        password: "demo1234",
      }),
    ).toThrow("Email is required.");
    expect(() =>
      parseLoginInput({
        email: "alex",
        password: "demo1234",
      }),
    ).toThrow("Email format is invalid.");
  });

  it("rejects missing and short passwords", () => {
    expect(() =>
      parseLoginInput({
        email: "alex@example.com",
      }),
    ).toThrow("Password is required.");
    expect(() =>
      parseLoginInput({
        email: "alex@example.com",
        password: "",
      }),
    ).toThrow("Password is required.");
    expect(() =>
      parseLoginInput({
        email: "alex@example.com",
        password: "short",
      }),
    ).toThrow("Password must be at least 8 characters.");
  });

  it("parses signup input", () => {
    expect(
      parseSignupInput({
        displayName: "  Alex Zhang ",
        email: "ALEX@example.com",
        password: "demo1234",
        confirmPassword: "demo1234",
        nextPath: "/questions/rag-service",
      }),
    ).toEqual({
      displayName: "Alex Zhang",
      email: "alex@example.com",
      password: "demo1234",
      nextPath: "/questions/rag-service",
    });
  });

  it("drops non-string next paths on successful auth parsing", () => {
    expect(
      parseLoginInput({
        email: "alex@example.com",
        password: "demo1234",
        nextPath: 123,
      }),
    ).toEqual({
      email: "alex@example.com",
      password: "demo1234",
      nextPath: undefined,
    });
    expect(
      parseSignupInput({
        displayName: "Alex Zhang",
        email: "alex@example.com",
        password: "demo1234",
        confirmPassword: "demo1234",
        nextPath: 123,
      }),
    ).toEqual({
      displayName: "Alex Zhang",
      email: "alex@example.com",
      password: "demo1234",
      nextPath: undefined,
    });
  });

  it("rejects mismatched signup passwords", () => {
    expect(() =>
      parseSignupInput({
        displayName: "Alex",
        email: "alex@example.com",
        password: "demo1234",
        confirmPassword: "demo9999",
      }),
    ).toThrow("Passwords do not match.");
  });

  it("rejects invalid signup display names", () => {
    expect(() =>
      parseSignupInput({
        email: "alex@example.com",
        password: "demo1234",
        confirmPassword: "demo1234",
      }),
    ).toThrow("Display name is required.");
    expect(() =>
      parseSignupInput({
        displayName: "",
        email: "alex@example.com",
        password: "demo1234",
        confirmPassword: "demo1234",
      }),
    ).toThrow("Display name is required.");
    expect(() =>
      parseSignupInput({
        displayName: "A",
        email: "alex@example.com",
        password: "demo1234",
        confirmPassword: "demo1234",
      }),
    ).toThrow("Display name must be at least 2 characters.");
  });

  it("rejects missing signup emails", () => {
    expect(() =>
      parseSignupInput({
        displayName: "Alex",
        password: "demo1234",
        confirmPassword: "demo1234",
      }),
    ).toThrow("Email is required.");
  });

  it("rejects missing confirmation passwords", () => {
    expect(() =>
      parseSignupInput({
        displayName: "Alex",
        email: "alex@example.com",
        password: "demo1234",
      }),
    ).toThrow("Passwords do not match.");
  });
});
