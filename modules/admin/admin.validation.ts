import type {
  Difficulty,
  QuestionContentStatus,
  QuestionVisibility,
} from "@/types/domain";

import {
  buildQuestionExcerpt,
  parseCommaSeparatedList,
  slugifyText,
} from "@/modules/admin/admin.helpers";

const validDifficulties: Difficulty[] = ["Easy", "Medium", "Hard"];
const validContentStatuses: QuestionContentStatus[] = [
  "DRAFT",
  "PUBLISHED",
  "ARCHIVED",
];
const validVisibilities: QuestionVisibility[] = ["PUBLIC", "PRIVATE"];

export interface AdminQuestionInput {
  title: string;
  slug: string;
  categoryId: string;
  difficulty: Difficulty;
  tags: string[];
  excerpt: string;
  body: string;
  hint?: string;
  referenceAnswer?: string;
  relatedSlugs: string[];
  visibility: QuestionVisibility;
  contentStatus: QuestionContentStatus;
}

export interface AdminQuestionFilters {
  q?: string;
  category?: string;
  status?: QuestionContentStatus;
}

export interface AdminCategoryInput {
  name: string;
  slug: string;
  description: string;
}

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

export function parseAdminQuestionIntent(
  value: unknown,
  options?: { allowArchive?: boolean },
): QuestionContentStatus {
  if (value === "publish") {
    return "PUBLISHED";
  }

  if (value === "draft") {
    return "DRAFT";
  }

  if (value === "archive" && options?.allowArchive) {
    return "ARCHIVED";
  }

  throw new Error("Question intent is invalid.");
}

export function parseAdminQuestionInput(
  input: {
    title: unknown;
    slug?: unknown;
    categoryId: unknown;
    difficulty: unknown;
    tags?: unknown;
    excerpt?: unknown;
    body: unknown;
    hint?: unknown;
    referenceAnswer?: unknown;
    relatedSlugs?: unknown;
    visibility?: unknown;
    contentStatus: unknown;
  },
  validCategoryIds: string[],
): AdminQuestionInput {
  const title = readRequiredString(input.title, "Title");
  const body = readRequiredString(input.body, "Question body");
  const rawSlug = readOptionalString(input.slug);
  const slug = slugifyText(rawSlug ?? title);

  if (!slug) {
    throw new Error("Slug is required.");
  }

  if (
    typeof input.categoryId !== "string" ||
    !validCategoryIds.includes(input.categoryId)
  ) {
    throw new Error("Category is invalid.");
  }

  if (
    typeof input.difficulty !== "string" ||
    !validDifficulties.includes(input.difficulty as Difficulty)
  ) {
    throw new Error("Difficulty is invalid.");
  }

  if (
    typeof input.visibility !== "string" ||
    !validVisibilities.includes(input.visibility as QuestionVisibility)
  ) {
    throw new Error("Visibility is invalid.");
  }

  if (
    typeof input.contentStatus !== "string" ||
    !validContentStatuses.includes(input.contentStatus as QuestionContentStatus)
  ) {
    throw new Error("Content status is invalid.");
  }

  const excerpt = buildQuestionExcerpt(String(input.excerpt ?? ""), body);
  const tags = parseCommaSeparatedList(input.tags);
  const relatedSlugs = parseCommaSeparatedList(input.relatedSlugs).filter(
    (relatedSlug) => relatedSlug !== slug,
  );

  return {
    title,
    slug,
    categoryId: input.categoryId,
    difficulty: input.difficulty as Difficulty,
    tags,
    excerpt,
    body,
    hint: readOptionalString(input.hint),
    referenceAnswer: readOptionalString(input.referenceAnswer),
    relatedSlugs,
    visibility: input.visibility as QuestionVisibility,
    contentStatus: input.contentStatus as QuestionContentStatus,
  };
}

export function parseAdminQuestionFilters(
  input: {
    q?: unknown;
    category?: unknown;
    status?: unknown;
  },
  validCategoryIds: string[],
): AdminQuestionFilters {
  const q =
    typeof input.q === "string" && input.q.trim().length > 0
      ? input.q.trim()
      : undefined;
  const category =
    typeof input.category === "string" &&
    validCategoryIds.includes(input.category)
      ? input.category
      : undefined;
  const status =
    typeof input.status === "string" &&
    validContentStatuses.includes(input.status as QuestionContentStatus)
      ? (input.status as QuestionContentStatus)
      : undefined;

  return {
    q,
    category,
    status,
  };
}

export function parseAdminCategoryInput(input: {
  name: unknown;
  slug?: unknown;
  description: unknown;
}): AdminCategoryInput {
  const name = readRequiredString(input.name, "Name");
  const description = readRequiredString(input.description, "Description");
  const rawSlug = readOptionalString(input.slug);
  const slug = slugifyText(rawSlug ?? name);

  if (!slug) {
    throw new Error("Slug is required.");
  }

  return {
    name,
    slug,
    description,
  };
}
