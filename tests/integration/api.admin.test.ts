import { describe, expect, it } from "vitest";

import {
  createJsonRequest,
  loginAs,
  mockNextRequestContext,
  readJson,
  setupIntegrationDatabase,
} from "@/tests/integration/test-harness";

setupIntegrationDatabase();

describe("integration routes: admin api", () => {
  it("rejects anonymous and non-admin access", async () => {
    mockNextRequestContext();
    const categoriesRoute = await import("@/app/api/v1/admin/categories/route");

    const anonymousResponse = await categoriesRoute.GET();
    expect(anonymousResponse.status).toBe(401);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(anonymousResponse),
    ).resolves.toMatchObject({
      error: {
        code: "UNAUTHORIZED",
      },
    });

    await loginAs("alex@example.com", "demo1234");
    const forbiddenResponse = await categoriesRoute.GET();
    expect(forbiddenResponse.status).toBe(403);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(forbiddenResponse),
    ).resolves.toMatchObject({
      error: {
        code: "FORBIDDEN",
      },
    });
  });

  it("lets admins manage categories and questions through the api", async () => {
    await loginAs("admin@example.com", "admin1234");

    const categoriesRoute = await import("@/app/api/v1/admin/categories/route");
    const categoryRoute = await import(
      "@/app/api/v1/admin/categories/[categoryId]/route"
    );
    const tasksRoute = await import("@/app/api/v1/me/tasks/route");
    const taskRoute = await import("@/app/api/v1/me/tasks/[taskId]/route");
    const questionsRoute = await import("@/app/api/v1/admin/questions/route");
    const questionRoute = await import(
      "@/app/api/v1/admin/questions/[questionId]/route"
    );

    const listCategoriesResponse = await categoriesRoute.GET();
    expect(listCategoriesResponse.status).toBe(200);
    const listCategoriesBody = await readJson<{
      data: Array<{
        id: string;
      }>;
    }>(listCategoriesResponse);
    expect(listCategoriesBody.data.map((category) => category.id)).toEqual(
      expect.arrayContaining(["cat_ai", "cat_sql", "cat_system"]),
    );

    const createCategoryResponse = await categoriesRoute.POST(
      new Request("http://localhost/api/v1/admin/categories", {
        method: "POST",
        headers: {
          "content-type": "application/json",
        },
        body: JSON.stringify({
          name: "Behavioral",
          slug: "behavioral",
          description: "Behavioral interview questions.",
        }),
      }),
    );

    expect(createCategoryResponse.status).toBe(201);
    const createdCategoryBody = await readJson<{
      data: {
        id: string;
        name: string;
        slug: string;
        questionCount: number;
      };
    }>(createCategoryResponse);
    expect(createdCategoryBody.data).toMatchObject({
      name: "Behavioral",
      slug: "behavioral",
      questionCount: 0,
    });

    const getCategoryResponse = await categoryRoute.GET(new Request("http://localhost"), {
      params: Promise.resolve({
        categoryId: createdCategoryBody.data.id,
      }),
    });
    expect(getCategoryResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          name: string;
        };
      }>(getCategoryResponse),
    ).resolves.toMatchObject({
      data: {
        id: createdCategoryBody.data.id,
        name: "Behavioral",
      },
    });

    const createQuestionResponse = await questionsRoute.POST(
      new Request("http://localhost/api/v1/admin/questions", {
        method: "POST",
        headers: {
          "content-type": "application/json",
        },
        body: JSON.stringify({
          title: "Tell me about a time you handled conflict.",
          slug: "handled-conflict",
          category_id: createdCategoryBody.data.id,
          difficulty: "Medium",
          tags: "behavioral, communication",
          excerpt: "",
          body: "Describe the situation, your actions, and the measurable outcome.",
          hint: "Use STAR and focus on your specific contribution.",
          reference_answer:
            "A strong answer is structured, specific, and ends with a measurable result.",
          related_slugs: "lru-cache",
          visibility: "PUBLIC",
          content_status: "PUBLISHED",
        }),
      }),
    );

    expect(createQuestionResponse.status).toBe(201);
    const createdQuestionBody = await readJson<{
      data: {
        id: string;
        slug: string;
        categoryId: string;
        categoryName: string;
      };
    }>(createQuestionResponse);
    expect(createdQuestionBody.data).toMatchObject({
      slug: "handled-conflict",
      categoryId: createdCategoryBody.data.id,
      categoryName: "Behavioral",
    });

    const filteredQuestionsResponse = await questionsRoute.GET(
      new Request(
        `http://localhost/api/v1/admin/questions?category=${createdCategoryBody.data.id}&status=PUBLISHED&q=conflict`,
      ),
    );
    expect(filteredQuestionsResponse.status).toBe(200);
    await expect(
      readJson<{
        data: Array<{
          id: string;
          slug: string;
          categoryName: string;
          statusLabel: string;
        }>;
      }>(filteredQuestionsResponse),
    ).resolves.toMatchObject({
      data: [
        {
          id: createdQuestionBody.data.id,
          slug: "handled-conflict",
          categoryName: "Behavioral",
          statusLabel: "Published",
        },
      ],
    });

    const updateQuestionResponse = await questionRoute.PUT(
      new Request(
        `http://localhost/api/v1/admin/questions/${createdQuestionBody.data.id}`,
        {
          method: "PUT",
          headers: {
            "content-type": "application/json",
          },
          body: JSON.stringify({
            title: "Tell me about a time you resolved team conflict.",
            slug: "resolved-team-conflict",
            category_id: createdCategoryBody.data.id,
            difficulty: "Hard",
            tags: "behavioral, leadership",
            excerpt: "Updated excerpt",
            body: "Explain the conflict, the trade-offs, and the final team outcome.",
            hint: "Show how you aligned stakeholders.",
            reference_answer:
              "A strong answer shows listening, decision-making, and a concrete result.",
            related_slugs: "rag-service",
            visibility: "PRIVATE",
            content_status: "DRAFT",
          }),
        },
      ),
      {
        params: Promise.resolve({
          questionId: createdQuestionBody.data.id,
        }),
      },
    );
    expect(updateQuestionResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          slug: string;
          difficulty: string;
          visibility: string;
          contentStatus: string;
        };
      }>(updateQuestionResponse),
    ).resolves.toMatchObject({
      data: {
        id: createdQuestionBody.data.id,
        slug: "resolved-team-conflict",
        difficulty: "Hard",
        visibility: "PRIVATE",
        contentStatus: "DRAFT",
      },
    });

    const getQuestionResponse = await questionRoute.GET(new Request("http://localhost"), {
      params: Promise.resolve({
        questionId: createdQuestionBody.data.id,
      }),
    });
    expect(getQuestionResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          categoryName: string;
          title: string;
        };
      }>(getQuestionResponse),
    ).resolves.toMatchObject({
      data: {
        id: createdQuestionBody.data.id,
        categoryName: "Behavioral",
        title: "Tell me about a time you resolved team conflict.",
      },
    });

    const deleteInUseCategoryResponse = await categoryRoute.DELETE(
      new Request(
        `http://localhost/api/v1/admin/categories/${createdCategoryBody.data.id}`,
      ),
      {
        params: Promise.resolve({
          categoryId: createdCategoryBody.data.id,
        }),
      },
    );
    expect(deleteInUseCategoryResponse.status).toBe(409);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(deleteInUseCategoryResponse),
    ).resolves.toMatchObject({
      error: {
        code: "CATEGORY_IN_USE",
      },
    });

    const deleteUnusedCategoryResponse = await categoriesRoute.POST(
      new Request("http://localhost/api/v1/admin/categories", {
        method: "POST",
        headers: {
          "content-type": "application/json",
        },
        body: JSON.stringify({
          name: "Unused",
          slug: "unused",
          description: "Temporary category for deletion coverage.",
        }),
      }),
    );
    expect(deleteUnusedCategoryResponse.status).toBe(201);
    const unusedCategoryBody = await readJson<{
      data: {
        id: string;
      };
    }>(deleteUnusedCategoryResponse);

    const createTaskResponse = await tasksRoute.POST(
      createJsonRequest("http://localhost/api/v1/me/tasks", {
        title: "Review temporary category",
        task_type: "CATEGORY_PRACTICE",
        priority: 3,
        category_name: "Unused",
      }),
    );
    expect(createTaskResponse.status).toBe(201);
    const createdTaskBody = await readJson<{
      data: {
        id: string;
      };
    }>(createTaskResponse);

    const deleteTaskLinkedCategoryResponse = await categoryRoute.DELETE(
      new Request(
        `http://localhost/api/v1/admin/categories/${unusedCategoryBody.data.id}`,
      ),
      {
        params: Promise.resolve({
          categoryId: unusedCategoryBody.data.id,
        }),
      },
    );
    expect(deleteTaskLinkedCategoryResponse.status).toBe(409);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(deleteTaskLinkedCategoryResponse),
    ).resolves.toMatchObject({
      error: {
        code: "CATEGORY_IN_USE",
      },
    });

    const deleteTaskResponse = await taskRoute.DELETE(
      new Request(
        `http://localhost/api/v1/me/tasks/${createdTaskBody.data.id}`,
        {
          method: "DELETE",
        },
      ),
      {
        params: Promise.resolve({
          taskId: createdTaskBody.data.id,
        }),
      },
    );
    expect(deleteTaskResponse.status).toBe(200);

    const deleteCategoryResponse = await categoryRoute.DELETE(
      new Request(
        `http://localhost/api/v1/admin/categories/${unusedCategoryBody.data.id}`,
      ),
      {
        params: Promise.resolve({
          categoryId: unusedCategoryBody.data.id,
        }),
      },
    );
    expect(deleteCategoryResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          slug: string;
        };
      }>(deleteCategoryResponse),
    ).resolves.toMatchObject({
      data: {
        id: unusedCategoryBody.data.id,
        slug: "unused",
      },
    });
  });
});
