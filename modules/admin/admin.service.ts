import { randomUUID } from "node:crypto";

import {
  categories as mockCategories,
  demoAdmin,
  demoUser,
  getCategories,
  getQuestionById,
  questions,
  todayTasks,
} from "@/lib/mock-data";
import { getSql, isDatabaseConfigured } from "@/lib/db";
import type {
  Category,
  Difficulty,
  QuestionContentStatus,
  QuestionVisibility,
} from "@/types/domain";

import type {
  AdminCategoryInput,
  AdminQuestionFilters,
  AdminQuestionInput,
} from "@/modules/admin/admin.validation";

type AdminCategoryRow = Category;

interface AdminQuestionRow {
  id: string;
  slug: string;
  title: string;
  categoryId: string;
  categoryName: string;
  difficulty: Difficulty;
  tags: string[];
  excerpt: string;
  body: string;
  hint: string | null;
  referenceAnswer: string | null;
  relatedSlugs: string[];
  visibility: QuestionVisibility;
  contentStatus: QuestionContentStatus;
}

export class AdminServiceError extends Error {
  code: string;
  status: number;

  constructor(message: string, code: string, status: number) {
    super(message);
    this.name = "AdminServiceError";
    this.code = code;
    this.status = status;
  }
}

function mapAdminQuestionRow(row: AdminQuestionRow) {
  return {
    ...row,
    hint: row.hint ?? undefined,
    referenceAnswer: row.referenceAnswer ?? undefined,
  };
}

function formatContentStatus(status: QuestionContentStatus) {
  switch (status) {
    case "PUBLISHED":
      return "Published";
    case "ARCHIVED":
      return "Archived";
    default:
      return "Draft";
  }
}

export function isAdminServiceError(error: unknown): error is AdminServiceError {
  return error instanceof AdminServiceError;
}

function replaceCategoryName(values: string[], previousName: string, nextName: string) {
  return Array.from(
    new Set(
      values.map((value) => (value === previousName ? nextName : value)),
    ),
  );
}

function syncMockCategoryRename(
  categoryId: string,
  previousName: string,
  nextName: string,
) {
  for (const question of questions) {
    if (question.categoryId === categoryId) {
      question.categoryName = nextName;
    }
  }

  for (const task of todayTasks) {
    if (task.categoryName === previousName) {
      task.categoryName = nextName;
    }
  }

  demoUser.preferredTracks = replaceCategoryName(
    demoUser.preferredTracks,
    previousName,
    nextName,
  );
  demoAdmin.preferredTracks = replaceCategoryName(
    demoAdmin.preferredTracks,
    previousName,
    nextName,
  );
}

async function ensureUniqueCategorySlug(slug: string, ignoreId?: string) {
  if (!isDatabaseConfigured()) {
    const existing = mockCategories.find(
      (category) => category.slug === slug && category.id !== ignoreId,
    );

    if (existing) {
      throw new AdminServiceError(
        "A category with this slug already exists.",
        "SLUG_TAKEN",
        409,
      );
    }

    return;
  }

  const sql = getSql();
  const rows = await sql<{ id: string }[]>`
    SELECT id
    FROM question_categories
    WHERE slug = ${slug}
      ${ignoreId ? sql`AND id <> ${ignoreId}` : sql``}
    LIMIT 1
  `;

  if (rows[0]) {
    throw new AdminServiceError(
      "A category with this slug already exists.",
      "SLUG_TAKEN",
      409,
    );
  }
}

async function ensureUniqueCategoryName(name: string, ignoreId?: string) {
  if (!isDatabaseConfigured()) {
    const existing = mockCategories.find(
      (category) => category.name === name && category.id !== ignoreId,
    );

    if (existing) {
      throw new AdminServiceError(
        "A category with this name already exists.",
        "NAME_TAKEN",
        409,
      );
    }

    return;
  }

  const sql = getSql();
  const rows = await sql<{ id: string }[]>`
    SELECT id
    FROM question_categories
    WHERE name = ${name}
      ${ignoreId ? sql`AND id <> ${ignoreId}` : sql``}
    LIMIT 1
  `;

  if (rows[0]) {
    throw new AdminServiceError(
      "A category with this name already exists.",
      "NAME_TAKEN",
      409,
    );
  }
}

