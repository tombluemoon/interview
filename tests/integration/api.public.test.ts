import { describe, expect, it } from "vitest";

import {
  loginAs,
  mockNextRequestContext,
  readJson,
  setupIntegrationDatabase,
} from "@/tests/integration/test-harness";

setupIntegrationDatabase();

describe("integration routes: public api", () => {
  it("lists public categories and questions for anonymous users", async () => {
    mockNextRequestContext();

    const healthRoute = await import("@/app/api/v1/health/route");
    const categoriesRoute = await import("@/app/api/v1/public/categories/route");
    const questionsRoute = await import("@/app/api/v1/public/questions/route");
    const questionRoute = await import(
      "@/app/api/v1/public/questions/[questionId]/route"
    );

    const healthResponse = await healthRoute.GET();
    expect(healthResponse.status).toBe(200);
    await expect(
      readJson<{
        status: string;
        database: {
          configured: boolean;
          reachable: boolean;
        };
        appTimeZone: string;
      }>(healthResponse),
    ).resolves.toMatchObject({
      status: "ok",
      database: {
        configured: true,
        reachable: true,
      },
      appTimeZone: "Asia/Tokyo",
    });

    const categoriesResponse = await categoriesRoute.GET();
    expect(categoriesResponse.status).toBe(200);
    const categoriesBody = await readJson<{
      data: Array<{
        id: string;
        questionCount: number;
      }>;
    }>(categoriesResponse);
    expect(categoriesBody.data).toHaveLength(5);
    expect(categoriesBody.data).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          id: "cat_ai",
          questionCount: 3,
        }),
        expect.objectContaining({
          id: "cat_java",
          questionCount: 0,
        }),
      ]),
    );

    const questionsResponse = await questionsRoute.GET(
      new Request(
        "http://localhost/api/v1/public/questions?q=lru&category=cat_algorithms",
      ),
    );
    expect(questionsResponse.status).toBe(200);
    const questionsBody = await readJson<{
      data: Array<{
        id: string;
        slug: string;
        progressStatus?: string;
      }>;
      meta: {
        total: number;
      };
    }>(questionsResponse);
    expect(questionsBody).toMatchObject({
      meta: {
        total: 1,
      },
    });
    expect(questionsBody.data[0]).toMatchObject({
      id: "q_lru",
      slug: "lru-cache",
    });
    expect(questionsBody.data[0]?.progressStatus).toBeUndefined();

    const questionResponse = await questionRoute.GET(new Request("http://localhost"), {
      params: Promise.resolve({
        questionId: "q_feature_store",
      }),
    });
    expect(questionResponse.status).toBe(200);
    const questionBody = await readJson<{
      data: {
        id: string;
        progressStatus?: string;
      };
    }>(questionResponse);
    expect(questionBody.data).toMatchObject({
      id: "q_feature_store",
    });
    expect(questionBody.data.progressStatus).toBeUndefined();

    const missingQuestionResponse = await questionRoute.GET(
      new Request("http://localhost"),
      {
        params: Promise.resolve({
          questionId: "missing",
        }),
      },
    );
    expect(missingQuestionResponse.status).toBe(404);
    await expect(
      readJson<{
        error: {
          code: string;
        };
      }>(missingQuestionResponse),
    ).resolves.toMatchObject({
      error: {
        code: "NOT_FOUND",
      },
    });
  });

  it("includes progress for authenticated users and excludes draft content", async () => {
    await loginAs("alex@example.com", "demo1234");

    const questionsRoute = await import("@/app/api/v1/public/questions/route");
    const questionRoute = await import(
      "@/app/api/v1/public/questions/[questionId]/route"
    );
    const adminService = await import("@/modules/admin/admin.service");

    await adminService.createAdminQuestion({
      title: "Draft-only AI question",
      slug: "draft-only-ai-question",
      categoryId: "cat_ai",
      difficulty: "Medium",
      tags: ["ai", "draft"],
      excerpt: "This should never appear publicly.",
      body: "Draft body",
      hint: "Hidden",
      referenceAnswer: "Hidden",
      relatedSlugs: [],
      visibility: "PRIVATE",
      contentStatus: "DRAFT",
    });

    const aiQuestionsResponse = await questionsRoute.GET(
      new Request("http://localhost/api/v1/public/questions?category=cat_ai"),
    );
    expect(aiQuestionsResponse.status).toBe(200);
    const aiQuestionsBody = await readJson<{
      data: Array<{
        id: string;
        slug: string;
        progressStatus?: string;
      }>;
      meta: {
        total: number;
      };
    }>(aiQuestionsResponse);

    expect(aiQuestionsBody.meta.total).toBe(3);
    expect(aiQuestionsBody.data.map((question) => question.slug)).not.toContain(
      "draft-only-ai-question",
    );
    expect(aiQuestionsBody.data.find((question) => question.id === "q_feature_store"))
      .toMatchObject({
        progressStatus: "MASTERED",
      });

    const questionResponse = await questionRoute.GET(new Request("http://localhost"), {
      params: Promise.resolve({
        questionId: "q_feature_store",
      }),
    });
    expect(questionResponse.status).toBe(200);
    await expect(
      readJson<{
        data: {
          id: string;
          progressStatus?: string;
        };
      }>(questionResponse),
    ).resolves.toMatchObject({
      data: {
        id: "q_feature_store",
        progressStatus: "MASTERED",
      },
    });
  });
});
