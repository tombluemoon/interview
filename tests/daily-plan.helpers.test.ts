import { describe, expect, it } from "vitest";

import {
  buildTodaySummary,
  filterVisibleTodayTasks,
  isVisibleTodayTaskStatus,
} from "@/modules/daily-plan/daily-plan.helpers";

describe("daily plan helpers", () => {
  it("shows only pending and completed tasks in the today view", () => {
    expect(isVisibleTodayTaskStatus("PENDING")).toBe(true);
    expect(isVisibleTodayTaskStatus("COMPLETED")).toBe(true);
    expect(isVisibleTodayTaskStatus("CARRIED_OVER")).toBe(false);
    expect(isVisibleTodayTaskStatus("SKIPPED")).toBe(false);
  });

  it("filters non-visible statuses out of today tasks", () => {
    expect(
      filterVisibleTodayTasks([
        { id: "task_1", status: "PENDING" as const },
        { id: "task_2", status: "COMPLETED" as const },
        { id: "task_3", status: "CARRIED_OVER" as const },
      ]),
    ).toEqual([
      { id: "task_1", status: "PENDING" },
      { id: "task_2", status: "COMPLETED" },
    ]);
  });

  it("builds the summary from only visible tasks", () => {
    expect(
      buildTodaySummary([
        { status: "PENDING" as const },
        { status: "PENDING" as const },
        { status: "COMPLETED" as const },
        { status: "CARRIED_OVER" as const },
      ]),
    ).toEqual({
      taskCount: 3,
      completedCount: 1,
      pendingCount: 2,
    });
  });
});