export async function listAdminQuestions(filters?: AdminQuestionFilters) {
  if (!isDatabaseConfigured()) {
    return questions
      .filter((question) => {
        const contentStatus = question.contentStatus ?? "PUBLISHED";
        const matchesQuery =
          !filters?.q ||
          question.title.toLowerCase().includes(filters.q.toLowerCase()) ||
          question.slug.toLowerCase().includes(filters.q.toLowerCase()) ||
          question.tags.some((tag) =>
            tag.toLowerCase().includes(filters.q!.toLowerCase()),
          );
        const matchesCategory =
          !filters?.category || question.categoryId === filters.category;
        const matchesStatus =
          !filters?.status || contentStatus === filters.status;

        return matchesQuery && matchesCategory && matchesStatus;
      })
      .map((question) => ({
        id: question.id,
        title: question.title,
        slug: question.slug,
        categoryId: question.categoryId,
        categoryName: question.categoryName,
        difficulty: question.difficulty,
        contentStatus: question.contentStatus ?? "PUBLISHED",
        statusLabel: formatContentStatus(question.contentStatus ?? "PUBLISHED"),
      }));
  }

  const sql = getSql();
  const query = filters?.q ? `%${filters.q}%` : undefined;
  const queryFragment = query
    ? sql`
        AND (
          q.title ILIKE ${query}
          OR q.slug ILIKE ${query}
          OR EXISTS (
            SELECT 1
            FROM unnest(q.tags) AS tag
            WHERE tag ILIKE ${query}
          )
        )
      `
    : sql``;
  const categoryFragment = filters?.category
    ? sql`AND q.category_id = ${filters.category}`
    : sql``;
  const statusFragment = filters?.status
    ? sql`AND q.content_status = ${filters.status}`
    : sql``;

  const rows = await sql<AdminQuestionRow[]>`
    SELECT
      q.id,
      q.slug,
      q.title,
      c.id AS "categoryId",
      c.name AS "categoryName",
      q.difficulty,
      q.tags,
      q.excerpt,
      q.body,
      q.hint,
      q.reference_answer AS "referenceAnswer",
      q.related_slugs AS "relatedSlugs",
      q.visibility,
      q.content_status AS "contentStatus"
    FROM questions q
    INNER JOIN question_categories c
      ON c.id = q.category_id
    WHERE 1 = 1
      ${queryFragment}
      ${categoryFragment}
      ${statusFragment}
    ORDER BY q.created_at DESC, q.title ASC
  `;

  return rows.map((row) => ({
    id: row.id,
    title: row.title,
    slug: row.slug,
    categoryId: row.categoryId,
    categoryName: row.categoryName,
    difficulty: row.difficulty,
    contentStatus: row.contentStatus,
    statusLabel: formatContentStatus(row.contentStatus),
  }));
}

export async function listAdminCategories() {
  if (!isDatabaseConfigured()) {
    return getCategories();
  }

  const sql = getSql();
  const rows = await sql<{
    id: string;
    name: string;
    slug: string;
    description: string;
    questionCount: number;
  }[]>`
    SELECT
      c.id,
      c.name,
      c.slug,
      c.description,
      COUNT(q.id)::int AS "questionCount"
    FROM question_categories c
    LEFT JOIN questions q
      ON q.category_id = c.id
    GROUP BY c.id
    ORDER BY c.name ASC
  `;

  return rows;
}

export async function getAdminCategoryById(id: string) {
  if (!isDatabaseConfigured()) {
    return mockCategories.find((category) => category.id === id) ?? null;
  }

  const sql = getSql();
  const rows = await sql<AdminCategoryRow[]>`
    SELECT
      c.id,
      c.name,
      c.slug,
      c.description,
      COUNT(q.id)::int AS "questionCount"
    FROM question_categories c
    LEFT JOIN questions q
      ON q.category_id = c.id
    WHERE c.id = ${id}
    GROUP BY c.id
    LIMIT 1
  `;

  return rows[0] ?? null;
}

