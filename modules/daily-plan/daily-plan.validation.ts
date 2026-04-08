import type { TaskType } from "@/types/domain";

export interface CreateTaskInput {
  title: string;
  taskType: TaskType;
  priority: number;
  categoryName?: string;
  linkedQuestionSlug?: string;
  linkedQuestionTitle?: string;
}

const validTaskTypes: TaskType[] = [
  "QUESTION_LINKED",
  "CATEGORY_PRACTICE",
  "FREEFORM",
];

function readRequiredString(value: unknown, fieldName: string) {
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new Error(`${fieldName} is required.`);
  }

  return value.trim();
}

function readOptionalString(value: unknown) {
  if (typeof value !== "string") {
    return undefined;
  }

  const trimmed = value.trim();

  return trimmed.length > 0 ? trimmed : undefined;
}

export function parseCreateTaskInput(input: {
  title: unknown;
  taskType: unknown;
  priority: unknown;
  categoryName?: unknown;
  linkedQuestionSlug?: unknown;
  linkedQuestionTitle?: unknown;
}, validCategoryNames: string[] = []): CreateTaskInput {
  const title = readRequiredString(input.title, "Title");

  if (typeof input.taskType !== "string" || !validTaskTypes.includes(input.taskType as TaskType)) {
    throw new Error("Task type is invalid.");
  }

  const numericPriority =
    typeof input.priority === "number"
      ? input.priority
      : Number.parseInt(String(input.priority), 10);

  if (!Number.isInteger(numericPriority) || numericPriority < 1 || numericPriority > 5) {
    throw new Error("Priority must be between 1 and 5.");
  }

  const taskType = input.taskType as TaskType;
  const categoryName = readOptionalString(input.categoryName);
  const linkedQuestionSlug = readOptionalString(input.linkedQuestionSlug);
  const linkedQuestionTitle = readOptionalString(input.linkedQuestionTitle);

  if (
    categoryName &&
    validCategoryNames.length > 0 &&
    !validCategoryNames.includes(categoryName)
  ) {
    throw new Error("Category is invalid.");
  }

  if (taskType === "CATEGORY_PRACTICE" && !categoryName) {
    throw new Error("Category-practice tasks require a category.");
  }

  if (taskType === "QUESTION_LINKED" && (!linkedQuestionSlug || !linkedQuestionTitle)) {
    throw new Error("Question-linked tasks require question details.");
  }

  if (taskType === "QUESTION_LINKED" && !categoryName) {
    throw new Error("Question-linked tasks require a category.");
  }

  return {
    title,
    taskType,
    priority: numericPriority,
    categoryName,
    linkedQuestionSlug:
      taskType === "QUESTION_LINKED" ? linkedQuestionSlug : undefined,
    linkedQuestionTitle:
      taskType === "QUESTION_LINKED" ? linkedQuestionTitle : undefined,
  };
}
