import { describe, expect, it } from "vitest";

import {
  parseAdminCategoryInput,
  parseAdminQuestionFilters,
  parseAdminQuestionInput,
  parseAdminQuestionIntent,
} from "@/modules/admin/admin.validation";

describe("admin.validation", () => {
  it("maps submit intent to content status", () => {
    expect(parseAdminQuestionIntent("draft")).toBe("DRAFT");
    expect(parseAdminQuestionIntent("publish")).toBe("PUBLISHED");
    expect(parseAdminQuestionIntent("archive", { allowArchive: true })).toBe(
      "ARCHIVED",
    );
  });

  it("rejects invalid question intents", () => {
    expect(() => parseAdminQuestionIntent("archive")).toThrow(
      "Question intent is invalid.",
    );
    expect(() => parseAdminQuestionIntent("weird")).toThrow(
      "Question intent is invalid.",
    );
  });

  it("parses admin question input and auto-generates a slug", () => {
    expect(
      parseAdminQuestionInput(
        {
          title: "Design a RAG Service",
          slug: "",
          categoryId: "cat_ai",
          difficulty: "Medium",
          tags: "rag, ai, rag",
          excerpt: "",
          body: "Describe chunking, retrieval, reranking, grounding, and citations.",
          hint: "Think about observability too.",
          referenceAnswer: "Start with indexing and retrieval quality.",
          relatedSlugs: "rate-limiter, design-a-rag-service",
          visibility: "PUBLIC",
          contentStatus: "PUBLISHED",
        },
        ["cat_ai", "cat_sql"],
      ),
    ).toEqual({
      title: "Design a RAG Service",
      slug: "design-a-rag-service",
      categoryId: "cat_ai",
      difficulty: "Medium",
      tags: ["rag", "ai"],
      excerpt: "Describe chunking, retrieval, reranking, grounding, and citations.",
      body: "Describe chunking, retrieval, reranking, grounding, and citations.",
      hint: "Think about observability too.",
      referenceAnswer: "Start with indexing and retrieval quality.",
      relatedSlugs: ["rate-limiter"],
      visibility: "PUBLIC",
      contentStatus: "PUBLISHED",
    });
  });

  it("builds a fallback excerpt when the field is omitted", () => {
    expect(
      parseAdminQuestionInput(
        {
          title: "Design Prompt Versioning",
          categoryId: "cat_ai",
          difficulty: "Easy",
          body: "Explain prompt version control, rollback strategy, and A/B testing.",
          visibility: "PRIVATE",
          contentStatus: "DRAFT",
        },
        ["cat_ai", "cat_sql"],
      ),
    ).toEqual({
      title: "Design Prompt Versioning",
      slug: "design-prompt-versioning",
      categoryId: "cat_ai",
      difficulty: "Easy",
      tags: [],
      excerpt: "Explain prompt version control, rollback strategy, and A/B testing.",
      body: "Explain prompt version control, rollback strategy, and A/B testing.",
      hint: undefined,
      referenceAnswer: undefined,
      relatedSlugs: [],
      visibility: "PRIVATE",
      contentStatus: "DRAFT",
    });
  });

  it("keeps only valid admin list filters", () => {
    expect(
      parseAdminQuestionFilters(
        {
          q: "rag",
          category: "cat_ai",
          status: "PUBLISHED",
        },
        ["cat_ai", "cat_sql"],
      ),
    ).toEqual({
      q: "rag",
      category: "cat_ai",
      status: "PUBLISHED",
    });
  });

  it("drops invalid filters", () => {
    expect(
      parseAdminQuestionFilters(
        {
          q: "  ",
          category: "cat_java",
          status: "BAD",
        },
        ["cat_ai", "cat_sql"],
      ),
    ).toEqual({
      q: undefined,
      category: undefined,
      status: undefined,
    });
  });

  it("parses admin category input and auto-generates a slug", () => {
    expect(
      parseAdminCategoryInput({
        name: "Prompt Engineering",
        slug: "",
        description: "Prompt patterns, guardrails, versioning, and evaluation.",
      }),
    ).toEqual({
      name: "Prompt Engineering",
      slug: "prompt-engineering",
      description: "Prompt patterns, guardrails, versioning, and evaluation.",
    });
  });

  it("rejects invalid admin question and category inputs", () => {
    expect(() =>
      parseAdminQuestionInput(
        {
          title: "",
          body: "Body",
          categoryId: "cat_ai",
          difficulty: "Medium",
          visibility: "PUBLIC",
          contentStatus: "PUBLISHED",
        },
        ["cat_ai"],
      ),
    ).toThrow("Title is required.");
    expect(() =>
      parseAdminQuestionInput(
        {
          title: "Question",
          body: "",
          categoryId: "cat_ai",
          difficulty: "Medium",
          visibility: "PUBLIC",
          contentStatus: "PUBLISHED",
        },
        ["cat_ai"],
      ),
    ).toThrow("Question body is required.");
    expect(() =>
      parseAdminQuestionInput(
        {
          title: "Question",
          slug: "!!!",
          body: "Body",
          categoryId: "cat_ai",
          difficulty: "Medium",
          visibility: "PUBLIC",
          contentStatus: "PUBLISHED",
        },
        ["cat_ai"],
      ),
    ).toThrow("Slug is required.");
    expect(() =>
      parseAdminQuestionInput(
        {
          title: "Question",
          body: "Body",
          categoryId: "bad",
          difficulty: "Medium",
          visibility: "PUBLIC",
          contentStatus: "PUBLISHED",
        },
        ["cat_ai"],
      ),
    ).toThrow("Category is invalid.");
    expect(() =>
      parseAdminQuestionInput(
        {
          title: "Question",
          body: "Body",
          categoryId: "cat_ai",
          difficulty: "Bad",
          visibility: "PUBLIC",
          contentStatus: "PUBLISHED",
        },
        ["cat_ai"],
      ),
    ).toThrow("Difficulty is invalid.");
    expect(() =>
      parseAdminQuestionInput(
        {
          title: "Question",
          body: "Body",
          categoryId: "cat_ai",
          difficulty: "Medium",
          visibility: "TEAM",
          contentStatus: "PUBLISHED",
        },
        ["cat_ai"],
      ),
    ).toThrow("Visibility is invalid.");
    expect(() =>
      parseAdminQuestionInput(
        {
          title: "Question",
          body: "Body",
          categoryId: "cat_ai",
          difficulty: "Medium",
          visibility: "PUBLIC",
          contentStatus: "BAD",
        },
        ["cat_ai"],
      ),
    ).toThrow("Content status is invalid.");
    expect(() =>
      parseAdminCategoryInput({
        name: "",
        slug: "",
        description: "",
      }),
    ).toThrow("Name is required.");
    expect(() =>
      parseAdminCategoryInput({
        name: "Behavioral",
        slug: "!!!",
        description: "Category",
      }),
    ).toThrow("Slug is required.");
  });
});