export async function createAdminCategory(input: AdminCategoryInput) {
  await ensureUniqueCategorySlug(input.slug);
  await ensureUniqueCategoryName(input.name);

  if (!isDatabaseConfigured()) {
    const category = {
      id: `cat_${randomUUID().replaceAll("-", "").slice(0, 12)}`,
      name: input.name,
      slug: input.slug,
      description: input.description,
      questionCount: 0,
    };

    mockCategories.unshift(category);

    return category;
  }

  const sql = getSql();
  const rows = await sql<AdminCategoryRow[]>`
    INSERT INTO question_categories (
      id,
      name,
      slug,
      description
    )
    VALUES (
      ${`cat_${randomUUID().replaceAll("-", "").slice(0, 12)}`},
      ${input.name},
      ${input.slug},
      ${input.description}
    )
    RETURNING
      id,
      name,
      slug,
      description,
      0::int AS "questionCount"
  `;

  if (!rows[0]) {
    throw new AdminServiceError(
      "Category creation failed.",
      "CREATE_FAILED",
      500,
    );
  }

  return rows[0];
}

export async function updateAdminCategory(
  categoryId: string,
  input: AdminCategoryInput,
) {
  await ensureUniqueCategorySlug(input.slug, categoryId);
  await ensureUniqueCategoryName(input.name, categoryId);

  if (!isDatabaseConfigured()) {
    const category = mockCategories.find((entry) => entry.id === categoryId);

    if (!category) {
      throw new AdminServiceError("Category not found.", "NOT_FOUND", 404);
    }

    const previousName = category.name;
    category.name = input.name;
    category.slug = input.slug;
    category.description = input.description;
    syncMockCategoryRename(categoryId, previousName, input.name);

    return category;
  }

  const sql = getSql();
  return sql.begin(async (transaction) => {
    const existingRows = await transaction<{ id: string; name: string }[]>`
      SELECT
        id,
        name
      FROM question_categories
      WHERE id = ${categoryId}
      LIMIT 1
    `;
    const existingCategory = existingRows[0];

    if (!existingCategory) {
      throw new AdminServiceError("Category not found.", "NOT_FOUND", 404);
    }

    const rows = await transaction<AdminCategoryRow[]>`
      UPDATE question_categories
      SET
        name = ${input.name},
        slug = ${input.slug},
        description = ${input.description}
      WHERE id = ${categoryId}
      RETURNING
        id,
        name,
        slug,
        description,
        (
          SELECT COUNT(*)::int
          FROM questions
          WHERE category_id = question_categories.id
        ) AS "questionCount"
    `;

    if (!rows[0]) {
      throw new AdminServiceError("Category not found.", "NOT_FOUND", 404);
    }

    await transaction`
      UPDATE users
      SET preferred_tracks = ARRAY(
        SELECT CASE
          WHEN track_value = ${existingCategory.name} THEN ${input.name}
          ELSE track_value
        END
        FROM unnest(preferred_tracks) WITH ORDINALITY AS track(track_value, ord)
        ORDER BY ord
      )
      WHERE ${existingCategory.name} = ANY(preferred_tracks)
    `;
    await transaction`
      UPDATE study_tasks
      SET category_name = ${input.name}
      WHERE category_id = ${categoryId}
        OR (
          category_id IS NULL
          AND category_name = ${existingCategory.name}
        )
    `;

    return rows[0];
  });
}

