import { afterEach, beforeEach, describe, expect, it } from "vitest";

import { questions } from "@/lib/mock-data";

import {
  importWithDbMock,
  importWithoutDb,
  restoreArray,
  restoreModuleMocks,
  snapshotArray,
} from "@/tests/test-utils";

describe("question-bank.service", () => {
  const questionSnapshot = snapshotArray(questions);

  beforeEach(() => {
    restoreArray(questions, questionSnapshot);
  });

  afterEach(() => {
    restoreModuleMocks();
    restoreArray(questions, questionSnapshot);
  });

  it("handles mock-mode category and question reads", async () => {
    const questionBankService = await importWithoutDb<
      typeof import("@/modules/question-bank/question-bank.service")
    >("@/modules/question-bank/question-bank.service");

    await expect(questionBankService.listCategories()).resolves.toHaveLength(5);
    await expect(questionBankService.listQuestions()).resolves.toHaveLength(6);
    await expect(questionBankService.listQuestions(undefined, "user_demo")).resolves.toContainEqual(
      expect.objectContaining({
        id: "q_lru",
        progressStatus: "REVIEWED",
      }),
    );
    await expect(questionBankService.findQuestionBySlug("lru-cache")).resolves.toMatchObject({
      id: "q_lru",
      progressStatus: undefined,
    });
    await expect(
      questionBankService.findQuestionBySlug("lru-cache", "user_demo"),
    ).resolves.toMatchObject({
      id: "q_lru",
      progressStatus: "REVIEWED",
    });
    await expect(questionBankService.findQuestionById("q_rag")).resolves.toMatchObject({
      slug: "rag-service",
      progressStatus: undefined,
    });
    await expect(
      questionBankService.findQuestionById("q_rag", "user_demo"),
    ).resolves.toMatchObject({
      slug: "rag-service",
      progressStatus: "NOT_STARTED",
    });
    await expect(
      questionBankService.listRelatedQuestions(["rag-service", "rate-limiter"]),
    ).resolves.toHaveLength(2);
    await expect(
      questionBankService.listRelatedQuestions(["rag-service"], "user_demo"),
    ).resolves.toContainEqual(
      expect.objectContaining({
        slug: "rag-service",
        progressStatus: "NOT_STARTED",
      }),
    );
    await expect(questionBankService.listRelatedQuestions([])).resolves.toEqual([]);
    await expect(questionBankService.findAdminQuestionById("q_mvcc")).resolves.toMatchObject({
      slug: "mvcc-explained",
    });
    await expect(
      questionBankService.upsertQuestionProgress(
        {
          questionId: "q_rag",
          progressStatus: "MASTERED",
        },
      ),
    ).resolves.toEqual({
      questionId: "q_rag",
      progressStatus: "MASTERED",
    });
    await expect(
      questionBankService.upsertQuestionProgress(
        {
          questionId: "missing",
          progressStatus: "MASTERED",
        },
      ),
    ).resolves.toBeNull();
  });

  it("handles all database-mode list query branches", async () => {
    const baseRow = {
      id: "q_1",
      slug: "db-question",
      title: "DB Question",
      categoryId: "cat_ai",
      categoryName: "AI",
      difficulty: "Medium" as const,
      tags: ["db"],
      excerpt: "Excerpt",
      body: "Body",
      hint: null,
      referenceAnswer: null,
      progressStatus: null,
      relatedSlugs: ["rag-service"],
    };
    const loaded = await importWithDbMock<
      typeof import("@/modules/question-bank/question-bank.service")
    >("@/modules/question-bank/question-bank.service", [
      [
        {
          id: "cat_ai",
          name: "AI",
          slug: "ai",
          description: "AI questions",
          questionCount: 3,
        },
      ],
      [baseRow],
      [{ ...baseRow, slug: "db-query-only", progressStatus: "REVIEWED" }],
      [{ ...baseRow, slug: "db-category-only" }],
      [{ ...baseRow, slug: "db-no-filters" }],
    ]);

    await expect(loaded.module.listCategories()).resolves.toEqual([
      {
        id: "cat_ai",
        name: "AI",
        slug: "ai",
        description: "AI questions",
        questionCount: 3,
      },
    ]);
    await expect(
      loaded.module.listQuestions({ q: "db", category: "cat_ai" }, "user_demo"),
    ).resolves.toEqual([
      {
        ...baseRow,
        hint: undefined,
        referenceAnswer: undefined,
        progressStatus: undefined,
      },
    ]);
    await expect(loaded.module.listQuestions({ q: "db" }, "user_demo")).resolves.toEqual([
      {
        ...baseRow,
        slug: "db-query-only",
        hint: undefined,
        referenceAnswer: undefined,
        progressStatus: "REVIEWED",
      },
    ]);
    await expect(loaded.module.listQuestions({ category: "cat_ai" })).resolves.toEqual([
      {
        ...baseRow,
        slug: "db-category-only",
        hint: undefined,
        referenceAnswer: undefined,
        progressStatus: undefined,
      },
    ]);
    await expect(loaded.module.listQuestions()).resolves.toEqual([
      {
        ...baseRow,
        slug: "db-no-filters",
        hint: undefined,
        referenceAnswer: undefined,
        progressStatus: undefined,
      },
    ]);
  });

  it("handles database-mode question reads and related lookups", async () => {
    const row = {
      id: "q_1",
      slug: "db-question",
      title: "DB Question",
      categoryId: "cat_ai",
      categoryName: "AI",
      difficulty: "Medium" as const,
      tags: ["db"],
      excerpt: "Excerpt",
      body: "Body",
      hint: "Hint",
      referenceAnswer: "Answer",
      progressStatus: "REVIEWED" as const,
      relatedSlugs: ["rag-service"],
    };
    const loaded = await importWithDbMock<
      typeof import("@/modules/question-bank/question-bank.service")
    >("@/modules/question-bank/question-bank.service", [
      [row],
      [],
      [row],
      [],
      [{ ...row, slug: "rag-service" }, { ...row, slug: "rate-limiter" }],
      [row],
      [],
    ]);

    await expect(
      loaded.module.findQuestionBySlug("db-question", "user_demo"),
    ).resolves.toEqual(row);
    await expect(loaded.module.findQuestionBySlug("missing")).resolves.toBeNull();
    await expect(loaded.module.findQuestionById("q_1", "user_demo")).resolves.toEqual(row);
    await expect(loaded.module.findQuestionById("missing")).resolves.toBeNull();
    await expect(
      loaded.module.listRelatedQuestions(["rag-service", "rate-limiter"], "user_demo"),
    ).resolves.toEqual([
      { ...row, slug: "rag-service" },
      { ...row, slug: "rate-limiter" },
    ]);
    await expect(loaded.module.findAdminQuestionById("q_1")).resolves.toEqual(row);
    await expect(loaded.module.findAdminQuestionById("missing")).resolves.toBeNull();
  });

  it("handles database-mode progress upserts", async () => {
    let loaded = await importWithDbMock<typeof import("@/modules/question-bank/question-bank.service")>(
      "@/modules/question-bank/question-bank.service",
      [[{ questionId: "q_1", progressStatus: "MASTERED" }]],
    );

    await expect(
      loaded.module.upsertQuestionProgress(
        {
          questionId: "q_1",
          progressStatus: "MASTERED",
        },
        "user_demo",
      ),
    ).resolves.toEqual({
      questionId: "q_1",
      progressStatus: "MASTERED",
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/question-bank/question-bank.service")>(
      "@/modules/question-bank/question-bank.service",
      [[]],
    );

    await expect(
      loaded.module.upsertQuestionProgress(
        {
          questionId: "q_1",
          progressStatus: "PLANNED",
        },
        "user_demo",
      ),
    ).resolves.toBeNull();
    await expect(
      loaded.module.upsertQuestionProgress({
        questionId: "q_1",
        progressStatus: "PLANNED",
      }),
    ).rejects.toThrow("User context is required.");
  });
});
