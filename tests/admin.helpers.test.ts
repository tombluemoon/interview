import { describe, expect, it } from "vitest";

import {
  buildQuestionExcerpt,
  joinCommaSeparatedList,
  parseCommaSeparatedList,
  slugifyText,
} from "@/modules/admin/admin.helpers";

describe("admin.helpers", () => {
  it("slugifies free-form titles", () => {
    expect(slugifyText("  Design a Rate Limiter (Token Bucket)  ")).toBe(
      "design-a-rate-limiter-token-bucket",
    );
  });

  it("normalizes comma-separated values", () => {
    expect(parseCommaSeparatedList("rag, retrieval, rag, ai ")).toEqual([
      "rag",
      "retrieval",
      "ai",
    ]);
    expect(parseCommaSeparatedList(["rag", " ai ", "", 42, "rag"])).toEqual([
      "rag",
      "ai",
    ]);
    expect(parseCommaSeparatedList(undefined)).toEqual([]);
    expect(joinCommaSeparatedList(["rag", "retrieval"])).toBe("rag, retrieval");
  });

  it("derives an excerpt from explicit text or the body when needed", () => {
    expect(
      buildQuestionExcerpt(
        "  Short manual excerpt.  ",
        "This body should not be used.",
      ),
    ).toBe("Short manual excerpt.");
    expect(
      buildQuestionExcerpt(
        "",
        "Design a service that keeps retrieval and generation grounded with clear citations.",
      ),
    ).toBe(
      "Design a service that keeps retrieval and generation grounded with clear citations.",
    );
    expect(
      buildQuestionExcerpt(
        "",
        "A".repeat(170),
      ),
    ).toBe(`${"A".repeat(157)}...`);
  });
});
