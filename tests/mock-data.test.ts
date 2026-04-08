import { describe, expect, it } from "vitest";

import {
  featuredQuestionIds,
  getCategories,
  getCompletedTasks,
  getFeaturedQuestions,
  getPendingTasks,
  getQuestionById,
  getQuestionBySlug,
  getQuestionSummaries,
  getRelatedQuestions,
  todayTasks,
} from "@/lib/mock-data";

describe("lib/mock-data", () => {
  it("returns the raw category list", () => {
    expect(getCategories()).toHaveLength(5);
    expect(getCategories()[0]?.name).toBe("Algorithms");
  });

  it("returns featured questions from the allow-list", () => {
    const featuredQuestions = getFeaturedQuestions();

    expect(featuredQuestions).toHaveLength(featuredQuestionIds.length);
    expect(featuredQuestions.every((question) => featuredQuestionIds.includes(question.id))).toBe(
      true,
    );
  });

  it("finds questions by slug and id", () => {
    expect(getQuestionBySlug("rag-service")?.id).toBe("q_rag");
    expect(getQuestionById("q_mvcc")?.slug).toBe("mvcc-explained");
    expect(getQuestionBySlug("missing")).toBeUndefined();
    expect(getQuestionById("missing")).toBeUndefined();
  });

  it("filters question summaries by query and category", () => {
    expect(getQuestionSummaries()).toHaveLength(6);
    expect(
      getQuestionSummaries({
        q: "retrieval",
      }).map((question) => question.slug),
    ).toContain("rag-service");
    expect(
      getQuestionSummaries({
        category: "cat_sql",
      }).map((question) => question.slug),
    ).toEqual(["mvcc-explained"]);
    expect(
      getQuestionSummaries({
        q: "consistency",
        category: "cat_ai",
      }).map((question) => question.slug),
    ).toEqual(["feature-store-consistency"]);
  });

  it("returns related, pending, and completed task slices", () => {
    expect(getRelatedQuestions(["lru-cache", "rate-limiter"])).toHaveLength(2);
    expect(getPendingTasks()).toEqual(
      todayTasks.filter((task) => task.status === "PENDING"),
    );
    expect(getCompletedTasks()).toEqual(
      todayTasks.filter((task) => task.status === "COMPLETED"),
    );
  });
});
