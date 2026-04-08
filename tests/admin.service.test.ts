import { afterEach, beforeEach, describe, expect, it } from "vitest";

import { categories, demoAdmin, demoUser, questions, todayTasks } from "@/lib/mock-data";
import type {
  AdminCategoryInput,
  AdminQuestionInput,
} from "@/modules/admin/admin.validation";

import {
  importWithDbMock,
  importWithoutDb,
  restoreArray,
  restoreModuleMocks,
  snapshotArray,
} from "@/tests/test-utils";

const categoryInput: AdminCategoryInput = {
  name: "Behavioral",
  slug: "behavioral",
  description: "Behavioral interview prompts.",
};

const questionInput: AdminQuestionInput = {
  title: "Explain graceful degradation in AI systems.",
  slug: "ai-graceful-degradation",
  categoryId: "cat_ai",
  difficulty: "Medium",
  tags: ["ai", "system-design"],
  excerpt: "Discuss fallback paths and degraded operation modes.",
  body: "How do you design graceful degradation for AI-backed products?",
  hint: "Talk about fallback UX and model outages.",
  referenceAnswer: "Prefer layered fallbacks and clear observability.",
  relatedSlugs: ["rag-service"],
  visibility: "PUBLIC",
  contentStatus: "DRAFT",
};

const questionInputWithoutOptionalFields: AdminQuestionInput = {
  ...questionInput,
  slug: "ai-fallback-paths",
  title: "Explain fallback paths in AI applications.",
  hint: undefined,
  referenceAnswer: undefined,
  relatedSlugs: [],
};

