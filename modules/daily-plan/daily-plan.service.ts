import { randomUUID } from "node:crypto";

import {
  getCompletedTasks,
  getCategories,
  getPendingTasks,
  todayTasks,
} from "@/lib/mock-data";
import { getSql, isDatabaseConfigured } from "@/lib/db";
import {
  formatPlanDateLabel,
  getLocalPlanDate,
  parsePlanDateInput,
} from "@/modules/daily-plan/daily-plan.dates";
import {
  buildTodaySummary,
  filterVisibleTodayTasks,
} from "@/modules/daily-plan/daily-plan.helpers";
import type { CreateTaskInput } from "@/modules/daily-plan/daily-plan.validation";
import type { DailyPlan, ScheduledStudyTask, StudyTask } from "@/types/domain";
import { formatTimeInAppTimeZone } from "@/lib/time";

interface TaskRow {
  id: string;
  title: string;
  taskType: "QUESTION_LINKED" | "CATEGORY_PRACTICE" | "FREEFORM";
  status: "PENDING" | "COMPLETED" | "SKIPPED" | "CARRIED_OVER";
  priority: number;
  categoryId: string | null;
  categoryName: string | null;
  linkedQuestionSlug: string | null;
  linkedQuestionTitle: string | null;
  completedAt: string | Date | null;
  planDate?: string | null;
}

interface TaskCategoryReference {
  categoryId: string;
  categoryName: string;
}

export interface CarryOverTaskResult {
  sourceTask: StudyTask;
  nextTask: StudyTask | null;
}

function formatCompletedAt(value: string | Date | null) {
  if (!value) {
    return undefined;
  }

  return formatTimeInAppTimeZone(value);
}

function mapTaskRow(row: TaskRow): StudyTask {
  return {
    id: row.id,
    title: row.title,
    taskType: row.taskType,
    status: row.status,
    priority: row.priority,
    categoryName: row.categoryName ?? undefined,
    linkedQuestionSlug: row.linkedQuestionSlug ?? undefined,
    linkedQuestionTitle: row.linkedQuestionTitle ?? undefined,
    completedAt: formatCompletedAt(row.completedAt),
  };
}

function mapScheduledTaskRow(row: TaskRow): ScheduledStudyTask {
  return {
    ...mapTaskRow(row),
    planDate: row.planDate ?? getLocalPlanDate(),
  };
}

function requireUserId(userId?: string) {
  if (!userId) {
    throw new Error("User context is required.");
  }

  return userId;
}

function assertTaskInputIntegrity(input: CreateTaskInput) {
  if (input.taskType === "CATEGORY_PRACTICE" && !input.categoryName) {
    throw new Error("Category-practice tasks require a category.");
  }

  if (input.taskType === "QUESTION_LINKED") {
    if (!input.linkedQuestionSlug || !input.linkedQuestionTitle) {
      throw new Error("Question-linked tasks require question details.");
    }

    if (!input.categoryName) {
      throw new Error("Question-linked tasks require a category.");
    }
  }
}

async function resolveTaskCategoryReference(
  categoryName?: string,
  executor?: ReturnType<typeof getSql>,
): Promise<TaskCategoryReference | null> {
  if (!categoryName) {
    return null;
  }

  if (!isDatabaseConfigured()) {
    const category = getCategories().find((entry) => entry.name === categoryName);

    if (!category) {
      throw new Error("Category is invalid.");
    }

    return {
      categoryId: category.id,
      categoryName: category.name,
    };
  }

  const sqlExecutor = executor ?? getSql();
  const rows = await sqlExecutor<TaskCategoryReference[]>`
    SELECT
      id AS "categoryId",
      name AS "categoryName"
    FROM question_categories
    WHERE name = ${categoryName}
    LIMIT 1
  `;
  const category = rows[0];

  if (!category) {
    throw new Error("Category is invalid.");
  }

  return category;
}

function buildPlan(planDate: string, tasks: StudyTask[]): DailyPlan {
  const pendingTasks = tasks.filter((task) => task.status === "PENDING");
  const completedTasks = tasks.filter((task) => task.status === "COMPLETED");

  return {
    planDate,
    summary: buildTodaySummary(tasks),
    tasks,
    pendingTasks,
    completedTasks,
  };
}

function emptyPlan(planDate: string): DailyPlan {
  return buildPlan(planDate, []);
}

function getMockHistoryTasks(): ScheduledStudyTask[] {
  return getCompletedTasks().map((task) => ({
    ...task,
    planDate: getLocalPlanDate(),
  }));
}

