import { describe, expect, it } from "vitest";

import { parseCreateTaskInput } from "@/modules/daily-plan/daily-plan.validation";

describe("parseCreateTaskInput", () => {
  it("accepts a valid category task", () => {
    expect(
      parseCreateTaskInput({
        title: "  Review 3 SQL locking questions  ",
        taskType: "CATEGORY_PRACTICE",
        priority: "3",
        categoryName: " SQL ",
      }, ["SQL", "AI"]),
    ).toEqual({
      title: "Review 3 SQL locking questions",
      taskType: "CATEGORY_PRACTICE",
      priority: 3,
      categoryName: "SQL",
      linkedQuestionSlug: undefined,
      linkedQuestionTitle: undefined,
    });
  });

  it("rejects blank titles", () => {
    expect(() =>
      parseCreateTaskInput({
        title: "   ",
        taskType: "FREEFORM",
        priority: "2",
      }),
    ).toThrow("Title is required.");
  });

  it("rejects invalid task types", () => {
    expect(() =>
      parseCreateTaskInput({
        title: "Bad task",
        taskType: "INVALID",
        priority: "2",
      }),
    ).toThrow("Task type is invalid.");
  });

  it("requires categories for category practice tasks", () => {
    expect(() =>
      parseCreateTaskInput({
        title: "Practice SQL",
        taskType: "CATEGORY_PRACTICE",
        priority: "3",
      }),
    ).toThrow("Category-practice tasks require a category.");
  });

  it("requires linked question details for question-linked tasks", () => {
    expect(() =>
      parseCreateTaskInput({
        title: "Review LRU cache",
        taskType: "QUESTION_LINKED",
        priority: "3",
      }),
    ).toThrow("Question-linked tasks require question details.");
  });

  it("requires categories for question-linked tasks", () => {
    expect(() =>
      parseCreateTaskInput({
        title: "Review LRU cache",
        taskType: "QUESTION_LINKED",
        priority: "3",
        linkedQuestionSlug: "lru-cache",
        linkedQuestionTitle: "How would you implement an O(1) LRU cache?",
      }),
    ).toThrow("Question-linked tasks require a category.");
  });

  it("accepts valid question-linked tasks and trims blank optional fields", () => {
    expect(
      parseCreateTaskInput({
        title: "Review LRU cache",
        taskType: "QUESTION_LINKED",
        priority: "4",
        categoryName: " AI ",
        linkedQuestionSlug: " lru-cache ",
        linkedQuestionTitle: " How would you implement an O(1) LRU cache? ",
      }, ["AI"]),
    ).toEqual({
      title: "Review LRU cache",
      taskType: "QUESTION_LINKED",
      priority: 4,
      categoryName: "AI",
      linkedQuestionSlug: "lru-cache",
      linkedQuestionTitle: "How would you implement an O(1) LRU cache?",
    });
  });

  it("rejects unknown categories when valid names are provided", () => {
    expect(() =>
      parseCreateTaskInput({
        title: "Review SQL notes",
        taskType: "FREEFORM",
        priority: "2",
        categoryName: "Missing",
      }, ["SQL", "AI"]),
    ).toThrow("Category is invalid.");
  });

  it("drops stale linked question fields for non-question tasks", () => {
    expect(
      parseCreateTaskInput({
        title: "Review SQL notes",
        taskType: "FREEFORM",
        priority: "2",
        categoryName: "   ",
        linkedQuestionSlug: "   ",
        linkedQuestionTitle: "   ",
      }),
    ).toEqual({
      title: "Review SQL notes",
      taskType: "FREEFORM",
      priority: 2,
      categoryName: undefined,
      linkedQuestionSlug: undefined,
      linkedQuestionTitle: undefined,
    });
  });

  it("accepts numeric priorities and rejects out-of-range values", () => {
    expect(
      parseCreateTaskInput({
        title: "Review SQL notes",
        taskType: "FREEFORM",
        priority: 5,
      }),
    ).toEqual({
      title: "Review SQL notes",
      taskType: "FREEFORM",
      priority: 5,
      categoryName: undefined,
      linkedQuestionSlug: undefined,
      linkedQuestionTitle: undefined,
    });
    expect(() =>
      parseCreateTaskInput({
        title: "Bad priority",
        taskType: "FREEFORM",
        priority: 0,
      }),
    ).toThrow("Priority must be between 1 and 5.");
  });
});
