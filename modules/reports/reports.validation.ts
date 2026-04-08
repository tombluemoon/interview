const reportRangeConfig = {
  "7d": {
    days: 7,
    label: "Last 7 days",
    summaryLabel: "Tasks Last 7 Days",
  },
  "14d": {
    days: 14,
    label: "Last 14 days",
    summaryLabel: "Tasks Last 14 Days",
  },
  "30d": {
    days: 30,
    label: "Last 30 days",
    summaryLabel: "Tasks Last 30 Days",
  },
} as const;

export type ReportRange = keyof typeof reportRangeConfig;

export const reportRangeOptions = Object.entries(reportRangeConfig).map(
  ([value, config]) => ({
    value: value as ReportRange,
    label: config.label,
    days: config.days,
  }),
);

export function parseReportRange(value: unknown): ReportRange {
  if (
    typeof value !== "string" ||
    !(value in reportRangeConfig)
  ) {
    return "7d";
  }

  return value as ReportRange;
}

export function parseReportFilters(
  input: {
    range?: unknown;
    category?: unknown;
  },
  validCategoryIds: string[],
) {
  const range = parseReportRange(input.range);
  const categoryId =
    typeof input.category === "string" &&
    validCategoryIds.includes(input.category)
      ? input.category
      : undefined;

  return {
    range,
    rangeDays: reportRangeConfig[range].days,
    categoryId,
  };
}

export function getReportRangeLabel(range: ReportRange) {
  return reportRangeConfig[range].label;
}

export function getReportSummaryLabel(range: ReportRange) {
  return reportRangeConfig[range].summaryLabel;
}
