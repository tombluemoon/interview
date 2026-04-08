import { describe, expect, it } from "vitest";

import {
  getReportRangeLabel,
  getReportSummaryLabel,
  parseReportFilters,
  parseReportRange,
} from "@/modules/reports/reports.validation";

describe("reports.validation", () => {
  it("defaults to the 7 day window when the range is missing or invalid", () => {
    expect(parseReportRange(undefined)).toBe("7d");
    expect(parseReportRange("bad")).toBe("7d");
  });

  it("keeps only valid filters", () => {
    expect(
      parseReportFilters(
        {
          range: "30d",
          category: "cat_ai",
        },
        ["cat_ai", "cat_sql"],
      ),
    ).toEqual({
      range: "30d",
      rangeDays: 30,
      categoryId: "cat_ai",
    });
  });

  it("drops invalid categories while keeping the default range", () => {
    expect(
      parseReportFilters(
        {
          range: "bad",
          category: "cat_java",
        },
        ["cat_ai", "cat_sql"],
      ),
    ).toEqual({
      range: "7d",
      rangeDays: 7,
      categoryId: undefined,
    });
  });

  it("returns stable page labels", () => {
    expect(getReportRangeLabel("14d")).toBe("Last 14 days");
    expect(getReportSummaryLabel("30d")).toBe("Tasks Last 30 Days");
  });
});
