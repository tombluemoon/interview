import { describe, expect, it } from "vitest";

import {
  mockNextRequestContext,
  readJson,
  setupIntegrationDatabase,
} from "@/tests/integration/test-harness";

setupIntegrationDatabase();

describe("integration routes: auth, tasks, and reports", () => {
  it("logs in, creates and completes a task, reads reports, and logs out", async () => {
    const { cookieStore } = mockNextRequestContext();
    const loginRoute = await import("@/app/api/v1/auth/login/route");
    const logoutRoute = await import("@/app/api/v1/auth/logout/route");
    const tasksRoute = await import("@/app/api/v1/me/tasks/route");
    const completeTaskRoute = await import(
      "@/app/api/v1/me/tasks/[taskId]/complete/route"
    );
    const reportsRoute = await import("@/app/api/v1/me/reports/overview/route");
    const authService = await import("@/modules/auth/auth.service");

    const unauthorizedResponse = await tasksRoute.GET();
    expect(unauthorizedResponse.status).toBe(401);

    const loginResponse = await loginRoute.POST(
      new Request("http://localhost/api/v1/auth/login", {
        method: "POST",
        headers: {
          "content-type": "application/json",
        },
        body: JSON.stringify({
          email: "alex@example.com",
          password: "demo1234",
        }),
      }),
    );

    expect(loginResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          user: {
            email: string;
          };
          demoMode: boolean;
        };
      }>(loginResponse),
    ).resolves.toMatchObject({
      data: {
        user: {
          email: "alex@example.com",
        },
        demoMode: false,
      },
    });

    const sessionToken = cookieStore.snapshot().interview_review_session;
    expect(sessionToken).toHaveLength(64);
    await expect(authService.getUserBySessionToken(sessionToken)).resolves.toMatchObject({
      id: "user_demo",
      email: "alex@example.com",
    });

    const tasksResponse = await tasksRoute.GET();
    expect(tasksResponse.status).toBe(200);
    const tasksBody = await readJson<{
      data: Array<{
        id: string;
      }>;
    }>(tasksResponse);
    expect(tasksBody.data).toHaveLength(5);
    expect(tasksBody.data.map((task) => task.id)).toEqual(
      expect.arrayContaining([
        "task_sql_today_01",
        "task_ai_today_01",
        "task_alg_today_01",
        "task_java_today_01",
        "task_sql_today_02",
      ]),
    );

    const createTaskResponse = await tasksRoute.POST(
      new Request("http://localhost/api/v1/me/tasks", {
        method: "POST",
        headers: {
          "content-type": "application/json",
        },
        body: JSON.stringify({
          title: "Practice one AI system answer",
          task_type: "CATEGORY_PRACTICE",
          priority: 5,
          category_name: "AI",
        }),
      }),
    );

    expect(createTaskResponse.status).toBe(201);
    const createdTaskBody = await readJson<{
      data: {
        id: string;
        status: string;
        categoryName?: string;
      };
    }>(createTaskResponse);
    expect(createdTaskBody.data).toMatchObject({
      status: "PENDING",
      categoryName: "AI",
    });

    const completeTaskResponse = await completeTaskRoute.POST(
      new Request(
        `http://localhost/api/v1/me/tasks/${createdTaskBody.data.id}/complete`,
        {
          method: "POST",
        },
      ),
      {
        params: Promise.resolve({
          taskId: createdTaskBody.data.id,
        }),
      },
    );

    expect(completeTaskResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          status: string;
          completedAt?: string;
        };
      }>(completeTaskResponse),
    ).resolves.toMatchObject({
      data: {
        id: createdTaskBody.data.id,
        status: "COMPLETED",
        completedAt: expect.any(String),
      },
    });

    const reportsResponse = await reportsRoute.GET(
      new Request(
        "http://localhost/api/v1/me/reports/overview?range=7&category=cat_ai",
      ),
    );

    expect(reportsResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          tasksCompletedInRange: number;
          reviewedQuestions: number;
          masteredQuestions: number;
          currentStreak: number;
        };
      }>(reportsResponse),
    ).resolves.toEqual({
      data: {
        tasksCompletedInRange: 3,
        reviewedQuestions: 1,
        masteredQuestions: 1,
        currentStreak: 2,
      },
    });

    const logoutResponse = await logoutRoute.POST();
    expect(logoutResponse.status).toBe(200);
    expect(cookieStore.snapshot().interview_review_session).toBeUndefined();
    await expect(authService.getUserBySessionToken(sessionToken)).resolves.toBeNull();

    const afterLogoutResponse = await tasksRoute.GET();
    expect(afterLogoutResponse.status).toBe(401);
  });
});