describe("admin.service", () => {
  const categorySnapshot = snapshotArray(categories);
  const questionSnapshot = snapshotArray(questions);
  const todayTaskSnapshot = snapshotArray(todayTasks);
  const demoUserSnapshot = structuredClone(demoUser);
  const demoAdminSnapshot = structuredClone(demoAdmin);

  beforeEach(() => {
    restoreArray(categories, categorySnapshot);
    restoreArray(questions, questionSnapshot);
    restoreArray(todayTasks, todayTaskSnapshot);
    Object.assign(demoUser, structuredClone(demoUserSnapshot));
    Object.assign(demoAdmin, structuredClone(demoAdminSnapshot));
  });

  afterEach(() => {
    restoreModuleMocks();
    restoreArray(categories, categorySnapshot);
    restoreArray(questions, questionSnapshot);
    restoreArray(todayTasks, todayTaskSnapshot);
    Object.assign(demoUser, structuredClone(demoUserSnapshot));
    Object.assign(demoAdmin, structuredClone(demoAdminSnapshot));
  });

  it("detects admin service errors", async () => {
    const adminService = await importWithoutDb<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
    );

    expect(
      adminService.isAdminServiceError(
        new adminService.AdminServiceError("Boom", "ADMIN", 500),
      ),
    ).toBe(true);
    expect(adminService.isAdminServiceError(new Error("boom"))).toBe(false);
  });

  it("handles mock-mode category reads and writes", async () => {
    const adminService = await importWithoutDb<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
    );
    const mockData = await import("@/lib/mock-data");

    mockData.questions[0]!.contentStatus = "DRAFT";
    mockData.questions[1]!.contentStatus = "ARCHIVED";

    await expect(adminService.listAdminQuestions()).resolves.toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          id: "q_lru",
          contentStatus: "DRAFT",
          statusLabel: "Draft",
        }),
        expect.objectContaining({
          id: "q_rate_limiter",
          contentStatus: "ARCHIVED",
          statusLabel: "Archived",
        }),
        expect.objectContaining({
          id: "q_mvcc",
          contentStatus: "PUBLISHED",
          statusLabel: "Published",
        }),
      ]),
    );
    await expect(
      adminService.listAdminQuestions({
        q: "audit",
        category: "cat_ai",
        status: "PUBLISHED",
      }),
    ).resolves.toEqual([
      expect.objectContaining({
        id: "q_audit",
      }),
    ]);
    await expect(adminService.listAdminCategories()).resolves.toHaveLength(5);
    await expect(adminService.getAdminCategoryById("cat_ai")).resolves.toMatchObject({
      id: "cat_ai",
      slug: "ai",
    });
    await expect(adminService.getAdminCategoryById("missing")).resolves.toBeNull();

    const createdCategory = await adminService.createAdminCategory(categoryInput);
    expect(createdCategory.slug).toBe("behavioral");

    await expect(adminService.createAdminCategory(categoryInput)).rejects.toMatchObject({
      code: "SLUG_TAKEN",
      status: 409,
    });
    await expect(
      adminService.createAdminCategory({
        ...categoryInput,
        name: "AI",
        slug: "behavioral-duplicate-name",
      }),
    ).rejects.toMatchObject({
      code: "NAME_TAKEN",
      status: 409,
    });
    await expect(
      adminService.updateAdminCategory(createdCategory.id, {
        ...categoryInput,
        name: "Behavioral Updated",
        slug: "behavioral-updated",
      }),
    ).resolves.toMatchObject({
      id: createdCategory.id,
      name: "Behavioral Updated",
      slug: "behavioral-updated",
    });
    expect(
      mockData.questions.filter((question) => question.categoryId === "cat_ai")[0]?.categoryName,
    ).toBe("AI");
    expect(
      mockData.todayTasks.filter((task) => task.categoryName === "Behavioral Updated"),
    ).toHaveLength(0);
    await expect(
      adminService.updateAdminCategory("cat_ai", {
        name: "Applied AI",
        slug: "applied-ai",
        description: "Updated AI track.",
      }),
    ).resolves.toMatchObject({
      id: "cat_ai",
      name: "Applied AI",
      slug: "applied-ai",
    });
    expect(
      mockData.questions.filter((question) => question.categoryId === "cat_ai")[0]?.categoryName,
    ).toBe("Applied AI");
    expect(
      mockData.todayTasks.filter((task) => task.categoryName === "Applied AI"),
    ).not.toHaveLength(0);
    expect(mockData.demoUser.preferredTracks).toContain("Applied AI");
    expect(mockData.demoUser.preferredTracks).not.toContain("AI");
    await expect(
      adminService.updateAdminCategory("missing", categoryInput),
    ).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });
    await expect(
      adminService.updateAdminCategory("cat_ai", {
        ...categoryInput,
        slug: "algorithms",
      }),
    ).rejects.toMatchObject({
      code: "SLUG_TAKEN",
      status: 409,
    });
    await expect(
      adminService.updateAdminCategory("cat_ai", {
        ...categoryInput,
        name: "SQL",
        slug: "ai-updated",
      }),
    ).rejects.toMatchObject({
      code: "NAME_TAKEN",
      status: 409,
    });
    await expect(adminService.deleteAdminCategory("cat_ai")).rejects.toMatchObject({
      code: "CATEGORY_IN_USE",
      status: 409,
    });
    await expect(
      adminService.deleteAdminCategory("missing"),
    ).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });
    await expect(adminService.deleteAdminCategory(createdCategory.id)).resolves.toMatchObject({
      id: createdCategory.id,
      slug: "behavioral-updated",
    });
  });

  it("handles mock-mode question reads and writes", async () => {
    const adminService = await importWithoutDb<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
    );

    await expect(adminService.getAdminQuestionById("q_lru")).resolves.toMatchObject({
      id: "q_lru",
      visibility: "PUBLIC",
      contentStatus: "PUBLISHED",
    });
    await expect(adminService.getAdminQuestionById("missing")).resolves.toBeNull();

    const createdQuestion = await adminService.createAdminQuestion(questionInput);

    expect(createdQuestion).toMatchObject({
      slug: "ai-graceful-degradation",
      categoryName: "AI",
      visibility: "PUBLIC",
      contentStatus: "DRAFT",
    });
    const createdQuestionWithoutOptionalFields = await adminService.createAdminQuestion(
      questionInputWithoutOptionalFields,
    );

    expect(createdQuestionWithoutOptionalFields).toMatchObject({
      slug: "ai-fallback-paths",
      hint: undefined,
      referenceAnswer: undefined,
    });
    await expect(
      adminService.getAdminQuestionById(createdQuestionWithoutOptionalFields.id),
    ).resolves.toMatchObject({
      id: createdQuestionWithoutOptionalFields.id,
      hint: undefined,
      referenceAnswer: undefined,
    });

    await expect(
      adminService.createAdminQuestion({
        ...questionInput,
        slug: "rate-limiter",
      }),
    ).rejects.toMatchObject({
      code: "SLUG_TAKEN",
      status: 409,
    });
    await expect(
      adminService.createAdminQuestion({
        ...questionInput,
        slug: "brand-new-question",
        categoryId: "missing",
      }),
    ).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });
    await expect(
      adminService.updateAdminQuestion(createdQuestion.id, {
        ...questionInput,
        title: "Explain graceful degradation in production AI systems.",
        slug: "ai-graceful-degradation-updated",
        categoryId: "cat_system",
        visibility: "PRIVATE",
        contentStatus: "ARCHIVED",
      }),
    ).resolves.toMatchObject({
      id: createdQuestion.id,
      slug: "ai-graceful-degradation-updated",
      categoryName: "System Design",
      visibility: "PRIVATE",
      contentStatus: "ARCHIVED",
    });
    await expect(
      adminService.updateAdminQuestion("q_mvcc", {
        ...questionInputWithoutOptionalFields,
        slug: "ai-fallback-paths-updated",
        title: "Explain fallback paths in production AI applications.",
      }),
    ).resolves.toMatchObject({
      id: "q_mvcc",
      slug: "ai-fallback-paths-updated",
      hint: undefined,
      referenceAnswer: undefined,
    });
    await expect(
      adminService.updateAdminQuestion("missing", questionInput),
    ).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });
    await expect(
      adminService.updateAdminQuestion("q_lru", {
        ...questionInput,
        slug: "rate-limiter",
      }),
    ).rejects.toMatchObject({
      code: "SLUG_TAKEN",
      status: 409,
    });
  });

  it("handles database-mode admin list and read queries", async () => {
    const row = {
      id: "q_admin",
      slug: "db-admin-question",
      title: "DB Admin Question",
      categoryId: "cat_ai",
      categoryName: "AI",
      difficulty: "Medium" as const,
      tags: ["db"],
      excerpt: "Excerpt",
      body: "Body",
      hint: null,
      referenceAnswer: null,
      relatedSlugs: ["rag-service"],
      visibility: "PUBLIC" as const,
      contentStatus: "PUBLISHED" as const,
    };
    const loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [
          row,
          { ...row, id: "q_draft", slug: "draft-question", contentStatus: "DRAFT" },
          {
            ...row,
            id: "q_archived",
            slug: "archived-question",
            contentStatus: "ARCHIVED",
          },
        ],
        [{ ...row, id: "q_all", slug: "all-question", contentStatus: "PUBLISHED" }],
        [
          {
            id: "cat_ai",
            name: "AI",
            slug: "ai",
            description: "AI questions",
            questionCount: 3,
          },
        ],
        [
          {
            id: "cat_ai",
            name: "AI",
            slug: "ai",
            description: "AI questions",
            questionCount: 3,
          },
        ],
        [],
        [row],
        [],
      ],
    );

    await expect(
      loaded.module.listAdminQuestions({
        q: "db",
        category: "cat_ai",
        status: "PUBLISHED",
      }),
    ).resolves.toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          id: "q_admin",
          statusLabel: "Published",
        }),
        expect.objectContaining({
          id: "q_draft",
          statusLabel: "Draft",
        }),
        expect.objectContaining({
          id: "q_archived",
          statusLabel: "Archived",
        }),
      ]),
    );
    await expect(loaded.module.listAdminQuestions()).resolves.toEqual([
      {
        id: "q_all",
        title: "DB Admin Question",
        slug: "all-question",
        categoryId: "cat_ai",
        categoryName: "AI",
        difficulty: "Medium",
        contentStatus: "PUBLISHED",
        statusLabel: "Published",
      },
    ]);
    await expect(loaded.module.listAdminCategories()).resolves.toEqual([
      {
        id: "cat_ai",
        name: "AI",
        slug: "ai",
        description: "AI questions",
        questionCount: 3,
      },
    ]);
    await expect(loaded.module.getAdminCategoryById("cat_ai")).resolves.toEqual({
      id: "cat_ai",
      name: "AI",
      slug: "ai",
      description: "AI questions",
      questionCount: 3,
    });
    await expect(loaded.module.getAdminCategoryById("missing")).resolves.toBeNull();
    await expect(loaded.module.getAdminQuestionById("q_admin")).resolves.toEqual({
      ...row,
      hint: undefined,
      referenceAnswer: undefined,
    });
    await expect(loaded.module.getAdminQuestionById("missing")).resolves.toBeNull();
  });

  it("handles database-mode category writes and errors", async () => {
    let loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [],
        [],
        [
          {
            id: "cat_new",
            name: "Behavioral",
            slug: "behavioral",
            description: "Behavioral interview prompts.",
            questionCount: 0,
          },
        ],
        [],
        [],
        [
          {
            id: "cat_new",
            name: "Behavioral",
          },
        ],
        [
          {
            id: "cat_new",
            name: "Behavioral Updated",
            slug: "behavioral-updated",
            description: "Updated",
            questionCount: 1,
          },
        ],
        [],
        [],
        [
          {
            id: "cat_new",
            name: "Behavioral Updated",
            questionCount: 0,
            taskCount: 0,
            preferenceCount: 0,
          },
        ],
        [
          {
            id: "cat_new",
            name: "Behavioral Updated",
            slug: "behavioral-updated",
            description: "Updated",
            questionCount: 0,
          },
        ],
      ],
    );

    await expect(loaded.module.createAdminCategory(categoryInput)).resolves.toEqual({
      id: "cat_new",
      name: "Behavioral",
      slug: "behavioral",
      description: "Behavioral interview prompts.",
      questionCount: 0,
    });
    await expect(
      loaded.module.updateAdminCategory("cat_new", {
        name: "Behavioral Updated",
        slug: "behavioral-updated",
        description: "Updated",
      }),
    ).resolves.toEqual({
      id: "cat_new",
      name: "Behavioral Updated",
      slug: "behavioral-updated",
      description: "Updated",
      questionCount: 1,
    });
    expect(
      loaded.executedStatements.some((statement) => statement.includes("UPDATE users")),
    ).toBe(true);
    expect(
      loaded.executedStatements.some((statement) => statement.includes("UPDATE study_tasks")),
    ).toBe(true);
    await expect(loaded.module.deleteAdminCategory("cat_new")).resolves.toEqual({
      id: "cat_new",
      name: "Behavioral Updated",
      slug: "behavioral-updated",
      description: "Updated",
      questionCount: 0,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[{ id: "cat_existing" }]],
    );

    await expect(loaded.module.createAdminCategory(categoryInput)).rejects.toMatchObject({
      code: "SLUG_TAKEN",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[], [{ id: "cat_existing" }]],
    );

    await expect(loaded.module.createAdminCategory(categoryInput)).rejects.toMatchObject({
      code: "NAME_TAKEN",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[], [], []],
    );

    await expect(loaded.module.createAdminCategory(categoryInput)).rejects.toMatchObject({
      code: "CREATE_FAILED",
      status: 500,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[{ id: "cat_existing" }]],
    );

    await expect(
      loaded.module.updateAdminCategory("cat_new", {
        name: "Behavioral Updated",
        slug: "behavioral-updated",
        description: "Updated",
      }),
    ).rejects.toMatchObject({
      code: "SLUG_TAKEN",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[], [{ id: "cat_existing" }]],
    );

    await expect(
      loaded.module.updateAdminCategory("cat_new", {
        name: "Behavioral Updated",
        slug: "behavioral-updated",
        description: "Updated",
      }),
    ).rejects.toMatchObject({
      code: "NAME_TAKEN",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[], [], []],
    );

    await expect(
      loaded.module.updateAdminCategory("missing", {
        name: "Behavioral Updated",
        slug: "behavioral-updated",
        description: "Updated",
      }),
    ).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [],
        [],
        [
          {
            id: "cat_new",
            name: "Behavioral",
          },
        ],
        [],
      ],
    );

    await expect(
      loaded.module.updateAdminCategory("cat_new", {
        name: "Behavioral Updated",
        slug: "behavioral-updated",
        description: "Updated",
      }),
    ).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [
          {
            id: "cat_ai",
            name: "AI",
            questionCount: 2,
            taskCount: 0,
            preferenceCount: 0,
          },
        ],
      ],
    );

    await expect(loaded.module.deleteAdminCategory("cat_ai")).rejects.toMatchObject({
      code: "CATEGORY_IN_USE",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [
          {
            id: "cat_sql",
            name: "SQL",
            questionCount: 0,
            taskCount: 1,
            preferenceCount: 0,
          },
        ],
      ],
    );

    await expect(loaded.module.deleteAdminCategory("cat_sql")).rejects.toMatchObject({
      code: "CATEGORY_IN_USE",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [
          {
            id: "cat_java",
            name: "Java Core",
            questionCount: 0,
            taskCount: 0,
            preferenceCount: 1,
          },
        ],
      ],
    );

    await expect(loaded.module.deleteAdminCategory("cat_java")).rejects.toMatchObject({
      code: "CATEGORY_IN_USE",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [
          {
            id: "cat_new",
            name: "Behavioral Updated",
            questionCount: 0,
            taskCount: 0,
            preferenceCount: 0,
          },
        ],
        [],
      ],
    );

    await expect(loaded.module.deleteAdminCategory("cat_new")).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[]],
    );

    await expect(loaded.module.deleteAdminCategory("missing")).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [
          {
            id: "cat_new",
            name: "Behavioral Updated",
            questionCount: 0,
            taskCount: 0,
            preferenceCount: 0,
          },
        ],
        [
          {
            id: "cat_new",
            name: "Behavioral Updated",
            slug: "behavioral-updated",
            description: "Updated",
            questionCount: 0,
          },
        ],
      ],
    );

    await expect(loaded.module.deleteAdminCategory("cat_new")).resolves.toEqual({
      id: "cat_new",
      name: "Behavioral Updated",
      slug: "behavioral-updated",
      description: "Updated",
      questionCount: 0,
    });
  });

  it("handles database-mode question writes and errors", async () => {
    const questionRow = {
      id: "q_new",
      slug: "ai-graceful-degradation",
      title: "Explain graceful degradation in AI systems.",
      categoryId: "cat_ai",
      categoryName: "AI",
      difficulty: "Medium" as const,
      tags: ["ai", "system-design"],
      excerpt: "Discuss fallback paths and degraded operation modes.",
      body: "How do you design graceful degradation for AI-backed products?",
      hint: "Talk about fallback UX and model outages.",
      referenceAnswer: "Prefer layered fallbacks and clear observability.",
      relatedSlugs: ["rag-service"],
      visibility: "PUBLIC" as const,
      contentStatus: "DRAFT" as const,
    };
    let loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [
        [],
        [questionRow],
        [],
        [
          {
            ...questionRow,
            slug: "ai-graceful-degradation-updated",
            title: "Explain graceful degradation in production AI systems.",
            categoryId: "cat_system",
            categoryName: "System Design",
            visibility: "PRIVATE",
            contentStatus: "ARCHIVED",
          },
        ],
        [],
        [
          {
            ...questionRow,
            id: "q_optional",
            slug: "ai-fallback-paths",
            title: "Explain fallback paths in AI applications.",
            hint: null,
            referenceAnswer: null,
            relatedSlugs: [],
          },
        ],
        [],
        [
          {
            ...questionRow,
            id: "q_optional",
            slug: "ai-fallback-paths-updated",
            title: "Explain fallback paths in production AI applications.",
            hint: null,
            referenceAnswer: null,
            relatedSlugs: [],
          },
        ],
      ],
    );

    await expect(loaded.module.createAdminQuestion(questionInput)).resolves.toEqual(
      questionRow,
    );
    await expect(
      loaded.module.updateAdminQuestion("q_new", {
        ...questionInput,
        title: "Explain graceful degradation in production AI systems.",
        slug: "ai-graceful-degradation-updated",
        categoryId: "cat_system",
        visibility: "PRIVATE",
        contentStatus: "ARCHIVED",
      }),
    ).resolves.toEqual({
      ...questionRow,
      slug: "ai-graceful-degradation-updated",
      title: "Explain graceful degradation in production AI systems.",
      categoryId: "cat_system",
      categoryName: "System Design",
      visibility: "PRIVATE",
      contentStatus: "ARCHIVED",
    });
    await expect(
      loaded.module.createAdminQuestion(questionInputWithoutOptionalFields),
    ).resolves.toEqual({
      ...questionRow,
      id: "q_optional",
      slug: "ai-fallback-paths",
      title: "Explain fallback paths in AI applications.",
      hint: undefined,
      referenceAnswer: undefined,
      relatedSlugs: [],
    });
    await expect(
      loaded.module.updateAdminQuestion("q_optional", {
        ...questionInputWithoutOptionalFields,
        slug: "ai-fallback-paths-updated",
        title: "Explain fallback paths in production AI applications.",
      }),
    ).resolves.toEqual({
      ...questionRow,
      id: "q_optional",
      slug: "ai-fallback-paths-updated",
      title: "Explain fallback paths in production AI applications.",
      hint: undefined,
      referenceAnswer: undefined,
      relatedSlugs: [],
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[{ id: "q_existing" }]],
    );

    await expect(loaded.module.createAdminQuestion(questionInput)).rejects.toMatchObject({
      code: "SLUG_TAKEN",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[], []],
    );

    await expect(loaded.module.createAdminQuestion(questionInput)).rejects.toMatchObject({
      code: "CREATE_FAILED",
      status: 500,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[{ id: "q_existing" }]],
    );

    await expect(
      loaded.module.updateAdminQuestion("q_new", questionInput),
    ).rejects.toMatchObject({
      code: "SLUG_TAKEN",
      status: 409,
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/admin/admin.service")>(
      "@/modules/admin/admin.service",
      [[], []],
    );

    await expect(
      loaded.module.updateAdminQuestion("missing", questionInput),
    ).rejects.toMatchObject({
      code: "NOT_FOUND",
      status: 404,
    });
  });
});
