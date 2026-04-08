import { describe, expect, it } from "vitest";

import { setupIntegrationDatabase } from "@/tests/integration/test-harness";

setupIntegrationDatabase();

describe("integration services: category and report consistency", () => {
  it("keeps task display and category-scoped reports stable after a rename", async () => {
    const adminService = await import("@/modules/admin/admin.service");
    const dailyPlanService = await import("@/modules/daily-plan/daily-plan.service");
    const profileService = await import("@/modules/profile/profile.service");
    const reportsService = await import("@/modules/reports/reports.service");

    await expect(
      adminService.updateAdminCategory("cat_ai", {
        name: "Applied AI",
        slug: "applied-ai",
        description: "Updated AI interview practice track.",
      }),
    ).resolves.toMatchObject({
      id: "cat_ai",
      name: "Applied AI",
      slug: "applied-ai",
    });

    const createdTask = await dailyPlanService.createTask(
      {
        title: "Review one applied AI architecture answer",
        taskType: "CATEGORY_PRACTICE",
        priority: 4,
        categoryName: "Applied AI",
      },
      "user_demo",
    );

    expect(createdTask).toMatchObject({
      status: "PENDING",
      categoryName: "Applied AI",
    });

    const todayPlan = await dailyPlanService.getTodayPlan("user_demo");
    expect(
      todayPlan.tasks.find((task) => task.id === "task_ai_today_01"),
    ).toMatchObject({
      categoryName: "Applied AI",
    });
    expect(
      todayPlan.tasks.find((task) => task.id === createdTask?.id),
    ).toMatchObject({
      categoryName: "Applied AI",
    });

    await expect(profileService.getProfile("user_demo")).resolves.toMatchObject({
      preferredTracks: expect.arrayContaining(["Applied AI"]),
    });
    await expect(profileService.getProfile("user_demo")).resolves.not.toMatchObject({
      preferredTracks: expect.arrayContaining(["AI"]),
    });

    const backlog = await reportsService.getBacklogReport("user_demo", {
      categoryId: "cat_ai",
      categoryName: "Applied AI",
    });

    expect(backlog).toHaveLength(2);
    expect(backlog[0]).toMatchObject({
      id: "task_overdue_01",
      title: "Catch up on AI backlog",
    });
    expect(backlog[0]?.detail).toMatch(/^Planned for \d{4}-\d{2}-\d{2}$/);
    expect(backlog[1]).toEqual({
      id: "cat_ai",
      title: "Applied AI has low coverage",
      detail: "1 of 3 questions marked reviewed or mastered",
    });
  });
});
