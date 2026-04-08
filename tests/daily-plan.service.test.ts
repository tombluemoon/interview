import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { todayTasks } from "@/lib/mock-data";
import { formatTimeInAppTimeZone } from "@/lib/time";
import { getLocalPlanDate } from "@/modules/daily-plan/daily-plan.dates";
import type { CreateTaskInput } from "@/modules/daily-plan/daily-plan.validation";

import {
  importWithDbMock,
  importWithoutDb,
  restoreArray,
  restoreModuleMocks,
  snapshotArray,
} from "@/tests/test-utils";

const taskInput: CreateTaskInput = {
  title: "Practice SQL joins",
  taskType: "CATEGORY_PRACTICE",
  priority: 4,
  categoryName: "SQL",
  linkedQuestionSlug: undefined,
  linkedQuestionTitle: undefined,
};

describe("daily-plan.service", () => {
  const todayTaskSnapshot = snapshotArray(todayTasks);

  beforeEach(() => {
    vi.useFakeTimers();
    vi.stubEnv("APP_TIME_ZONE", "Asia/Tokyo");
    vi.setSystemTime(new Date("2026-04-06T15:30:00Z"));
    restoreArray(todayTasks, todayTaskSnapshot);
  });

  afterEach(() => {
    restoreModuleMocks();
    restoreArray(todayTasks, todayTaskSnapshot);
    vi.useRealTimers();
  });

  it("handles mock-mode plan reads", async () => {
    const dailyPlanService = await importWithoutDb<
      typeof import("@/modules/daily-plan/daily-plan.service")
    >("@/modules/daily-plan/daily-plan.service");

    const todayPlan = await dailyPlanService.getTodayPlan();
    const tomorrowPlan = await dailyPlanService.getTomorrowPlan();
    const customDate = getLocalPlanDate(-2);
    const emptyPlan = await dailyPlanService.getDailyPlan(customDate);
    const history = await dailyPlanService.listRecentTaskHistory();
    const sectionMeta = dailyPlanService.getPlanSectionMeta();

    expect(todayPlan.planDate).toBe(getLocalPlanDate());
    expect(todayPlan.pendingTasks).toHaveLength(3);
    expect(todayPlan.completedTasks).toHaveLength(2);
    expect(tomorrowPlan.planDate).toBe(getLocalPlanDate(1));
    expect(tomorrowPlan.tasks).toHaveLength(0);
    expect(emptyPlan).toEqual({
      planDate: customDate,
      summary: {
        taskCount: 0,
        completedCount: 0,
        pendingCount: 0,
      },
      tasks: [],
      pendingTasks: [],
      completedTasks: [],
    });
    expect(history.every((entry) => entry.planDate === getLocalPlanDate())).toBe(
      true,
    );
    expect(await dailyPlanService.listOverdueTasks()).toEqual([]);
    expect(sectionMeta).toEqual({
      todayPlanDate: getLocalPlanDate(),
      tomorrowPlanDate: getLocalPlanDate(1),
      todayLabel: expect.any(String),
      tomorrowLabel: expect.any(String),
    });
  });

  it("handles mock-mode task mutations", async () => {
    const dailyPlanService = await importWithoutDb<
      typeof import("@/modules/daily-plan/daily-plan.service")
    >("@/modules/daily-plan/daily-plan.service");

    const createdTask = await dailyPlanService.createTask(taskInput);
    expect(createdTask?.status).toBe("PENDING");

    await expect(dailyPlanService.completeTask(createdTask!.id)).resolves.toMatchObject({
      id: createdTask!.id,
      status: "COMPLETED",
      completedAt: "Now",
    });
    await expect(dailyPlanService.completeTask("missing")).resolves.toBeNull();

    await expect(dailyPlanService.reopenTask(createdTask!.id)).resolves.toMatchObject({
      id: createdTask!.id,
      status: "PENDING",
      completedAt: undefined,
    });
    await expect(dailyPlanService.reopenTask("missing")).resolves.toBeNull();

    await expect(dailyPlanService.updateTask(createdTask!.id, {
      ...taskInput,
      title: "Updated SQL practice",
      taskType: "FREEFORM",
      linkedQuestionSlug: "lru-cache",
      linkedQuestionTitle: "How would you implement an O(1) LRU cache?",
    })).resolves.toMatchObject({
      id: createdTask!.id,
      title: "Updated SQL practice",
      taskType: "FREEFORM",
      linkedQuestionSlug: "lru-cache",
    });
    await expect(dailyPlanService.updateTask("missing", taskInput)).resolves.toBeNull();

    const carried = await dailyPlanService.carryOverTask(createdTask!.id);
    expect(carried).toMatchObject({
      sourceTask: {
        id: createdTask!.id,
        status: "CARRIED_OVER",
      },
      nextTask: {
        status: "PENDING",
        title: "Updated SQL practice",
      },
    });
    await expect(dailyPlanService.carryOverTask("missing")).resolves.toBeNull();

    await expect(dailyPlanService.deleteTask(createdTask!.id)).resolves.toMatchObject({
      id: createdTask!.id,
      status: "CARRIED_OVER",
    });
    await expect(dailyPlanService.deleteTask("missing")).resolves.toBeNull();
  });

  it("rejects invalid task category inputs before persisting", async () => {
    const dailyPlanService = await importWithoutDb<
      typeof import("@/modules/daily-plan/daily-plan.service")
    >("@/modules/daily-plan/daily-plan.service");

    await expect(
      dailyPlanService.createTask({
        title: "Practice SQL joins",
        taskType: "CATEGORY_PRACTICE",
        priority: 4,
        categoryName: undefined,
        linkedQuestionSlug: undefined,
        linkedQuestionTitle: undefined,
      }),
    ).rejects.toThrow("Category-practice tasks require a category.");
    await expect(
      dailyPlanService.createTask({
        title: "Review LRU cache",
        taskType: "QUESTION_LINKED",
        priority: 3,
        categoryName: "Algorithms",
        linkedQuestionSlug: undefined,
        linkedQuestionTitle: undefined,
      }),
    ).rejects.toThrow("Question-linked tasks require question details.");
    await expect(
      dailyPlanService.createTask({
        title: "Review LRU cache",
        taskType: "QUESTION_LINKED",
        priority: 3,
        categoryName: undefined,
        linkedQuestionSlug: "lru-cache",
        linkedQuestionTitle: "How would you implement an O(1) LRU cache?",
      }),
    ).rejects.toThrow("Question-linked tasks require a category.");
    await expect(
      dailyPlanService.createTask({
        ...taskInput,
        categoryName: "Missing",
      }),
    ).rejects.toThrow("Category is invalid.");

    restoreModuleMocks();

    const loaded = await importWithDbMock<
      typeof import("@/modules/daily-plan/daily-plan.service")
    >("@/modules/daily-plan/daily-plan.service", [[]]);

    await expect(
      loaded.module.updateTask("task_db", {
        ...taskInput,
        categoryName: "Missing",
      }, "user_demo"),
    ).rejects.toThrow("Category is invalid.");
  });

  it("handles database-mode plan reads and wrappers", async () => {
    const row = {
      id: "task_1",
      title: "Review SQL",
      taskType: "QUESTION_LINKED" as const,
      status: "COMPLETED" as const,
      priority: 3,
      categoryName: "SQL",
      linkedQuestionSlug: "mvcc-explained",
      linkedQuestionTitle: "How do you explain MVCC in practical interview language?",
      completedAt: new Date("2026-04-06T09:20:00Z"),
      planDate: "2026-04-06",
    };
    const expectedCompletedAt = formatTimeInAppTimeZone(row.completedAt);
    let loaded = await importWithDbMock<
      typeof import("@/modules/daily-plan/daily-plan.service")
    >("@/modules/daily-plan/daily-plan.service", [[row]]);

    await expect(
      loaded.module.getDailyPlan("2026-04-06", "user_demo"),
    ).resolves.toEqual({
      planDate: "2026-04-06",
      summary: {
        taskCount: 1,
        completedCount: 1,
        pendingCount: 0,
      },
      tasks: [
        {
          id: "task_1",
          title: "Review SQL",
          taskType: "QUESTION_LINKED",
          status: "COMPLETED",
          priority: 3,
          categoryName: "SQL",
          linkedQuestionSlug: "mvcc-explained",
          linkedQuestionTitle:
            "How do you explain MVCC in practical interview language?",
          completedAt: expectedCompletedAt,
        },
      ],
      pendingTasks: [],
      completedTasks: [
        {
          id: "task_1",
          title: "Review SQL",
          taskType: "QUESTION_LINKED",
          status: "COMPLETED",
          priority: 3,
          categoryName: "SQL",
          linkedQuestionSlug: "mvcc-explained",
          linkedQuestionTitle:
            "How do you explain MVCC in practical interview language?",
          completedAt: expectedCompletedAt,
        },
      ],
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/daily-plan/daily-plan.service")>(
      "@/modules/daily-plan/daily-plan.service",
      [[{ ...row, status: "PENDING", completedAt: null }], []],
    );

    await expect(loaded.module.getTodayPlan("user_demo")).resolves.toMatchObject({
      planDate: getLocalPlanDate(),
      pendingTasks: [
        expect.objectContaining({
          id: "task_1",
          status: "PENDING",
          completedAt: undefined,
        }),
      ],
    });
    await expect(loaded.module.getTomorrowPlan("user_demo")).resolves.toMatchObject({
      tasks: [],
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/daily-plan/daily-plan.service")>(
      "@/modules/daily-plan/daily-plan.service",
      [[{ ...row, status: "PENDING", completedAt: null, planDate: null }], [{ ...row }]],
    );

    await expect(loaded.module.listOverdueTasks("user_demo")).resolves.toEqual([
      {
        id: "task_1",
        title: "Review SQL",
        taskType: "QUESTION_LINKED",
        status: "PENDING",
        priority: 3,
        categoryName: "SQL",
        linkedQuestionSlug: "mvcc-explained",
        linkedQuestionTitle:
          "How do you explain MVCC in practical interview language?",
        completedAt: undefined,
        planDate: getLocalPlanDate(),
      },
    ]);
    await expect(loaded.module.listRecentTaskHistory("user_demo")).resolves.toHaveLength(1);
    await expect(loaded.module.getDailyPlan("2026-04-06")).rejects.toThrow(
      "User context is required.",
    );
  });

  it("handles database-mode task mutations", async () => {
    let loaded = await importWithDbMock<typeof import("@/modules/daily-plan/daily-plan.service")>(
      "@/modules/daily-plan/daily-plan.service",
      [
        [
          {
            categoryId: "cat_sql",
            categoryName: "SQL",
          },
        ],
        [
          {
            id: "task_db",
            title: "Practice SQL joins",
            taskType: "CATEGORY_PRACTICE",
            status: "PENDING",
            priority: 4,
            categoryName: "SQL",
            linkedQuestionSlug: null,
            linkedQuestionTitle: null,
            completedAt: null,
          },
        ],
      ],
    );

    await expect(loaded.module.createTask(taskInput, "user_demo")).resolves.toMatchObject({
      id: "task_db",
      title: "Practice SQL joins",
      status: "PENDING",
    });

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/daily-plan/daily-plan.service")>(
      "@/modules/daily-plan/daily-plan.service",
      [
        [
          {
            categoryId: "cat_sql",
            categoryName: "SQL",
          },
        ],
        [],
        [
          {
            categoryId: "cat_sql",
            categoryName: "SQL",
          },
        ],
      ],
    );
    await expect(loaded.module.createTask(taskInput, "user_demo")).resolves.toBeNull();
    await expect(loaded.module.createTask(taskInput)).rejects.toThrow(
      "User context is required.",
    );

    restoreModuleMocks();

    loaded = await importWithDbMock<typeof import("@/modules/daily-plan/daily-plan.service")>(
      "@/modules/daily-plan/daily-plan.service",
      [
        [
          {
            id: "task_db",
            title: "Review SQL",
            taskType: "QUESTION_LINKED",
            status: "COMPLETED",
            priority: 3,
            categoryName: "SQL",
            linkedQuestionSlug: "mvcc-explained",
            linkedQuestionTitle: "How do you explain MVCC in practical interview language?",
            completedAt: "2026-04-06T09:20:00Z",
          },
        ],
        [],
        [
          {
            id: "task_db",
            title: "Review SQL",
            taskType: "QUESTION_LINKED",
            status: "PENDING",
            priority: 3,
            categoryName: "SQL",
            linkedQuestionSlug: "mvcc-explained",
            linkedQuestionTitle: "How do you explain MVCC in practical interview language?",
            completedAt: null,
          },
        ],
        [],
        [
          {
            categoryId: "cat_ai",
            categoryName: "AI",
          },
        ],
        [
          {
            id: "task_db",
            title: "Updated SQL review",
            taskType: "FREEFORM",
            status: "PENDING",
            priority: 5,
            categoryName: "AI",
            linkedQuestionSlug: null,
            linkedQuestionTitle: null,
            completedAt: null,
          },
        ],
        [
          {
            categoryId: "cat_sql",
            categoryName: "SQL",
          },
        ],
        [],
        [
          {
            id: "task_db",
            title: "Updated SQL review",
            taskType: "FREEFORM",
            status: "CARRIED_OVER",
            priority: 5,
            categoryName: "AI",
            linkedQuestionSlug: null,
            linkedQuestionTitle: null,
            completedAt: null,
          },
        ],
        [
          {
            id: "task_next",
            title: "Updated SQL review",
            taskType: "FREEFORM",
            status: "PENDING",
            priority: 5,
            categoryName: "AI",
            linkedQuestionSlug: null,
            linkedQuestionTitle: null,
            completedAt: null,
          },
        ],
        [],
        [
          {
            id: "task_db",
            title: "Updated SQL review",
            taskType: "FREEFORM",
            status: "CARRIED_OVER",
            priority: 5,
            categoryName: "AI",
            linkedQuestionSlug: null,
            linkedQuestionTitle: null,
            completedAt: null,
          },
        ],
        [],
      ],
    );
    const expectedCompletedAt = formatTimeInAppTimeZone("2026-04-06T09:20:00Z");

    await expect(loaded.module.completeTask("task_db", "user_demo")).resolves.toMatchObject({
      id: "task_db",
      status: "COMPLETED",
      completedAt: expectedCompletedAt,
    });
    await expect(loaded.module.completeTask("missing", "user_demo")).resolves.toBeNull();

    await expect(loaded.module.reopenTask("task_db", "user_demo")).resolves.toMatchObject({
      id: "task_db",
      status: "PENDING",
    });
    await expect(loaded.module.reopenTask("missing", "user_demo")).resolves.toBeNull();

    await expect(
      loaded.module.updateTask("task_db", {
        title: "Updated SQL review",
        taskType: "FREEFORM",
        priority: 5,
        categoryName: "AI",
        linkedQuestionSlug: undefined,
        linkedQuestionTitle: undefined,
      }, "user_demo"),
    ).resolves.toMatchObject({
      id: "task_db",
      title: "Updated SQL review",
      taskType: "FREEFORM",
      priority: 5,
      categoryName: "AI",
    });
    await expect(loaded.module.updateTask("missing", taskInput, "user_demo")).resolves.toBeNull();

    await expect(loaded.module.carryOverTask("task_db", "user_demo")).resolves.toMatchObject({
      sourceTask: expect.objectContaining({
        id: "task_db",
        status: "CARRIED_OVER",
      }),
      nextTask: expect.objectContaining({
        id: "task_next",
        status: "PENDING",
      }),
    });
    await expect(loaded.module.carryOverTask("missing", "user_demo")).resolves.toBeNull();

    await expect(loaded.module.deleteTask("task_db", "user_demo")).resolves.toMatchObject({
      id: "task_db",
      status: "CARRIED_OVER",
    });
    await expect(loaded.module.deleteTask("missing", "user_demo")).resolves.toBeNull();
  });

  it("stores null optional task fields in database mode", async () => {
    const loaded = await importWithDbMock<
      typeof import("@/modules/daily-plan/daily-plan.service")
    >("@/modules/daily-plan/daily-plan.service", [
      [
        {
          id: "task_optional",
          title: "Freeform review",
          taskType: "FREEFORM",
          status: "PENDING",
          priority: 2,
          categoryName: null,
          linkedQuestionSlug: null,
          linkedQuestionTitle: null,
          completedAt: null,
        },
      ],
      [
        {
          id: "task_optional",
          title: "Updated freeform review",
          taskType: "FREEFORM",
          status: "PENDING",
          priority: 1,
          categoryName: null,
          linkedQuestionSlug: null,
          linkedQuestionTitle: null,
          completedAt: null,
        },
      ],
    ]);

    await expect(
      loaded.module.createTask(
        {
          title: "Freeform review",
          taskType: "FREEFORM",
          priority: 2,
          categoryName: undefined,
          linkedQuestionSlug: undefined,
          linkedQuestionTitle: undefined,
        },
        "user_demo",
      ),
    ).resolves.toEqual({
      id: "task_optional",
      title: "Freeform review",
      taskType: "FREEFORM",
      status: "PENDING",
      priority: 2,
      categoryName: undefined,
      linkedQuestionSlug: undefined,
      linkedQuestionTitle: undefined,
      completedAt: undefined,
    });
    await expect(
      loaded.module.updateTask(
        "task_optional",
        {
          title: "Updated freeform review",
          taskType: "FREEFORM",
          priority: 1,
          categoryName: undefined,
          linkedQuestionSlug: undefined,
          linkedQuestionTitle: undefined,
        },
        "user_demo",
      ),
    ).resolves.toEqual({
      id: "task_optional",
      title: "Updated freeform review",
      taskType: "FREEFORM",
      status: "PENDING",
      priority: 1,
      categoryName: undefined,
      linkedQuestionSlug: undefined,
      linkedQuestionTitle: undefined,
      completedAt: undefined,
    });
  });

  it("returns a null next task when carry-over insertion does not produce a row", async () => {
    const loaded = await importWithDbMock<typeof import("@/modules/daily-plan/daily-plan.service")>(
      "@/modules/daily-plan/daily-plan.service",
      [
        [
          {
            id: "task_db",
            title: "Carry over me",
            taskType: "FREEFORM",
            status: "CARRIED_OVER",
            priority: 2,
            categoryName: null,
            linkedQuestionSlug: null,
            linkedQuestionTitle: null,
            completedAt: null,
          },
        ],
        [],
      ],
    );

    await expect(loaded.module.carryOverTask("task_db", "user_demo")).resolves.toEqual({
      sourceTask: {
        id: "task_db",
        title: "Carry over me",
        taskType: "FREEFORM",
        status: "CARRIED_OVER",
        priority: 2,
        categoryName: undefined,
        linkedQuestionSlug: undefined,
        linkedQuestionTitle: undefined,
        completedAt: undefined,
      },
      nextTask: null,
    });
  });

  it("returns null when a mock delete loses the removed task payload", async () => {
    const dailyPlanService = await importWithoutDb<
      typeof import("@/modules/daily-plan/daily-plan.service")
    >("@/modules/daily-plan/daily-plan.service");
    const mockData = await import("@/lib/mock-data");
    const existingTaskId = mockData.todayTasks[0]!.id;
    const originalSplice = mockData.todayTasks.splice;

    Object.defineProperty(mockData.todayTasks, "splice", {
      configurable: true,
      value: () => [undefined],
    });

    try {
      await expect(dailyPlanService.deleteTask(existingTaskId)).resolves.toBeNull();
    } finally {
      Object.defineProperty(mockData.todayTasks, "splice", {
        configurable: true,
        value: originalSplice,
      });
    }
  });
});
