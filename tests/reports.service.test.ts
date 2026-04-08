import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import {
  backlogItems,
  categoryProgress,
  dailyTrend,
  reportSummary,
} from "@/lib/mock-data";
import { getCurrentDateInAppTimeZone } from "@/lib/time";

import {
  importWithDbMock,
  importWithoutDb,
  restoreModuleMocks,
} from "@/tests/test-utils";

function toDateOnly(offsetDays: number) {
  return getCurrentDateInAppTimeZone(offsetDays);
}

describe("reports.service", () => {
  beforeEach(() => {
    vi.useFakeTimers();
    vi.stubEnv("APP_TIME_ZONE", "Asia/Tokyo");
    vi.setSystemTime(new Date("2026-04-06T15:30:00Z"));
  });

  afterEach(() => {
    restoreModuleMocks();
    vi.useRealTimers();
  });

  it("handles mock-mode reports and default filter normalization", async () => {
    const reportsService = await importWithoutDb<
      typeof import("@/modules/reports/reports.service")
    >("@/modules/reports/reports.service");

    await expect(reportsService.getOverviewReport()).resolves.toEqual({
      tasksCompletedInRange: reportSummary.tasksCompletedInRange,
      reviewedQuestions: 2,
      masteredQuestions: 1,
      currentStreak: reportSummary.currentStreak,
    });
    await expect(
      reportsService.getOverviewReport(undefined, {
        categoryId: "cat_ai",
      }),
    ).resolves.toEqual({
      tasksCompletedInRange: reportSummary.tasksCompletedInRange,
      reviewedQuestions: 1,
      masteredQuestions: 1,
      currentStreak: reportSummary.currentStreak,
    });
    await expect(
      reportsService.getDailyTrendReport(undefined, {
        rangeDays: 3,
      }),
    ).resolves.toEqual(dailyTrend.slice(-3));
    await expect(
      reportsService.getDailyTrendReport(undefined, {
        rangeDays: 0,
      }),
    ).resolves.toEqual(dailyTrend);
    await expect(
      reportsService.getDailyTrendReport(undefined, {
        rangeDays: 99,
      }),
    ).resolves.toEqual(dailyTrend);
    await expect(
      reportsService.getCategoryProgressReport(undefined, {
        categoryName: "AI",
      }),
    ).resolves.toEqual(categoryProgress.filter((entry) => entry.categoryName === "AI"));
    await expect(reportsService.getCategoryProgressReport()).resolves.toEqual(
      categoryProgress,
    );
    await expect(
      reportsService.getBacklogReport(undefined, {
        categoryName: "AI",
      }),
    ).resolves.toEqual(
      backlogItems.filter(
        (item) => item.title.includes("AI") || item.detail.includes("AI"),
      ),
    );
    await expect(reportsService.getBacklogReport()).resolves.toEqual(backlogItems);
  });

  it("handles database-mode overview reports", async () => {
    const reportsService = await importWithDbMock<
      typeof import("@/modules/reports/reports.service")
    >("@/modules/reports/reports.service", [
      [{ tasksCompletedInRange: 4 }],
      [{ reviewedQuestions: 3, masteredQuestions: 1 }],
      [
        { completedDate: toDateOnly(0) },
        { completedDate: toDateOnly(-1) },
      ],
    ]);

    await expect(
      reportsService.module.getOverviewReport("user_demo", {
        rangeDays: 14,
        categoryId: "cat_ai",
        categoryName: "AI",
      }),
    ).resolves.toEqual({
      tasksCompletedInRange: 4,
      reviewedQuestions: 3,
      masteredQuestions: 1,
      currentStreak: 2,
    });
    await expect(reportsService.module.getOverviewReport()).rejects.toThrow(
      "User context is required.",
    );
  });

  it("handles database-mode daily trends", async () => {
    const reportsService = await importWithDbMock<
      typeof import("@/modules/reports/reports.service")
    >("@/modules/reports/reports.service", [
      [
        { label: " Mon ", value: 1 },
        { label: " Tue ", value: 3 },
      ],
    ]);

    await expect(
      reportsService.module.getDailyTrendReport("user_demo", {
        rangeDays: 10,
        categoryId: "cat_ai",
        categoryName: "AI",
      }),
    ).resolves.toEqual([
      { label: "Mon", value: 1 },
      { label: "Tue", value: 3 },
    ]);
  });

  it("handles database-mode overview defaults and short-range trends", async () => {
    let reportsService = await importWithDbMock<
      typeof import("@/modules/reports/reports.service")
    >("@/modules/reports/reports.service", [[], [], []]);

    await expect(reportsService.module.getOverviewReport("user_demo")).resolves.toEqual({
      tasksCompletedInRange: 0,
      reviewedQuestions: 0,
      masteredQuestions: 0,
      currentStreak: 0,
    });

    restoreModuleMocks();

    reportsService = await importWithDbMock<
      typeof import("@/modules/reports/reports.service")
    >("@/modules/reports/reports.service", [
      [{ label: " Wed ", value: 2 }],
    ]);

    await expect(
      reportsService.module.getDailyTrendReport("user_demo", {
        rangeDays: 7,
      }),
    ).resolves.toEqual([{ label: "Wed", value: 2 }]);
  });

  it("handles database-mode category progress and backlog reports", async () => {
    const reportsService = await importWithDbMock<
      typeof import("@/modules/reports/reports.service")
    >("@/modules/reports/reports.service", [
      [{ categoryName: "AI", reviewedCount: 2, totalCount: 5 }],
      [
        { id: "task_1", title: "Overdue task", detail: "Planned for 2026-04-01" },
        { id: "task_2", title: "Another overdue task", detail: "Planned for 2026-04-02" },
      ],
      [
        {
          id: "cat_ai",
          title: "AI has low coverage",
          detail: "2 of 5 questions marked reviewed or mastered",
        },
      ],
      [{ categoryName: "System Design", reviewedCount: 1, totalCount: 4 }],
      [{ id: "task_3", title: "Unfiltered overdue task", detail: "Planned for 2026-04-03" }],
      [
        {
          id: "cat_system",
          title: "System Design has low coverage",
          detail: "1 of 4 questions marked reviewed or mastered",
        },
      ],
    ]);

    await expect(
      reportsService.module.getCategoryProgressReport("user_demo", {
        categoryId: "cat_ai",
      }),
    ).resolves.toEqual([{ categoryName: "AI", reviewedCount: 2, totalCount: 5 }]);
    await expect(
      reportsService.module.getBacklogReport("user_demo", {
        categoryId: "cat_ai",
        categoryName: "AI",
      }),
    ).resolves.toEqual([
      { id: "task_1", title: "Overdue task", detail: "Planned for 2026-04-01" },
      {
        id: "task_2",
        title: "Another overdue task",
        detail: "Planned for 2026-04-02",
      },
      {
        id: "cat_ai",
        title: "AI has low coverage",
        detail: "2 of 5 questions marked reviewed or mastered",
      },
    ]);
    await expect(
      reportsService.module.getCategoryProgressReport("user_demo"),
    ).resolves.toEqual([
      { categoryName: "System Design", reviewedCount: 1, totalCount: 4 },
    ]);
    await expect(reportsService.module.getBacklogReport("user_demo")).resolves.toEqual([
      {
        id: "task_3",
        title: "Unfiltered overdue task",
        detail: "Planned for 2026-04-03",
      },
      {
        id: "cat_system",
        title: "System Design has low coverage",
        detail: "1 of 4 questions marked reviewed or mastered",
      },
    ]);
  });
});
