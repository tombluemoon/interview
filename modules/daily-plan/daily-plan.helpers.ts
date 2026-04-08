import type { TaskStatus } from "@/types/domain";

export function isVisibleTodayTaskStatus(status: TaskStatus) {
  return status === "PENDING" || status === "COMPLETED";
}

export function filterVisibleTodayTasks<T extends { status: TaskStatus }>(
  tasks: T[],
) {
  return tasks.filter((task) => isVisibleTodayTaskStatus(task.status));
}

export function buildTodaySummary(tasks: Array<{ status: TaskStatus }>) {
  const visibleTasks = filterVisibleTodayTasks(tasks);
  const completedCount = visibleTasks.filter(
    (task) => task.status === "COMPLETED",
  ).length;
  const pendingCount = visibleTasks.filter(
    (task) => task.status === "PENDING",
  ).length;

  return {
    taskCount: visibleTasks.length,
    completedCount,
    pendingCount,
  };
}
