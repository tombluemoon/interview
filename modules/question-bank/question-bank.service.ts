import {
  getCategories,
  getQuestionById,
  getQuestionBySlug,
  getQuestionSummaries,
  getRelatedQuestions,
} from "@/lib/mock-data";
import { getSql, isDatabaseConfigured } from "@/lib/db";
import type { ProgressStatus } from "@/types/domain";

interface QuestionRow {
  id: string;
  slug: string;
  title: string;
  categoryId: string;
  categoryName: string;
  difficulty: "Easy" | "Medium" | "Hard";
  tags: string[];
  excerpt: string;
  body: string;
  hint: string | null;
  referenceAnswer: string | null;
  progressStatus:
    | "NOT_STARTED"
    | "PLANNED"
    | "IN_PROGRESS"
    | "REVIEWED"
    | "MASTERED"
    | null;
  relatedSlugs: string[];
}

function mapQuestionRow(row: QuestionRow) {
  return {
    ...row,
    hint: row.hint ?? undefined,
    referenceAnswer: row.referenceAnswer ?? undefined,
    progressStatus: row.progressStatus ?? undefined,
  };
}

function stripQuestionProgress<T extends { progressStatus?: ProgressStatus }>(
  question: T,
) {
  return {
    ...question,
    progressStatus: undefined,
  };
}