export async function getDailyPlan(planDate: string, userId?: string) {
  const normalizedPlanDate = parsePlanDateInput(planDate);

  if (!isDatabaseConfigured()) {
    if (normalizedPlanDate !== getLocalPlanDate()) {
      return emptyPlan(normalizedPlanDate);
    }

    const tasks = filterVisibleTodayTasks(todayTasks);

    return {
      planDate: normalizedPlanDate,
      summary: buildTodaySummary(tasks),
      tasks,
      pendingTasks: getPendingTasks(),
      completedTasks: getCompletedTasks(),
    };
  }

  const sql = getSql();
  const rows = await sql<TaskRow[]>`
    SELECT
      id,
      title,
      task_type AS "taskType",
      status,
      priority,
      category_id AS "categoryId",
      COALESCE(
        (SELECT name FROM question_categories WHERE id = category_id),
        category_name
      ) AS "categoryName",
      linked_question_slug AS "linkedQuestionSlug",
      linked_question_title AS "linkedQuestionTitle",
      completed_at AS "completedAt"
    FROM study_tasks
    WHERE user_id = ${requireUserId(userId)}
      AND plan_date = ${normalizedPlanDate}::date
      AND status IN ('PENDING', 'COMPLETED')
    ORDER BY
      CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END ASC,
      priority DESC,
      created_at ASC
  `;

  return buildPlan(normalizedPlanDate, rows.map(mapTaskRow));
}

export async function getTodayPlan(userId?: string) {
  return getDailyPlan(getLocalPlanDate(), userId);
}

export async function getTomorrowPlan(userId?: string) {
  return getDailyPlan(getLocalPlanDate(1), userId);
}

export async function listOverdueTasks(userId?: string) {
  if (!isDatabaseConfigured()) {
    return [];
  }

  const sql = getSql();
  const todayPlanDate = getLocalPlanDate();
  const rows = await sql<TaskRow[]>`
    SELECT
      id,
      title,
      task_type AS "taskType",
      status,
      priority,
      category_id AS "categoryId",
      COALESCE(
        (SELECT name FROM question_categories WHERE id = category_id),
        category_name
      ) AS "categoryName",
      linked_question_slug AS "linkedQuestionSlug",
      linked_question_title AS "linkedQuestionTitle",
      completed_at AS "completedAt",
      TO_CHAR(plan_date, 'YYYY-MM-DD') AS "planDate"
    FROM study_tasks
    WHERE user_id = ${requireUserId(userId)}
      AND status = 'PENDING'
      AND plan_date < ${todayPlanDate}::date
    ORDER BY plan_date ASC, priority DESC, created_at ASC
  `;

  return rows.map(mapScheduledTaskRow);
}

export async function listRecentTaskHistory(userId?: string, limit = 12) {
  if (!isDatabaseConfigured()) {
    return getMockHistoryTasks();
  }

  const sql = getSql();
  const todayPlanDate = getLocalPlanDate();
  const rows = await sql<TaskRow[]>`
    SELECT
      id,
      title,
      task_type AS "taskType",
      status,
      priority,
      category_id AS "categoryId",
      COALESCE(
        (SELECT name FROM question_categories WHERE id = category_id),
        category_name
      ) AS "categoryName",
      linked_question_slug AS "linkedQuestionSlug",
      linked_question_title AS "linkedQuestionTitle",
      completed_at AS "completedAt",
      TO_CHAR(plan_date, 'YYYY-MM-DD') AS "planDate"
    FROM study_tasks
    WHERE user_id = ${requireUserId(userId)}
      AND status IN ('COMPLETED', 'CARRIED_OVER', 'SKIPPED')
      AND plan_date <= ${todayPlanDate}::date
    ORDER BY
      plan_date DESC,
      CASE
        WHEN completed_at IS NULL THEN created_at
        ELSE completed_at
      END DESC
    LIMIT ${limit}
  `;

  return rows.map(mapScheduledTaskRow);
}

