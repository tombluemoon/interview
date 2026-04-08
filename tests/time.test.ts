import { afterEach, describe, expect, it, vi } from "vitest";

import {
  formatDateOnlyForDisplay,
  formatTimeInAppTimeZone,
  getAppTimeZone,
  getCurrentDateInAppTimeZone,
  shiftDateOnly,
  toDateOnlyInAppTimeZone,
} from "@/lib/time";

describe("lib/time", () => {
  afterEach(() => {
    vi.useRealTimers();
    vi.unstubAllEnvs();
  });

  it("uses the default timezone when APP_TIME_ZONE is missing", () => {
    expect(getAppTimeZone()).toBe("Asia/Tokyo");
  });

  it("uses APP_TIME_ZONE when it is valid", () => {
    vi.stubEnv("APP_TIME_ZONE", "UTC");

    expect(getAppTimeZone()).toBe("UTC");
  });

  it("falls back to the default timezone when APP_TIME_ZONE is invalid", () => {
    vi.stubEnv("APP_TIME_ZONE", "Mars/Olympus");

    expect(getAppTimeZone()).toBe("Asia/Tokyo");
  });

  it("derives and shifts date-only values in the app timezone", () => {
    vi.useFakeTimers();
    vi.stubEnv("APP_TIME_ZONE", "Asia/Tokyo");
    vi.setSystemTime(new Date("2026-04-06T15:30:00Z"));

    expect(toDateOnlyInAppTimeZone(new Date("2026-04-06T15:30:00Z"))).toBe(
      "2026-04-07",
    );
    expect(getCurrentDateInAppTimeZone()).toBe("2026-04-07");
    expect(getCurrentDateInAppTimeZone(-2)).toBe("2026-04-05");
    expect(shiftDateOnly("2026-04-07", 3)).toBe("2026-04-10");
  });

  it("formats date-only labels and times consistently", () => {
    vi.stubEnv("APP_TIME_ZONE", "Asia/Tokyo");

    expect(formatDateOnlyForDisplay("2026-04-07")).toBe("Tue, Apr 7");
    expect(formatTimeInAppTimeZone("2026-04-06T09:20:00Z")).toBe("18:20");
  });
});