export async function listCategories() {
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
      AND q.visibility = 'PUBLIC'
      AND q.content_status = 'PUBLISHED'
    GROUP BY c.id
    ORDER BY c.name ASC
  `;

  return rows;
}

export async function listQuestions(
  filters?: { q?: string; category?: string },
  userId?: string,
) {
  if (!isDatabaseConfigured()) {
    const questions = getQuestionSummaries(filters);

    return userId
      ? questions
      : questions.map((question) => stripQuestionProgress(question));
  }

  const sql = getSql();
  const query = filters?.q ? `%${filters.q}%` : undefined;
  const progressUserId = userId ?? "__anonymous__";
  let rows: QuestionRow[] = [];

  if (query && filters?.category) {
    rows = await sql<QuestionRow[]>`
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
        p.progress_status AS "progressStatus",
        q.related_slugs AS "relatedSlugs"
      FROM questions q
      INNER JOIN question_categories c
        ON c.id = q.category_id
      LEFT JOIN user_question_progress p
        ON p.question_id = q.id
        AND p.user_id = ${progressUserId}
      WHERE q.visibility = 'PUBLIC'
        AND q.content_status = 'PUBLISHED'
        AND q.category_id = ${filters.category}
        AND (
          q.title ILIKE ${query}
          OR EXISTS (
            SELECT 1
            FROM unnest(q.tags) AS tag
            WHERE tag ILIKE ${query}
          )
        )
      ORDER BY c.name ASC, q.title ASC
    `;
  } else if (query) {
    rows = await sql<QuestionRow[]>`
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
        p.progress_status AS "progressStatus",
        q.related_slugs AS "relatedSlugs"
      FROM questions q
      INNER JOIN question_categories c
        ON c.id = q.category_id
      LEFT JOIN user_question_progress p
        ON p.question_id = q.id
        AND p.user_id = ${progressUserId}
      WHERE q.visibility = 'PUBLIC'
        AND q.content_status = 'PUBLISHED'
        AND (
          q.title ILIKE ${query}
          OR EXISTS (
            SELECT 1
            FROM unnest(q.tags) AS tag
            WHERE tag ILIKE ${query}
          )
        )
      ORDER BY c.name ASC, q.title ASC
    `;
  } else if (filters?.category) {
    rows = await sql<QuestionRow[]>`
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
        p.progress_status AS "progressStatus",
        q.related_slugs AS "relatedSlugs"
      FROM questions q
      INNER JOIN question_categories c
        ON c.id = q.category_id
      LEFT JOIN user_question_progress p
        ON p.question_id = q.id
        AND p.user_id = ${progressUserId}
      WHERE q.visibility = 'PUBLIC'
        AND q.content_status = 'PUBLISHED'
        AND q.category_id = ${filters.category}
      ORDER BY c.name ASC, q.title ASC
    `;
  } else {
    rows = await sql<QuestionRow[]>`
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
        p.progress_status AS "progressStatus",
        q.related_slugs AS "relatedSlugs"
      FROM questions q
      INNER JOIN question_categories c
        ON c.id = q.category_id
      LEFT JOIN user_question_progress p
        ON p.question_id = q.id
        AND p.user_id = ${progressUserId}
      WHERE q.visibility = 'PUBLIC'
        AND q.content_status = 'PUBLISHED'
      ORDER BY c.name ASC, q.title ASC
    `;
  }

  return rows.map(mapQuestionRow);
}

export async function findQuestionBySlug(slug: string, userId?: string) {
  if (!isDatabaseConfigured()) {
    const question = getQuestionBySlug(slug);

    return question && !userId ? stripQuestionProgress(question) : question;
  }

  const sql = getSql();
  const progressUserId = userId ?? "__anonymous__";
  const rows = await sql<QuestionRow[]>`
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
      p.progress_status AS "progressStatus",
      q.related_slugs AS "relatedSlugs"
    FROM questions q
    INNER JOIN question_categories c
      ON c.id = q.category_id
    LEFT JOIN user_question_progress p
      ON p.question_id = q.id
      AND p.user_id = ${progressUserId}
    WHERE q.slug = ${slug}
      AND q.visibility = 'PUBLIC'
      AND q.content_status = 'PUBLISHED'
    LIMIT 1
  `;

  return rows[0] ? mapQuestionRow(rows[0]) : null;
}

export async function findQuestionById(id: string, userId?: string) {
  if (!isDatabaseConfigured()) {
    const question = getQuestionById(id);

    return question && !userId ? stripQuestionProgress(question) : question;
  }

  const sql = getSql();
  const progressUserId = userId ?? "__anonymous__";
  const rows = await sql<QuestionRow[]>`
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
      p.progress_status AS "progressStatus",
      q.related_slugs AS "relatedSlugs"
    FROM questions q
    INNER JOIN question_categories c
      ON c.id = q.category_id
    LEFT JOIN user_question_progress p
      ON p.question_id = q.id
      AND p.user_id = ${progressUserId}
    WHERE q.id = ${id}
      AND q.visibility = 'PUBLIC'
      AND q.content_status = 'PUBLISHED'
    LIMIT 1
  `;

  return rows[0] ? mapQuestionRow(rows[0]) : null;
}

export async function listRelatedQuestions(slugs: string[], userId?: string) {
  if (!slugs.length) {
    return [];
  }

  if (!isDatabaseConfigured()) {
    const questions = getRelatedQuestions(slugs);

    return userId
      ? questions
      : questions.map((question) => stripQuestionProgress(question));
  }

  const questions = await listQuestions(undefined, userId);

  return questions.filter((question) => slugs.includes(question.slug));
}

export async function findAdminQuestionById(id: string) {
  if (!isDatabaseConfigured()) {
    return getQuestionById(id);
  }

  const sql = getSql();
  const rows = await sql<QuestionRow[]>`
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
      p.progress_status AS "progressStatus",
      q.related_slugs AS "relatedSlugs"
    FROM questions q
    INNER JOIN question_categories c
      ON c.id = q.category_id
    LEFT JOIN user_question_progress p
      ON p.question_id = q.id
      AND p.user_id = '__anonymous__'
    WHERE q.id = ${id}
    LIMIT 1
  `;

  return rows[0] ? mapQuestionRow(rows[0]) : null;
}

export async function upsertQuestionProgress(input: {
  questionId: string;
  progressStatus: ProgressStatus;
}, userId?: string) {
  if (!isDatabaseConfigured()) {
    const question = getQuestionById(input.questionId);

    if (!question) {
      return null;
    }

    question.progressStatus = input.progressStatus;

    return {
      questionId: input.questionId,
      progressStatus: input.progressStatus,
    };
  }

  const sql = getSql();
  const activeUserId = userId;

  if (!activeUserId) {
    throw new Error("User context is required.");
  }

  const rows = await sql<{
    questionId: string;
    progressStatus: ProgressStatus;
  }[]>`
    INSERT INTO user_question_progress (
      user_id,
      question_id,
      progress_status,
      review_count,
      updated_at
    )
    VALUES (
      ${activeUserId},
      ${input.questionId},
      ${input.progressStatus},
      CASE
        WHEN ${input.progressStatus} IN ('REVIEWED', 'MASTERED') THEN 1
        ELSE 0
      END,
      NOW()
    )
    ON CONFLICT (user_id, question_id)
    DO UPDATE SET
      progress_status = EXCLUDED.progress_status,
      review_count = CASE
        WHEN EXCLUDED.progress_status IN ('REVIEWED', 'MASTERED')
          THEN user_question_progress.review_count + 1
        ELSE user_question_progress.review_count
      END,
      updated_at = NOW()
    RETURNING
      question_id AS "questionId",
      progress_status AS "progressStatus"
  `;

  return rows[0] ?? null;
}