export async function createTask(input: CreateTaskInput, userId?: string) {
  assertTaskInputIntegrity(input);
  const resolvedCategory = await resolveTaskCategoryReference(input.categoryName);
  const newTask = {
    id: `task_${randomUUID().replaceAll("-", "").slice(0, 12)}`,
    title: input.title,
    taskType: input.taskType,
    status: "PENDING" as const,
    priority: input.priority,
    categoryName: resolvedCategory?.categoryName,
    linkedQuestionSlug: input.linkedQuestionSlug,
    linkedQuestionTitle: input.linkedQuestionTitle,
    completedAt: undefined,
  };

  if (!isDatabaseConfigured()) {
    todayTasks.unshift(newTask);

    return newTask;
  }

  const sql = getSql();
  const rows = await sql<TaskRow[]>`
    INSERT INTO study_tasks (
      id,
      user_id,
      plan_date,
      title,
      task_type,
      status,
      priority,
      category_id,
      category_name,
      linked_question_slug,
      linked_question_title
    )
    VALUES (
      ${newTask.id},
      ${requireUserId(userId)},
      ${getLocalPlanDate()}::date,
      ${newTask.title},
      ${newTask.taskType},
      ${newTask.status},
      ${newTask.priority},
      ${resolvedCategory?.categoryId ?? null},
      ${resolvedCategory?.categoryName ?? null},
      ${newTask.linkedQuestionSlug ?? null},
      ${newTask.linkedQuestionTitle ?? null}
    )
    RETURNING
      id,
      title,
      task_type AS "taskType",
      status,
      priority,
      category_id AS "categoryId",
      COALESCE(
        (SELECT name FROM question_categories WHERE id = category_id),
        category_name
      ) AS "categoryName",
      linked_question_slug AS "linkedQuestionSlug",
      linked_question_title AS "linkedQuestionTitle",
      completed_at AS "completedAt"
  `;

  return rows[0] ? mapTaskRow(rows[0]) : null;
}

export async function completeTask(taskId: string, userId?: string) {
  if (!isDatabaseConfigured()) {
    const task = todayTasks.find((entry) => entry.id === taskId);

    if (!task || task.status !== "PENDING") {
      return null;
    }

    task.status = "COMPLETED";
    task.completedAt = task.completedAt ?? "Now";

    return task;
  }

  const sql = getSql();
  const rows = await sql<TaskRow[]>`
    UPDATE study_tasks
    SET
      status = 'COMPLETED',
      completed_at = NOW()
    WHERE id = ${taskId}
      AND user_id = ${requireUserId(userId)}
      AND status = 'PENDING'
    RETURNING
      id,
      title,
      task_type AS "taskType",
      status,
      priority,
      category_id AS "categoryId",
      COALESCE(
        (SELECT name FROM question_categories WHERE id = category_id),
        category_name
      ) AS "categoryName",
      linked_question_slug AS "linkedQuestionSlug",
      linked_question_title AS "linkedQuestionTitle",
      completed_at AS "completedAt"
  `;

  return rows[0] ? mapTaskRow(rows[0]) : null;
}

export async function reopenTask(taskId: string, userId?: string) {
  if (!isDatabaseConfigured()) {
    const task = todayTasks.find((entry) => entry.id === taskId);

    if (!task || task.status !== "COMPLETED") {
      return null;
    }

    task.status = "PENDING";
    task.completedAt = undefined;

    return task;
  }

  const sql = getSql();
  const rows = await sql<TaskRow[]>`
    UPDATE study_tasks
    SET
      status = 'PENDING',
      completed_at = NULL
    WHERE id = ${taskId}
      AND user_id = ${requireUserId(userId)}
      AND status = 'COMPLETED'
    RETURNING
      id,
      title,
      task_type AS "taskType",
      status,
      priority,
      category_id AS "categoryId",
      COALESCE(
        (SELECT name FROM question_categories WHERE id = category_id),
        category_name
      ) AS "categoryName",
      linked_question_slug AS "linkedQuestionSlug",
      linked_question_title AS "linkedQuestionTitle",
      completed_at AS "completedAt"
  `;

  return rows[0] ? mapTaskRow(rows[0]) : null;
}

export async function updateTask(
  taskId: string,
  input: CreateTaskInput,
  userId?: string,
) {
  assertTaskInputIntegrity(input);
  const resolvedCategory = await resolveTaskCategoryReference(input.categoryName);

  if (!isDatabaseConfigured()) {
    const task = todayTasks.find((entry) => entry.id === taskId);

    if (!task) {
      return null;
    }

    task.title = input.title;
    task.taskType = input.taskType;
    task.priority = input.priority;
    task.categoryName = resolvedCategory?.categoryName;
    task.linkedQuestionSlug = input.linkedQuestionSlug;
    task.linkedQuestionTitle = input.linkedQuestionTitle;

    return task;
  }

  const sql = getSql();
  const rows = await sql<TaskRow[]>`
    UPDATE study_tasks
    SET
      title = ${input.title},
      task_type = ${input.taskType},
      priority = ${input.priority},
      category_id = ${resolvedCategory?.categoryId ?? null},
      category_name = ${resolvedCategory?.categoryName ?? null},
      linked_question_slug = ${input.linkedQuestionSlug ?? null},
      linked_question_title = ${input.linkedQuestionTitle ?? null}
    WHERE id = ${taskId}
      AND user_id = ${requireUserId(userId)}
    RETURNING
      id,
      title,
      task_type AS "taskType",
      status,
      priority,
      category_id AS "categoryId",
      COALESCE(
        (SELECT name FROM question_categories WHERE id = category_id),
        category_name
      ) AS "categoryName",
      linked_question_slug AS "linkedQuestionSlug",
      linked_question_title AS "linkedQuestionTitle",
      completed_at AS "completedAt"
  `;

  return rows[0] ? mapTaskRow(rows[0]) : null;
}