export async function deleteAdminCategory(categoryId: string) {
  if (!isDatabaseConfigured()) {
    const categoryIndex = mockCategories.findIndex(
      (entry) => entry.id === categoryId,
    );

    if (categoryIndex === -1) {
      throw new AdminServiceError("Category not found.", "NOT_FOUND", 404);
    }

    const category = mockCategories[categoryIndex];
    const questionCount = questions.filter(
      (question) => question.categoryId === categoryId,
    ).length;
    const taskCount = todayTasks.filter(
      (task) => task.categoryName === category.name,
    ).length;
    const preferenceCount = [demoUser, demoAdmin].filter((user) =>
      user.preferredTracks.includes(category.name),
    ).length;

    if (questionCount > 0 || taskCount > 0 || preferenceCount > 0) {
      throw new AdminServiceError(
        "Categories with linked questions, tasks, or preferred tracks cannot be deleted.",
        "CATEGORY_IN_USE",
        409,
      );
    }

    const [deletedCategory] = mockCategories.splice(categoryIndex, 1);

    return deletedCategory;
  }

  const sql = getSql();
  return sql.begin(async (transaction) => {
    const existingRows = await transaction<{
      id: string;
      name: string;
      questionCount: number;
      taskCount: number;
      preferenceCount: number;
    }[]>`
      SELECT
        c.id,
        c.name,
        (
          SELECT COUNT(*)::int
          FROM questions
          WHERE category_id = c.id
        ) AS "questionCount",
        (
          SELECT COUNT(*)::int
          FROM study_tasks
          WHERE category_id = c.id
            OR (
              category_id IS NULL
              AND category_name = c.name
            )
        ) AS "taskCount",
        (
          SELECT COUNT(*)::int
          FROM users
          WHERE c.name = ANY(preferred_tracks)
        ) AS "preferenceCount"
      FROM question_categories c
      WHERE c.id = ${categoryId}
      LIMIT 1
    `;
    const existingCategory = existingRows[0];

    if (!existingCategory) {
      throw new AdminServiceError("Category not found.", "NOT_FOUND", 404);
    }

    if (
      existingCategory.questionCount > 0 ||
      existingCategory.taskCount > 0 ||
      existingCategory.preferenceCount > 0
    ) {
      throw new AdminServiceError(
        "Categories with linked questions, tasks, or preferred tracks cannot be deleted.",
        "CATEGORY_IN_USE",
        409,
      );
    }

    const rows = await transaction<AdminCategoryRow[]>`
      DELETE FROM question_categories
      WHERE id = ${categoryId}
      RETURNING
        id,
        name,
        slug,
        description,
        0::int AS "questionCount"
    `;

    if (!rows[0]) {
      throw new AdminServiceError("Category not found.", "NOT_FOUND", 404);
    }

    return rows[0];
  });
}

export async function getAdminQuestionById(id: string) {
  if (!isDatabaseConfigured()) {
    const question = getQuestionById(id);

    if (!question) {
      return null;
    }

    return {
      ...question,
      hint: question.hint ?? undefined,
      referenceAnswer: question.referenceAnswer ?? undefined,
      visibility: question.visibility ?? "PUBLIC",
      contentStatus: question.contentStatus ?? "PUBLISHED",
    };
  }

  const sql = getSql();
  const rows = await sql<AdminQuestionRow[]>`
    SELECT
      q.id,
      q.slug,
      q.title,
      c.id AS "categoryId",
      c.name AS "categoryName",
      q.difficulty,
      q.tags,
      q.excerpt,
      q.body,
      q.hint,
      q.reference_answer AS "referenceAnswer",
      q.related_slugs AS "relatedSlugs",
      q.visibility,
      q.content_status AS "contentStatus"
    FROM questions q
    INNER JOIN question_categories c
      ON c.id = q.category_id
    WHERE q.id = ${id}
    LIMIT 1
  `;

  return rows[0] ? mapAdminQuestionRow(rows[0]) : null;
}

async function ensureUniqueSlug(slug: string, ignoreId?: string) {
  if (!isDatabaseConfigured()) {
    const existing = questions.find(
      (question) => question.slug === slug && question.id !== ignoreId,
    );

    if (existing) {
      throw new AdminServiceError(
        "A question with this slug already exists.",
        "SLUG_TAKEN",
        409,
      );
    }

    return;
  }

  const sql = getSql();
  const rows = await sql<{ id: string }[]>`
    SELECT id
    FROM questions
    WHERE slug = ${slug}
      ${ignoreId ? sql`AND id <> ${ignoreId}` : sql``}
    LIMIT 1
  `;

  if (rows[0]) {
    throw new AdminServiceError(
      "A question with this slug already exists.",
      "SLUG_TAKEN",
      409,
    );
  }
}

