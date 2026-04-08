import type { ProgressStatus } from "@/types/domain";

const validProgressStatuses: ProgressStatus[] = [
  "NOT_STARTED",
  "PLANNED",
  "IN_PROGRESS",
  "REVIEWED",
  "MASTERED",
];

export function parseProgressStatusInput(value: unknown): ProgressStatus {
  if (
    typeof value !== "string" ||
    !validProgressStatuses.includes(value as ProgressStatus)
  ) {
    throw new Error("Progress status is invalid.");
  }

  return value as ProgressStatus;
}