export async function deleteTask(taskId: string, userId?: string) {
  if (!isDatabaseConfigured()) {
    const taskIndex = todayTasks.findIndex((entry) => entry.id === taskId);

    if (taskIndex < 0) {
      return null;
    }

    const [task] = todayTasks.splice(taskIndex, 1);

    return task ?? null;
  }

  const sql = getSql();
  const rows = await sql<TaskRow[]>`
    DELETE FROM study_tasks
    WHERE id = ${taskId}
      AND user_id = ${requireUserId(userId)}
    RETURNING
      id,
      title,
      task_type AS "taskType",
      status,
      priority,
      category_id AS "categoryId",
      COALESCE(
        (SELECT name FROM question_categories WHERE id = category_id),
        category_name
      ) AS "categoryName",
      linked_question_slug AS "linkedQuestionSlug",
      linked_question_title AS "linkedQuestionTitle",
      completed_at AS "completedAt"
  `;

  return rows[0] ? mapTaskRow(rows[0]) : null;
}

export async function carryOverTask(
  taskId: string,
  userId?: string,
): Promise<CarryOverTaskResult | null> {
  if (!isDatabaseConfigured()) {
    const task = todayTasks.find((entry) => entry.id === taskId);

    if (!task || task.status !== "PENDING") {
      return null;
    }

    task.status = "CARRIED_OVER";

    return {
      sourceTask: task,
      nextTask: {
        ...task,
        id: `task_${randomUUID().replaceAll("-", "").slice(0, 12)}`,
        status: "PENDING",
        completedAt: undefined,
      },
    };
  }

  const activeUserId = requireUserId(userId);
  const sql = getSql();

  return sql.begin(async (transaction) => {
    const sourceRows = await transaction<TaskRow[]>`
      UPDATE study_tasks
      SET status = 'CARRIED_OVER'
      WHERE id = ${taskId}
        AND user_id = ${activeUserId}
        AND status = 'PENDING'
      RETURNING
        id,
        title,
        task_type AS "taskType",
        status,
        priority,
        category_id AS "categoryId",
        COALESCE(
          (SELECT name FROM question_categories WHERE id = category_id),
          category_name
        ) AS "categoryName",
        linked_question_slug AS "linkedQuestionSlug",
        linked_question_title AS "linkedQuestionTitle",
        completed_at AS "completedAt"
    `;
    const sourceTask = sourceRows[0];

    if (!sourceTask) {
      return null;
    }

    const nextTaskId = `task_${randomUUID().replaceAll("-", "").slice(0, 12)}`;
    const nextRows = await transaction<TaskRow[]>`
      INSERT INTO study_tasks (
        id,
        user_id,
        plan_date,
        title,
        task_type,
        status,
        priority,
        category_id,
        category_name,
        linked_question_slug,
        linked_question_title
      )
      VALUES (
        ${nextTaskId},
        ${activeUserId},
        ${getLocalPlanDate(1)}::date,
        ${sourceTask.title},
        ${sourceTask.taskType},
        'PENDING',
        ${sourceTask.priority},
        COALESCE(
          ${sourceTask.categoryId ?? null},
          (
            SELECT id
            FROM question_categories
            WHERE name = ${sourceTask.categoryName ?? null}
          )
        ),
        ${sourceTask.categoryName ?? null},
        ${sourceTask.linkedQuestionSlug ?? null},
        ${sourceTask.linkedQuestionTitle ?? null}
      )
      RETURNING
        id,
        title,
        task_type AS "taskType",
        status,
        priority,
        category_id AS "categoryId",
        COALESCE(
          (SELECT name FROM question_categories WHERE id = category_id),
          category_name
        ) AS "categoryName",
        linked_question_slug AS "linkedQuestionSlug",
        linked_question_title AS "linkedQuestionTitle",
        completed_at AS "completedAt"
    `;

    return {
      sourceTask: mapTaskRow(sourceTask),
      nextTask: nextRows[0] ? mapTaskRow(nextRows[0]) : null,
    };
  });
}

export function getPlanSectionMeta() {
  const todayPlanDate = getLocalPlanDate();
  const tomorrowPlanDate = getLocalPlanDate(1);

  return {
    todayPlanDate,
    tomorrowPlanDate,
    todayLabel: formatPlanDateLabel(todayPlanDate),
    tomorrowLabel: formatPlanDateLabel(tomorrowPlanDate),
  };
}
