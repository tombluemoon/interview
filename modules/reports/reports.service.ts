import {
  backlogItems,
  categoryProgress as mockCategoryProgress,
  dailyTrend as mockDailyTrend,
  questions as mockQuestions,
  reportSummary,
} from "@/lib/mock-data";
import { getSql, isDatabaseConfigured } from "@/lib/db";
import {
  getAppTimeZone,
  getCurrentDateInAppTimeZone,
} from "@/lib/time";
import { calculateCurrentStreak } from "@/modules/reports/reports.helpers";

interface ReportFilters {
  rangeDays?: number;
  categoryId?: string;
  categoryName?: string;
}

function requireUserId(userId?: string) {
  if (!userId) {
    throw new Error("User context is required.");
  }

  return userId;
}

function normalizeFilters(filters?: ReportFilters) {
  const rangeDays =
    typeof filters?.rangeDays === "number" &&
    Number.isInteger(filters.rangeDays) &&
    filters.rangeDays > 0
      ? filters.rangeDays
      : 7;

  return {
    rangeDays,
    categoryId: filters?.categoryId,
    categoryName: filters?.categoryName,
  };
}

function getRangeStartDate(rangeDays: number) {
  return getCurrentDateInAppTimeZone(-(rangeDays - 1));
}

export async function getOverviewReport(
  userId?: string,
  filters?: ReportFilters,
) {
  const normalizedFilters = normalizeFilters(filters);

  if (!isDatabaseConfigured()) {
    const filteredQuestions = normalizedFilters.categoryId
      ? mockQuestions.filter(
          (question) => question.categoryId === normalizedFilters.categoryId,
        )
      : mockQuestions;

    return {
      tasksCompletedInRange: reportSummary.tasksCompletedInRange,
      reviewedQuestions: filteredQuestions.filter(
        (question) =>
          question.progressStatus === "REVIEWED" ||
          question.progressStatus === "MASTERED",
      ).length,
      masteredQuestions: filteredQuestions.filter(
        (question) => question.progressStatus === "MASTERED",
      ).length,
      currentStreak: reportSummary.currentStreak,
    };
  }

  const requiredUserId = requireUserId(userId);
  const sql = getSql();
  const rangeStartDate = getRangeStartDate(normalizedFilters.rangeDays);
  const appTimeZone = getAppTimeZone();
  const taskCategoryFragment = normalizedFilters.categoryId
    ? sql`AND category_id = ${normalizedFilters.categoryId}`
    : sql``;
  const questionCategoryFragment = normalizedFilters.categoryId
    ? sql`AND q.category_id = ${normalizedFilters.categoryId}`
    : sql``;

  const [taskSummary] = await sql<{
    tasksCompletedInRange: number;
  }[]>`
    SELECT
      COUNT(*)::int AS "tasksCompletedInRange"
    FROM study_tasks
    WHERE user_id = ${requiredUserId}
      AND status = 'COMPLETED'
      AND completed_at IS NOT NULL
      AND timezone(${appTimeZone}, completed_at)::date >= CAST(${rangeStartDate} AS date)
      ${taskCategoryFragment}
  `;
  const [questionSummary] = await sql<{
    reviewedQuestions: number;
    masteredQuestions: number;
  }[]>`
    SELECT
      COUNT(*) FILTER (
        WHERE p.progress_status IN ('REVIEWED', 'MASTERED')
      )::int AS "reviewedQuestions",
      COUNT(*) FILTER (
        WHERE p.progress_status = 'MASTERED'
      )::int AS "masteredQuestions"
    FROM questions q
    LEFT JOIN user_question_progress p
      ON p.question_id = q.id
      AND p.user_id = ${requiredUserId}
    WHERE q.visibility = 'PUBLIC'
      AND q.content_status = 'PUBLISHED'
      ${questionCategoryFragment}
  `;
  const streakRows = await sql<{
    completedDate: string | Date;
  }[]>`
    SELECT DISTINCT timezone(${appTimeZone}, completed_at)::date AS "completedDate"
    FROM study_tasks
    WHERE user_id = ${requiredUserId}
      AND status = 'COMPLETED'
      AND completed_at IS NOT NULL
      ${taskCategoryFragment}
    ORDER BY "completedDate" DESC
  `;

  return {
    tasksCompletedInRange: taskSummary?.tasksCompletedInRange ?? 0,
    reviewedQuestions: questionSummary?.reviewedQuestions ?? 0,
    masteredQuestions: questionSummary?.masteredQuestions ?? 0,
    currentStreak: calculateCurrentStreak(
      streakRows.map((row) => row.completedDate),
    ),
  };
}

