import {
  formatDateOnlyForDisplay,
  getCurrentDateInAppTimeZone,
} from "@/lib/time";

const PLAN_DATE_PATTERN = /^\d{4}-\d{2}-\d{2}$/;

export function getLocalPlanDate(offsetDays = 0) {
  return getCurrentDateInAppTimeZone(offsetDays);
}

export function parsePlanDateInput(value: string) {
  const trimmed = value.trim();

  if (!PLAN_DATE_PATTERN.test(trimmed)) {
    throw new Error("Plan date must use YYYY-MM-DD format.");
  }

  const [year, month, day] = trimmed.split("-").map(Number);
  const date = new Date(year, month - 1, day);

  if (
    Number.isNaN(date.getTime()) ||
    date.getFullYear() !== year ||
    date.getMonth() !== month - 1 ||
    date.getDate() !== day
  ) {
    throw new Error("Plan date is invalid.");
  }

  return trimmed;
}

export function formatPlanDateLabel(planDate: string) {
  const parsed = parsePlanDateInput(planDate);

  return formatDateOnlyForDisplay(parsed);
}
