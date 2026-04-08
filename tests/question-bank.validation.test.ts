import { describe, expect, it } from "vitest";

import { parseProgressStatusInput } from "@/modules/question-bank/question-bank.validation";

describe("parseProgressStatusInput", () => {
  it("accepts a valid progress status", () => {
    expect(parseProgressStatusInput("REVIEWED")).toBe("REVIEWED");
  });

  it("rejects an invalid progress status", () => {
    expect(() => parseProgressStatusInput("DONE")).toThrow(
      "Progress status is invalid.",
    );
  });
});
