import { afterEach, describe, expect, it, vi } from "vitest";

import {
  calculateCurrentStreak,
  normalizeDateOnly,
} from "@/modules/reports/reports.helpers";

describe("calculateCurrentStreak", () => {
  afterEach(() => {
    vi.useRealTimers();
    vi.unstubAllEnvs();
  });

  it("counts consecutive days back from today", () => {
    vi.useFakeTimers();
    vi.stubEnv("APP_TIME_ZONE", "Asia/Tokyo");
    vi.setSystemTime(new Date("2026-04-06T15:30:00Z"));

    expect(
      calculateCurrentStreak([
        "2026-04-07",
        "2026-04-06",
        "2026-04-05",
        "2026-04-03",
      ]),
    ).toBe(3);
  });

  it("returns zero when today is missing", () => {
    vi.useFakeTimers();
    vi.stubEnv("APP_TIME_ZONE", "Asia/Tokyo");
    vi.setSystemTime(new Date("2026-04-06T15:30:00Z"));

    expect(calculateCurrentStreak(["2026-04-06", "2026-04-05"])).toBe(0);
  });

  it("keeps string dates unchanged", () => {
    expect(normalizeDateOnly("2026-04-06")).toBe("2026-04-06");
  });

  it("converts Date inputs to local date strings", () => {
    vi.stubEnv("APP_TIME_ZONE", "Asia/Tokyo");

    expect(normalizeDateOnly(new Date("2026-04-06T18:30:00Z"))).toBe("2026-04-07");
  });
});
