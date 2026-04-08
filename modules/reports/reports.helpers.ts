import {
  getCurrentDateInAppTimeZone,
  shiftDateOnly,
  toDateOnlyInAppTimeZone,
} from "@/lib/time";

export function normalizeDateOnly(value: string | Date) {
  return value instanceof Date ? toDateOnlyInAppTimeZone(value) : value;
}

export function calculateCurrentStreak(planDates: Array<string | Date>) {
  const completedDays = new Set(planDates.map(normalizeDateOnly));
  let streak = 0;
  let currentDate = getCurrentDateInAppTimeZone();

  while (true) {
    if (!completedDays.has(currentDate)) {
      break;
    }

    streak += 1;
    currentDate = shiftDateOnly(currentDate, -1);
  }

  return streak;
}
