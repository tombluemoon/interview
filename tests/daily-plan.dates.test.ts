import { afterEach, describe, expect, it, vi } from "vitest";

import {
  formatPlanDateLabel,
  getLocalPlanDate,
  parsePlanDateInput,
} from "@/modules/daily-plan/daily-plan.dates";

describe("daily plan dates", () => {
  afterEach(() => {
    vi.useRealTimers();
    vi.unstubAllEnvs();
  });

  it("builds plan dates from the configured app timezone", () => {
    vi.useFakeTimers();
    vi.stubEnv("APP_TIME_ZONE", "Asia/Tokyo");
    vi.setSystemTime(new Date("2026-04-06T15:30:00Z"));

    expect(getLocalPlanDate()).toBe("2026-04-07");
    expect(getLocalPlanDate(1)).toBe("2026-04-08");
  });

  it("validates plan date input", () => {
    expect(parsePlanDateInput("2026-04-07")).toBe("2026-04-07");
    expect(() => parsePlanDateInput("2026/04/07")).toThrow(
      "Plan date must use YYYY-MM-DD format.",
    );
    expect(() => parsePlanDateInput("2026-02-30")).toThrow(
      "Plan date is invalid.",
    );
  });

  it("formats plan dates for display", () => {
    expect(formatPlanDateLabel("2026-04-07")).toBe("Tue, Apr 7");
  });
});