export async function getDailyTrendReport(
  userId?: string,
  filters?: ReportFilters,
) {
  const normalizedFilters = normalizeFilters(filters);

  if (!isDatabaseConfigured()) {
    if (normalizedFilters.rangeDays <= mockDailyTrend.length) {
      return mockDailyTrend.slice(
        mockDailyTrend.length - normalizedFilters.rangeDays,
      );
    }

    return mockDailyTrend;
  }

  const requiredUserId = requireUserId(userId);
  const sql = getSql();
  const rangeStartDate = getRangeStartDate(normalizedFilters.rangeDays);
  const currentPlanDate = getCurrentDateInAppTimeZone();
  const appTimeZone = getAppTimeZone();
  const labelFormat = normalizedFilters.rangeDays > 7 ? "Mon DD" : "Dy";
  const taskCategoryFragment = normalizedFilters.categoryId
    ? sql`AND category_id = ${normalizedFilters.categoryId}`
    : sql``;

  const rows = await sql<{
    label: string;
    value: number;
  }[]>`
    SELECT
      TO_CHAR(day_series.day, ${labelFormat}) AS label,
      COALESCE(task_counts.completed_count, 0)::int AS value
    FROM generate_series(
      CAST(${rangeStartDate} AS date),
      CAST(${currentPlanDate} AS date),
      INTERVAL '1 day'
    ) AS day_series(day)
    LEFT JOIN (
      SELECT
        timezone(${appTimeZone}, completed_at)::date AS completed_day,
        COUNT(*)::int AS completed_count
      FROM study_tasks
      WHERE user_id = ${requiredUserId}
        AND status = 'COMPLETED'
        AND completed_at IS NOT NULL
        AND timezone(${appTimeZone}, completed_at)::date >= CAST(${rangeStartDate} AS date)
        ${taskCategoryFragment}
      GROUP BY completed_day
    ) AS task_counts
      ON task_counts.completed_day = day_series.day::date
    ORDER BY day_series.day ASC
  `;

  return rows.map((row) => ({
    ...row,
    label: row.label.trim(),
  }));
}

export async function getCategoryProgressReport(
  userId?: string,
  filters?: ReportFilters,
) {
  const normalizedFilters = normalizeFilters(filters);

  if (!isDatabaseConfigured()) {
    return normalizedFilters.categoryName
      ? mockCategoryProgress.filter(
          (entry) => entry.categoryName === normalizedFilters.categoryName,
        )
      : mockCategoryProgress;
  }

  const requiredUserId = requireUserId(userId);
  const sql = getSql();
  const questionCategoryFragment = normalizedFilters.categoryId
    ? sql`AND c.id = ${normalizedFilters.categoryId}`
    : sql``;

  const rows = await sql<{
    categoryName: string;
    reviewedCount: number;
    totalCount: number;
  }[]>`
    SELECT
      c.name AS "categoryName",
      COUNT(q.id) FILTER (
        WHERE p.progress_status IN ('REVIEWED', 'MASTERED')
      )::int AS "reviewedCount",
      COUNT(q.id)::int AS "totalCount"
    FROM question_categories c
    LEFT JOIN questions q
      ON q.category_id = c.id
      AND q.visibility = 'PUBLIC'
      AND q.content_status = 'PUBLISHED'
    LEFT JOIN user_question_progress p
      ON p.question_id = q.id
      AND p.user_id = ${requiredUserId}
    WHERE 1 = 1
      ${questionCategoryFragment}
    GROUP BY c.id
    HAVING COUNT(q.id) > 0
    ORDER BY c.name ASC
  `;

  return rows;
}

export async function getBacklogReport(
  userId?: string,
  filters?: ReportFilters,
) {
  const normalizedFilters = normalizeFilters(filters);

  if (!isDatabaseConfigured()) {
    if (normalizedFilters.categoryName) {
      return backlogItems.filter(
        (item) =>
          item.title.includes(normalizedFilters.categoryName as string) ||
          item.detail.includes(normalizedFilters.categoryName as string),
      );
    }

    return backlogItems;
  }

  const requiredUserId = requireUserId(userId);
  const sql = getSql();
  const currentPlanDate = getCurrentDateInAppTimeZone();
  const taskCategoryFragment = normalizedFilters.categoryId
    ? sql`AND category_id = ${normalizedFilters.categoryId}`
    : sql``;
  const questionCategoryFragment = normalizedFilters.categoryId
    ? sql`AND c.id = ${normalizedFilters.categoryId}`
    : sql``;

  const overdueTasks = await sql<{
    id: string;
    title: string;
    detail: string;
  }[]>`
    SELECT
      id,
      title,
      'Planned for ' || TO_CHAR(plan_date, 'YYYY-MM-DD') AS detail
    FROM study_tasks
    WHERE user_id = ${requiredUserId}
      AND status = 'PENDING'
      AND plan_date < CAST(${currentPlanDate} AS date)
      ${taskCategoryFragment}
    ORDER BY plan_date ASC, priority DESC
    LIMIT 2
  `;
  const lowCoverageCategories = await sql<{
    id: string;
    title: string;
    detail: string;
  }[]>`
    SELECT
      c.id,
      c.name || ' has low coverage' AS title,
      COUNT(q.id) FILTER (
        WHERE p.progress_status IN ('REVIEWED', 'MASTERED')
      )::text
      || ' of '
      || COUNT(q.id)::text
      || ' questions marked reviewed or mastered' AS detail
    FROM question_categories c
    LEFT JOIN questions q
      ON q.category_id = c.id
      AND q.visibility = 'PUBLIC'
      AND q.content_status = 'PUBLISHED'
    LEFT JOIN user_question_progress p
      ON p.question_id = q.id
      AND p.user_id = ${requiredUserId}
    WHERE 1 = 1
      ${questionCategoryFragment}
    GROUP BY c.id
    HAVING COUNT(q.id) > 0
    ORDER BY
      (
        COUNT(q.id) FILTER (
          WHERE p.progress_status IN ('REVIEWED', 'MASTERED')
        )::float / NULLIF(COUNT(q.id), 0)
      ) ASC
    LIMIT 2
  `;

  return [...overdueTasks, ...lowCoverageCategories];
}
