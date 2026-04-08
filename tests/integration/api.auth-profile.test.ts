import { describe, expect, it } from "vitest";

import {
  createJsonRequest,
  mockNextRequestContext,
  readJson,
  setupIntegrationDatabase,
} from "@/tests/integration/test-harness";

setupIntegrationDatabase();

describe("integration routes: auth and profile api", () => {
  it("signs up a user, updates profile, changes password, and logs in again", async () => {
    const { cookieStore } = mockNextRequestContext();

    const signupRoute = await import("@/app/api/v1/auth/signup/route");
    const loginRoute = await import("@/app/api/v1/auth/login/route");
    const logoutRoute = await import("@/app/api/v1/auth/logout/route");
    const meRoute = await import("@/app/api/v1/me/route");
    const passwordRoute = await import("@/app/api/v1/me/password/route");

    const unauthorizedMeResponse = await meRoute.GET();
    expect(unauthorizedMeResponse.status).toBe(401);

    const uniqueEmail = `integration.user.${Date.now()}@example.com`;
    const updatedEmail = `integration.user.updated.${Date.now()}@example.com`;
    const originalPassword = "demo1234";
    const newPassword = "newpass1234";

    const signupResponse = await signupRoute.POST(
      createJsonRequest("http://localhost/api/v1/auth/signup", {
        display_name: "Integration User",
        email: uniqueEmail,
        password: originalPassword,
        confirm_password: originalPassword,
      }),
    );
    expect(signupResponse.status).toBe(201);
    await expect(
      readJson<{
        data: {
          created: boolean;
          demoMode: boolean;
          user: {
            email: string;
          };
        };
      }>(signupResponse),
    ).resolves.toMatchObject({
      data: {
        created: true,
        demoMode: false,
        user: {
          email: uniqueEmail,
        },
      },
    });
    expect(cookieStore.snapshot().interview_review_session).toHaveLength(64);

    const meResponse = await meRoute.GET();
    expect(meResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          displayName: string;
          email: string;
          preferredTracks: string[];
        };
      }>(meResponse),
    ).resolves.toMatchObject({
      data: {
        displayName: "Integration User",
        email: uniqueEmail,
      },
    });

    const updateProfileResponse = await meRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/me",
        {
          display_name: "Integration User Updated",
          email: updatedEmail,
          preferred_tracks: ["AI", "SQL"],
        },
        "PUT",
      ),
    );
    expect(updateProfileResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          displayName: string;
          email: string;
          preferredTracks: string[];
        };
      }>(updateProfileResponse),
    ).resolves.toMatchObject({
      data: {
        displayName: "Integration User Updated",
        email: updatedEmail,
        preferredTracks: ["AI", "SQL"],
      },
    });

    const badPasswordResponse = await passwordRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/me/password",
        {
          current_password: "wrong-pass",
          new_password: newPassword,
          confirm_password: newPassword,
        },
        "PUT",
      ),
    );
    expect(badPasswordResponse.status).toBe(400);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(badPasswordResponse),
    ).resolves.toMatchObject({
      error: {
        code: "CURRENT_PASSWORD_INVALID",
      },
    });

    const changePasswordResponse = await passwordRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/me/password",
        {
          current_password: originalPassword,
          new_password: newPassword,
          confirm_password: newPassword,
        },
        "PUT",
      ),
    );
    expect(changePasswordResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          success: boolean;
        };
      }>(changePasswordResponse),
    ).resolves.toEqual({
      data: {
        success: true,
      },
    });
    expect(cookieStore.snapshot().interview_review_session).toBeUndefined();

    const meAfterPasswordChangeResponse = await meRoute.GET();
    expect(meAfterPasswordChangeResponse.status).toBe(401);

    const logoutResponse = await logoutRoute.POST();
    expect(logoutResponse.status).toBe(200);
    expect(cookieStore.snapshot().interview_review_session).toBeUndefined();

    const oldPasswordLoginResponse = await loginRoute.POST(
      createJsonRequest("http://localhost/api/v1/auth/login", {
        email: updatedEmail,
        password: originalPassword,
      }),
    );
    expect(oldPasswordLoginResponse.status).toBe(401);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(oldPasswordLoginResponse),
    ).resolves.toMatchObject({
      error: {
        code: "INVALID_CREDENTIALS",
      },
    });

    const newPasswordLoginResponse = await loginRoute.POST(
      createJsonRequest("http://localhost/api/v1/auth/login", {
        email: updatedEmail,
        password: newPassword,
      }),
    );
    expect(newPasswordLoginResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          user: {
            email: string;
          };
        };
      }>(newPasswordLoginResponse),
    ).resolves.toMatchObject({
      data: {
        user: {
          email: updatedEmail,
        },
      },
    });
  });

  it("rejects duplicate signup emails and duplicate profile emails", async () => {
    const { cookieStore } = mockNextRequestContext();

    const signupRoute = await import("@/app/api/v1/auth/signup/route");
    const meRoute = await import("@/app/api/v1/me/route");

    const duplicateSignupResponse = await signupRoute.POST(
      createJsonRequest("http://localhost/api/v1/auth/signup", {
        display_name: "Another Alex",
        email: "alex@example.com",
        password: "demo1234",
        confirm_password: "demo1234",
      }),
    );
    expect(duplicateSignupResponse.status).toBe(409);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(duplicateSignupResponse),
    ).resolves.toMatchObject({
      error: {
        code: "EMAIL_TAKEN",
      },
    });

    const loginRoute = await import("@/app/api/v1/auth/login/route");
    const loginResponse = await loginRoute.POST(
      createJsonRequest("http://localhost/api/v1/auth/login", {
        email: "alex@example.com",
        password: "demo1234",
      }),
    );
    expect(loginResponse.status).toBe(200);
    expect(cookieStore.snapshot().interview_review_session).toHaveLength(64);

    const duplicateProfileEmailResponse = await meRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/me",
        {
          display_name: "Alex Zhang",
          email: "admin@example.com",
          preferred_tracks: ["AI"],
        },
        "PUT",
      ),
    );
    expect(duplicateProfileEmailResponse.status).toBe(409);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(duplicateProfileEmailResponse),
    ).resolves.toMatchObject({
      error: {
        code: "EMAIL_TAKEN",
      },
    });
  });
});
