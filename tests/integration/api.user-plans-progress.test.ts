import { describe, expect, it } from "vitest";

import {
  createJsonRequest,
  loginAs,
  mockNextRequestContext,
  readJson,
  setupIntegrationDatabase,
} from "@/tests/integration/test-harness";

setupIntegrationDatabase();

describe("integration routes: user plans, tasks, and progress api", () => {
  it("reads plans by date and manages the full task lifecycle", async () => {
    await loginAs("alex@example.com", "demo1234");

    const dailyPlanRoute = await import(
      "@/app/api/v1/me/daily-plans/[date]/route"
    );
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
    const { getLocalPlanDate } = await import("@/modules/daily-plan/daily-plan.dates");

    const today = getLocalPlanDate();
    const tomorrow = getLocalPlanDate(1);

    const todayPlanResponse = await dailyPlanRoute.GET(new Request("http://localhost"), {
      params: Promise.resolve({
        date: today,
      }),
    });
    expect(todayPlanResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          planDate: string;
          tasks: Array<{
            id: string;
          }>;
        };
      }>(todayPlanResponse),
    ).resolves.toMatchObject({
      data: {
        planDate: today,
        tasks: expect.arrayContaining([
          expect.objectContaining({
            id: "task_sql_today_01",
          }),
        ]),
      },
    });

    const invalidDateResponse = await dailyPlanRoute.GET(new Request("http://localhost"), {
      params: Promise.resolve({
        date: "2026-13-99",
      }),
    });
    expect(invalidDateResponse.status).toBe(400);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(invalidDateResponse),
    ).resolves.toMatchObject({
      error: {
        code: "VALIDATION_ERROR",
      },
    });

    const invalidCategoryResponse = await tasksRoute.POST(
      createJsonRequest("http://localhost/api/v1/me/tasks", {
        title: "Invalid category task",
        task_type: "CATEGORY_PRACTICE",
        priority: 4,
        category_name: "Missing",
      }),
    );
    expect(invalidCategoryResponse.status).toBe(400);
    await expect(
      readJson<{
        error: {
          code: string;
          message: string;
        };
      }>(invalidCategoryResponse),
    ).resolves.toMatchObject({
      error: {
        code: "VALIDATION_ERROR",
        message: "Category is invalid.",
      },
    });

    const createTaskResponse = await tasksRoute.POST(
      createJsonRequest("http://localhost/api/v1/me/tasks", {
        title: "Integration lifecycle task",
        task_type: "FREEFORM",
        priority: 4,
        category_name: "AI",
      }),
    );
    expect(createTaskResponse.status).toBe(201);
    const createdTask = await readJson<{
      data: {
        id: string;
        title: string;
        status: string;
      };
    }>(createTaskResponse);

    const updateTaskResponse = await taskRoute.PUT(
      createJsonRequest(
        `http://localhost/api/v1/me/tasks/${createdTask.data.id}`,
        {
          title: "Integration lifecycle task updated",
          task_type: "CATEGORY_PRACTICE",
          priority: 5,
          category_name: "SQL",
        },
        "PUT",
      ),
      {
        params: Promise.resolve({
          taskId: createdTask.data.id,
        }),
      },
    );
    expect(updateTaskResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          title: string;
          categoryName?: string;
          priority: number;
        };
      }>(updateTaskResponse),
    ).resolves.toMatchObject({
      data: {
        id: createdTask.data.id,
        title: "Integration lifecycle task updated",
        categoryName: "SQL",
        priority: 5,
      },
    });

    const completeTaskResponse = await completeTaskRoute.POST(
      new Request(
        `http://localhost/api/v1/me/tasks/${createdTask.data.id}/complete`,
        {
          method: "POST",
        },
      ),
      {
        params: Promise.resolve({
          taskId: createdTask.data.id,
        }),
      },
    );
    expect(completeTaskResponse.status).toBe(200);

    const reopenTaskResponse = await reopenTaskRoute.POST(
      new Request(
        `http://localhost/api/v1/me/tasks/${createdTask.data.id}/reopen`,
        {
          method: "POST",
        },
      ),
      {
        params: Promise.resolve({
          taskId: createdTask.data.id,
        }),
      },
    );
    expect(reopenTaskResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          status: string;
        };
      }>(reopenTaskResponse),
    ).resolves.toMatchObject({
      data: {
        id: createdTask.data.id,
        status: "PENDING",
      },
    });

    const carryOverResponse = await carryOverTaskRoute.POST(
      new Request(
        `http://localhost/api/v1/me/tasks/${createdTask.data.id}/carry-over`,
        {
          method: "POST",
        },
      ),
      {
        params: Promise.resolve({
          taskId: createdTask.data.id,
        }),
      },
    );
    expect(carryOverResponse.status).toBe(200);
    const carryOverBody = await readJson<{
      data: {
        sourceTask: {
          id: string;
          status: string;
        };
        nextTask: {
          id: string;
          title: string;
          status: string;
        } | null;
      };
    }>(carryOverResponse);
    expect(carryOverBody.data).toMatchObject({
      sourceTask: {
        id: createdTask.data.id,
        status: "CARRIED_OVER",
      },
      nextTask: {
        title: "Integration lifecycle task updated",
        status: "PENDING",
      },
    });

    const tomorrowPlanResponse = await dailyPlanRoute.GET(new Request("http://localhost"), {
      params: Promise.resolve({
        date: tomorrow,
      }),
    });
    expect(tomorrowPlanResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          planDate: string;
          tasks: Array<{
            id: string;
          }>;
        };
      }>(tomorrowPlanResponse),
    ).resolves.toMatchObject({
      data: {
        planDate: tomorrow,
        tasks: expect.arrayContaining([
          expect.objectContaining({
            id: carryOverBody.data.nextTask?.id,
          }),
        ]),
      },
    });

    const deleteTaskResponse = await taskRoute.DELETE(
      new Request(
        `http://localhost/api/v1/me/tasks/${carryOverBody.data.nextTask?.id}`,
        {
          method: "DELETE",
        },
      ),
      {
        params: Promise.resolve({
          taskId: carryOverBody.data.nextTask?.id ?? "",
        }),
      },
    );
    expect(deleteTaskResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          deletedTaskId: string;
        };
      }>(deleteTaskResponse),
    ).resolves.toEqual({
      data: {
        deletedTaskId: carryOverBody.data.nextTask?.id ?? "",
      },
    });

    const tomorrowAfterDeleteResponse = await dailyPlanRoute.GET(
      new Request("http://localhost"),
      {
        params: Promise.resolve({
          date: tomorrow,
        }),
      },
    );
    expect(tomorrowAfterDeleteResponse.status).toBe(200);
    const tomorrowAfterDeleteBody = await readJson<{
      data: {
        tasks: Array<{
          id: string;
        }>;
      };
    }>(tomorrowAfterDeleteResponse);
    expect(
      tomorrowAfterDeleteBody.data.tasks.map((task) => task.id),
    ).not.toContain(carryOverBody.data.nextTask?.id);
  });

  it("updates question progress and exposes it through authenticated public reads", async () => {
    await loginAs("alex@example.com", "demo1234");

    const questionProgressRoute = await import(
      "@/app/api/v1/me/question-progress/[questionId]/route"
    );
    const publicQuestionRoute = await import(
      "@/app/api/v1/public/questions/[questionId]/route"
    );

    const invalidProgressResponse = await questionProgressRoute.PUT(
      createJsonRequest(
        "http://localhost/api/v1/me/question-progress/q_rag",
        {
          progress_status: "BAD_STATUS",
        },
        "PUT",
      ),
      {
        params: Promise.resolve({
          questionId: "q_rag",
        }),
      },
    );
    expect(invalidProgressResponse.status).toBe(400);

    const progressResponse = await questionProgressRoute.PUT(
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
    );
    expect(progressResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          questionId: string;
          progressStatus: string;
        };
      }>(progressResponse),
    ).resolves.toEqual({
      data: {
        questionId: "q_rag",
        progressStatus: "REVIEWED",
      },
    });

    const publicQuestionResponse = await publicQuestionRoute.GET(
      new Request("http://localhost"),
      {
        params: Promise.resolve({
          questionId: "q_rag",
        }),
      },
    );
    expect(publicQuestionResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          progressStatus?: string;
        };
      }>(publicQuestionResponse),
    ).resolves.toMatchObject({
      data: {
        id: "q_rag",
        progressStatus: "REVIEWED",
      },
    });
  });

  it("rejects authenticated user routes when no session exists", async () => {
    mockNextRequestContext();

    const taskRoute = await import("@/app/api/v1/me/tasks/[taskId]/route");
    const questionProgressRoute = await import(
      "@/app/api/v1/me/question-progress/[questionId]/route"
    );

    const deleteResponse = await taskRoute.DELETE(new Request("http://localhost"), {
      params: Promise.resolve({
        taskId: "task_sql_today_01",
      }),
    });
    expect(deleteResponse.status).toBe(401);

    const progressResponse = await questionProgressRoute.PUT(
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
    );
    expect(progressResponse.status).toBe(401);
  });
});
