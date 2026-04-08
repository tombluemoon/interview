import { describe, expect, it } from "vitest";

import {
  createJsonRequest,
  loginAs,
  mockNextRequestContext,
  readJson,
  setupIntegrationDatabase,
} from "@/tests/integration/test-harness";

setupIntegrationDatabase();

describe("integration routes: systematic route matrix", () => {
  it("returns 401 across all protected user endpoints without a session", async () => {
    mockNextRequestContext();

    const meRoute = await import("@/app/api/v1/me/route");
    const passwordRoute = await import("@/app/api/v1/me/password/route");
    const dailyPlanRoute = await import(
      "@/app/api/v1/me/daily-plans/[date]/route"
    );
    const reportsRoute = await import("@/app/api/v1/me/reports/overview/route");
    const tasksRoute = await import("@/app/api/v1/me/tasks/route");
    const taskRoute = await import("@/app/api/v1/me/tasks/[taskId]/route");
    const completeTaskRoute = await import(
      "@/app/api/v1/me/tasks/[taskId]/complete/route"
    );
    const reopenTaskRoute = await import(
      "@/app/api/v1/me/tasks/[taskId]/reopen/route"
    );
    const carryOverTaskRoute = await import(
      "@/app/api/v1/me/tasks/[taskId]/carry-over/route"
    );
    const questionProgressRoute = await import(
      "@/app/api/v1/me/question-progress/[questionId]/route"
    );

    const cases = [
      {
        label: "GET /me",
        run: () => meRoute.GET(),
      },
      {
        label: "PUT /me",
        run: () =>
          meRoute.PUT(
            createJsonRequest(
              "http://localhost/api/v1/me",
              {
                display_name: "Alex",
                email: "alex@example.com",
                preferred_tracks: ["AI"],
              },
              "PUT",
            ),
          ),
      },
      {
        label: "PUT /me/password",
        run: () =>
          passwordRoute.PUT(
            createJsonRequest(
              "http://localhost/api/v1/me/password",
              {
                current_password: "demo1234",
                new_password: "newpass1234",
                confirm_password: "newpass1234",
              },
              "PUT",
            ),
          ),
      },
      {
        label: "GET /me/daily-plans/:date",
        run: () =>
          dailyPlanRoute.GET(new Request("http://localhost"), {
            params: Promise.resolve({
              date: "2026-04-07",
            }),
          }),
      },
      {
        label: "GET /me/reports/overview",
        run: () =>
          reportsRoute.GET(
            new Request("http://localhost/api/v1/me/reports/overview"),
          ),
      },
      {
        label: "GET /me/tasks",
        run: () => tasksRoute.GET(),
      },
      {
        label: "POST /me/tasks",
        run: () =>
          tasksRoute.POST(
            createJsonRequest("http://localhost/api/v1/me/tasks", {
              title: "Should fail before parsing",
              task_type: "FREEFORM",
              priority: 3,
            }),
          ),
      },
      {
        label: "PUT /me/tasks/:id",
        run: () =>
          taskRoute.PUT(
            createJsonRequest(
              "http://localhost/api/v1/me/tasks/task_1",
              {
                title: "Should fail before parsing",
                task_type: "FREEFORM",
                priority: 3,
              },
              "PUT",
            ),
            {
              params: Promise.resolve({
                taskId: "task_1",
              }),
            },
          ),
      },
      {
        label: "DELETE /me/tasks/:id",
        run: () =>
          taskRoute.DELETE(new Request("http://localhost"), {
            params: Promise.resolve({
              taskId: "task_1",
            }),
          }),
      },
      {
        label: "POST /me/tasks/:id/complete",
        run: () =>
          completeTaskRoute.POST(new Request("http://localhost"), {
            params: Promise.resolve({
              taskId: "task_1",
            }),
          }),
      },
      {
        label: "POST /me/tasks/:id/reopen",
        run: () =>
          reopenTaskRoute.POST(new Request("http://localhost"), {
            params: Promise.resolve({
              taskId: "task_1",
            }),
          }),
      },
      {
        label: "POST /me/tasks/:id/carry-over",
        run: () =>
          carryOverTaskRoute.POST(new Request("http://localhost"), {
            params: Promise.resolve({
              taskId: "task_1",
            }),
          }),
      },
      {
        label: "PUT /me/question-progress/:id",
        run: () =>
          questionProgressRoute.PUT(
            createJsonRequest(
              "http://localhost/api/v1/me/question-progress/q_rag",
              {
                progress_status: "REVIEWED",
              },
              "PUT",
            ),
            {
              params: Promise.resolve({
                questionId: "q_rag",
              }),
            },
          ),
      },
    ];

    for (const testCase of cases) {
      const response = await testCase.run();
      expect(response.status, testCase.label).toBe(401);
      await expect(
        readJson<{
          error: {
            code: string;
          };
        }>(response),
      ).resolves.toMatchObject({
        error: {
          code: "UNAUTHORIZED",
        },
      });
    }
  });

  it("returns 403 across all admin endpoints for authenticated non-admin users", async () => {
    await loginAs("alex@example.com", "demo1234");

    const categoriesRoute = await import("@/app/api/v1/admin/categories/route");
    const categoryRoute = await import(
      "@/app/api/v1/admin/categories/[categoryId]/route"
    );
    const questionsRoute = await import("@/app/api/v1/admin/questions/route");
    const questionRoute = await import(
      "@/app/api/v1/admin/questions/[questionId]/route"
    );

    const cases = [
      {
        label: "GET /admin/categories",
        run: () => categoriesRoute.GET(),
      },
      {
        label: "POST /admin/categories",
        run: () =>
          categoriesRoute.POST(
            createJsonRequest("http://localhost/api/v1/admin/categories", {
              name: "Blocked",
              slug: "blocked",
              description: "Should fail on authorization.",
            }),
          ),
      },
      {
        label: "GET /admin/categories/:id",
        run: () =>
          categoryRoute.GET(new Request("http://localhost"), {
            params: Promise.resolve({
              categoryId: "cat_ai",
            }),
          }),
      },
      {
        label: "PUT /admin/categories/:id",
        run: () =>
          categoryRoute.PUT(
            createJsonRequest(
              "http://localhost/api/v1/admin/categories/cat_ai",
              {
                name: "Blocked",
                slug: "blocked",
                description: "Should fail on authorization.",
              },
              "PUT",
            ),
            {
              params: Promise.resolve({
                categoryId: "cat_ai",
              }),
            },
          ),
      },
      {
        label: "DELETE /admin/categories/:id",
        run: () =>
          categoryRoute.DELETE(new Request("http://localhost"), {
            params: Promise.resolve({
              categoryId: "cat_ai",
            }),
          }),
      },
      {
        label: "GET /admin/questions",
        run: () =>
          questionsRoute.GET(
            new Request("http://localhost/api/v1/admin/questions"),
          ),
      },
      {
        label: "POST /admin/questions",
        run: () =>
          questionsRoute.POST(
            createJsonRequest("http://localhost/api/v1/admin/questions", {
              title: "Blocked question",
              slug: "blocked-question",
              category_id: "cat_ai",
              difficulty: "Medium",
              tags: "blocked",
              excerpt: "Blocked",
              body: "Blocked",
              visibility: "PUBLIC",
              content_status: "PUBLISHED",
            }),
          ),
      },
      {
        label: "GET /admin/questions/:id",
        run: () =>
          questionRoute.GET(new Request("http://localhost"), {
            params: Promise.resolve({
              questionId: "q_rag",
            }),
          }),
      },
      {
        label: "PUT /admin/questions/:id",
        run: () =>
          questionRoute.PUT(
            createJsonRequest(
              "http://localhost/api/v1/admin/questions/q_rag",
              {
                title: "Blocked question",
                slug: "blocked-question",
                category_id: "cat_ai",
                difficulty: "Medium",
                tags: "blocked",
                excerpt: "Blocked",
                body: "Blocked",
                visibility: "PUBLIC",
                content_status: "PUBLISHED",
              },
              "PUT",
            ),
            {
              params: Promise.resolve({
                questionId: "q_rag",
              }),
            },
          ),
      },
    ];

    for (const testCase of cases) {
      const response = await testCase.run();
      expect(response.status, testCase.label).toBe(403);
      await expect(
        readJson<{
          error: {
            code: string;
          };
        }>(response),
      ).resolves.toMatchObject({
        error: {
          code: "FORBIDDEN",
        },
      });
    }
  });

  it("surfaces route-level validation and not-found branches for auth and user endpoints", async () => {
    mockNextRequestContext();

    const loginRoute = await import("@/app/api/v1/auth/login/route");
    const signupRoute = await import("@/app/api/v1/auth/signup/route");

    const badLoginResponse = await loginRoute.POST(
      createJsonRequest("http://localhost/api/v1/auth/login", {
        email: "alex@example.com",
        password: "",
      }),
    );
    expect(badLoginResponse.status).toBe(400);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(badLoginResponse),
    ).resolves.toMatchObject({
      error: {
        code: "LOGIN_FAILED",
      },
    });

    const badSignupResponse = await signupRoute.POST(
      createJsonRequest("http://localhost/api/v1/auth/signup", {
        display_name: "User",
        email: "bad-email",
        password: "demo1234",
        confirm_password: "demo1234",
      }),
    );
    expect(badSignupResponse.status).toBe(400);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(badSignupResponse),
    ).resolves.toMatchObject({
      error: {
        code: "SIGNUP_FAILED",
      },
    });

    await loginAs("alex@example.com", "demo1234");

    const meRoute = await import("@/app/api/v1/me/route");
    const passwordRoute = await import("@/app/api/v1/me/password/route");
    const reportsRoute = await import("@/app/api/v1/me/reports/overview/route");
    const tasksRoute = await import("@/app/api/v1/me/tasks/route");
    const taskRoute = await import("@/app/api/v1/me/tasks/[taskId]/route");
    const completeTaskRoute = await import(
      "@/app/api/v1/me/tasks/[taskId]/complete/route"
    );
    const reopenTaskRoute = await import(
      "@/app/api/v1/me/tasks/[taskId]/reopen/route"
    );
    const carryOverTaskRoute = await import(
      "@/app/api/v1/me/tasks/[taskId]/carry-over/route"
    );

    const badProfileResponse = await meRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/me",
        {
          display_name: "Alex",
          email: "alex@example.com",
          preferred_tracks: ["UNKNOWN"],
        },
        "PUT",
      ),
    );
    expect(badProfileResponse.status).toBe(400);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(badProfileResponse),
    ).resolves.toMatchObject({
      error: {
        code: "BAD_REQUEST",
      },
    });

    const badPasswordResponse = await passwordRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/me/password",
        {
          current_password: "demo1234",
          new_password: "demo1234",
          confirm_password: "demo1234",
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
        code: "BAD_REQUEST",
      },
    });

    const invalidReportResponse = await reportsRoute.GET(
      new Request(
        "http://localhost/api/v1/me/reports/overview?range=999&category=missing",
      ),
    );
    expect(invalidReportResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          tasksCompletedInRange: number;
          reviewedQuestions: number;
          masteredQuestions: number;
          currentStreak: number;
        };
      }>(invalidReportResponse),
    ).resolves.toMatchObject({
      data: {
        tasksCompletedInRange: 6,
        reviewedQuestions: 2,
        masteredQuestions: 1,
        currentStreak: expect.any(Number),
      },
    });

    const invalidTaskResponse = await tasksRoute.POST(
      createJsonRequest("http://localhost/api/v1/me/tasks", {
        title: "Bad task",
        task_type: "FREEFORM",
        priority: 9,
      }),
    );
    expect(invalidTaskResponse.status).toBe(400);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(invalidTaskResponse),
    ).resolves.toMatchObject({
      error: {
        code: "VALIDATION_ERROR",
      },
    });

    const missingTaskId = "task_missing_route_matrix";

    const missingTaskPutResponse = await taskRoute.PUT(
      createJsonRequest(
        `http://localhost/api/v1/me/tasks/${missingTaskId}`,
        {
          title: "Missing task",
          task_type: "FREEFORM",
          priority: 3,
        },
        "PUT",
      ),
      {
        params: Promise.resolve({
          taskId: missingTaskId,
        }),
      },
    );
    expect(missingTaskPutResponse.status).toBe(404);

    const missingTaskDeleteResponse = await taskRoute.DELETE(
      new Request(`http://localhost/api/v1/me/tasks/${missingTaskId}`, {
        method: "DELETE",
      }),
      {
        params: Promise.resolve({
          taskId: missingTaskId,
        }),
      },
    );
    expect(missingTaskDeleteResponse.status).toBe(404);

    const missingCompleteResponse = await completeTaskRoute.POST(
      new Request(
        `http://localhost/api/v1/me/tasks/${missingTaskId}/complete`,
        {
          method: "POST",
        },
      ),
      {
        params: Promise.resolve({
          taskId: missingTaskId,
        }),
      },
    );
    expect(missingCompleteResponse.status).toBe(404);

    const missingReopenResponse = await reopenTaskRoute.POST(
      new Request(
        `http://localhost/api/v1/me/tasks/${missingTaskId}/reopen`,
        {
          method: "POST",
        },
      ),
      {
        params: Promise.resolve({
          taskId: missingTaskId,
        }),
      },
    );
    expect(missingReopenResponse.status).toBe(404);

    const missingCarryOverResponse = await carryOverTaskRoute.POST(
      new Request(
        `http://localhost/api/v1/me/tasks/${missingTaskId}/carry-over`,
        {
          method: "POST",
        },
      ),
      {
        params: Promise.resolve({
          taskId: missingTaskId,
        }),
      },
    );
    expect(missingCarryOverResponse.status).toBe(404);
  });

  it("surfaces route-level conflict, validation, and not-found branches for admin endpoints", async () => {
    await loginAs("admin@example.com", "admin1234");

    const categoriesRoute = await import("@/app/api/v1/admin/categories/route");
    const categoryRoute = await import(
      "@/app/api/v1/admin/categories/[categoryId]/route"
    );
    const questionsRoute = await import("@/app/api/v1/admin/questions/route");
    const questionRoute = await import(
      "@/app/api/v1/admin/questions/[questionId]/route"
    );

    const duplicateCategoryResponse = await categoriesRoute.POST(
      createJsonRequest("http://localhost/api/v1/admin/categories", {
        name: "Duplicate AI",
        slug: "ai",
        description: "Should fail because the slug already exists.",
      }),
    );
    expect(duplicateCategoryResponse.status).toBe(409);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(duplicateCategoryResponse),
    ).resolves.toMatchObject({
      error: {
        code: "SLUG_TAKEN",
      },
    });

    const duplicateCategoryNameResponse = await categoriesRoute.POST(
      createJsonRequest("http://localhost/api/v1/admin/categories", {
        name: "AI",
        slug: "ai-duplicate-name",
        description: "Should fail because the category name already exists.",
      }),
    );
    expect(duplicateCategoryNameResponse.status).toBe(409);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(duplicateCategoryNameResponse),
    ).resolves.toMatchObject({
      error: {
        code: "NAME_TAKEN",
      },
    });

    const missingCategoryResponse = await categoryRoute.GET(
      new Request("http://localhost"),
      {
        params: Promise.resolve({
          categoryId: "cat_missing",
        }),
      },
    );
    expect(missingCategoryResponse.status).toBe(404);

    const invalidCategoryUpdateResponse = await categoryRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/admin/categories/cat_ai",
        {
          name: "",
          slug: "still-invalid",
          description: "",
        },
        "PUT",
      ),
      {
        params: Promise.resolve({
          categoryId: "cat_ai",
        }),
      },
    );
    expect(invalidCategoryUpdateResponse.status).toBe(400);

    const deleteMissingCategoryResponse = await categoryRoute.DELETE(
      new Request("http://localhost"),
      {
        params: Promise.resolve({
          categoryId: "cat_missing",
        }),
      },
    );
    expect(deleteMissingCategoryResponse.status).toBe(404);

    const invalidQuestionCreateResponse = await questionsRoute.POST(
      createJsonRequest("http://localhost/api/v1/admin/questions", {
        title: "Broken question",
        slug: "broken-question",
        category_id: "missing-category",
        difficulty: "Medium",
        tags: "broken",
        excerpt: "Broken",
        body: "Broken",
        visibility: "PUBLIC",
        content_status: "PUBLISHED",
      }),
    );
    expect(invalidQuestionCreateResponse.status).toBe(400);

    const duplicateQuestionResponse = await questionsRoute.POST(
      createJsonRequest("http://localhost/api/v1/admin/questions", {
        title: "Duplicate slug question",
        slug: "lru-cache",
        category_id: "cat_algorithms",
        difficulty: "Medium",
        tags: "duplicate",
        excerpt: "Duplicate",
        body: "Duplicate",
        visibility: "PUBLIC",
        content_status: "PUBLISHED",
      }),
    );
    expect(duplicateQuestionResponse.status).toBe(409);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(duplicateQuestionResponse),
    ).resolves.toMatchObject({
      error: {
        code: "SLUG_TAKEN",
      },
    });

    const missingQuestionResponse = await questionRoute.GET(
      new Request("http://localhost"),
      {
        params: Promise.resolve({
          questionId: "q_missing",
        }),
      },
    );
    expect(missingQuestionResponse.status).toBe(404);

    const updateMissingQuestionResponse = await questionRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/admin/questions/q_missing",
        {
          title: "Still missing",
          slug: "still-missing",
          category_id: "cat_ai",
          difficulty: "Medium",
          tags: "missing",
          excerpt: "Missing",
          body: "Missing",
          visibility: "PUBLIC",
          content_status: "PUBLISHED",
        },
        "PUT",
      ),
      {
        params: Promise.resolve({
          questionId: "q_missing",
        }),
      },
    );
    expect(updateMissingQuestionResponse.status).toBe(404);
  });
});