export async function createAdminQuestion(input: AdminQuestionInput) {
  await ensureUniqueSlug(input.slug);

  if (!isDatabaseConfigured()) {
    const category = getCategories().find(
      (entry) => entry.id === input.categoryId,
    );

    if (!category) {
      throw new AdminServiceError("Category not found.", "NOT_FOUND", 404);
    }

    const question = {
      id: `q_${randomUUID().replaceAll("-", "").slice(0, 12)}`,
      slug: input.slug,
      title: input.title,
      categoryId: category.id,
      categoryName: category.name,
      difficulty: input.difficulty,
      tags: input.tags,
      excerpt: input.excerpt,
      body: input.body,
      hint: input.hint,
      referenceAnswer: input.referenceAnswer,
      relatedSlugs: input.relatedSlugs,
      visibility: input.visibility,
      contentStatus: input.contentStatus,
    };

    questions.unshift(question);

    return question;
  }

  const sql = getSql();
  const questionId = `q_${randomUUID().replaceAll("-", "").slice(0, 12)}`;
  const rows = await sql<AdminQuestionRow[]>`
    INSERT INTO questions (
      id,
      slug,
      title,
      category_id,
      difficulty,
      tags,
      excerpt,
      body,
      hint,
      reference_answer,
      related_slugs,
      visibility,
      content_status
    )
    VALUES (
      ${questionId},
      ${input.slug},
      ${input.title},
      ${input.categoryId},
      ${input.difficulty},
      ${input.tags},
      ${input.excerpt},
      ${input.body},
      ${input.hint ?? null},
      ${input.referenceAnswer ?? null},
      ${input.relatedSlugs},
      ${input.visibility},
      ${input.contentStatus}
    )
    RETURNING
      id,
      slug,
      title,
      ${input.categoryId} AS "categoryId",
      (
        SELECT name
        FROM question_categories
        WHERE id = ${input.categoryId}
      ) AS "categoryName",
      difficulty,
      tags,
      excerpt,
      body,
      hint,
      reference_answer AS "referenceAnswer",
      related_slugs AS "relatedSlugs",
      visibility,
      content_status AS "contentStatus"
  `;

  if (!rows[0]) {
    throw new AdminServiceError(
      "Question creation failed.",
      "CREATE_FAILED",
      500,
    );
  }

  return mapAdminQuestionRow(rows[0]);
}

export async function updateAdminQuestion(
  questionId: string,
  input: AdminQuestionInput,
) {
  await ensureUniqueSlug(input.slug, questionId);

  if (!isDatabaseConfigured()) {
    const question = questions.find((entry) => entry.id === questionId);
    const category = getCategories().find(
      (entry) => entry.id === input.categoryId,
    );

    if (!question || !category) {
      throw new AdminServiceError("Question not found.", "NOT_FOUND", 404);
    }

    question.slug = input.slug;
    question.title = input.title;
    question.categoryId = category.id;
    question.categoryName = category.name;
    question.difficulty = input.difficulty;
    question.tags = input.tags;
    question.excerpt = input.excerpt;
    question.body = input.body;
    question.hint = input.hint;
    question.referenceAnswer = input.referenceAnswer;
    question.relatedSlugs = input.relatedSlugs;
    question.visibility = input.visibility;
    question.contentStatus = input.contentStatus;

    return {
      ...question,
      hint: question.hint ?? undefined,
      referenceAnswer: question.referenceAnswer ?? undefined,
    };
  }

  const sql = getSql();
  const rows = await sql<AdminQuestionRow[]>`
    UPDATE questions
    SET
      slug = ${input.slug},
      title = ${input.title},
      category_id = ${input.categoryId},
      difficulty = ${input.difficulty},
      tags = ${input.tags},
      excerpt = ${input.excerpt},
      body = ${input.body},
      hint = ${input.hint ?? null},
      reference_answer = ${input.referenceAnswer ?? null},
      related_slugs = ${input.relatedSlugs},
      visibility = ${input.visibility},
      content_status = ${input.contentStatus}
    WHERE id = ${questionId}
    RETURNING
      id,
      slug,
      title,
      ${input.categoryId} AS "categoryId",
      (
        SELECT name
        FROM question_categories
        WHERE id = ${input.categoryId}
      ) AS "categoryName",
      difficulty,
      tags,
      excerpt,
      body,
      hint,
      reference_answer AS "referenceAnswer",
      related_slugs AS "relatedSlugs",
      visibility,
      content_status AS "contentStatus"
  `;

  if (!rows[0]) {
    throw new AdminServiceError("Question not found.", "NOT_FOUND", 404);
  }

  return mapAdminQuestionRow(rows[0]);
}
