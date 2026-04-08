export function slugifyText(value: string) {
  return value
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/\s+/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "");
}

export function parseCommaSeparatedList(value: unknown) {
  if (Array.isArray(value)) {
    return Array.from(
      new Set(
        value
          .filter((entry): entry is string => typeof entry === "string")
          .map((entry) => entry.trim())
          .filter(Boolean),
      ),
    );
  }

  if (typeof value !== "string") {
    return [];
  }

  return Array.from(
    new Set(
      value
        .split(",")
        .map((entry) => entry.trim())
        .filter(Boolean),
    ),
  );
}

export function buildQuestionExcerpt(excerpt: string, body: string) {
  const trimmedExcerpt = excerpt.trim();

  if (trimmedExcerpt.length > 0) {
    return trimmedExcerpt;
  }

  const normalizedBody = body.replace(/\s+/g, " ").trim();

  if (normalizedBody.length <= 160) {
    return normalizedBody;
  }

  return `${normalizedBody.slice(0, 157).trimEnd()}...`;
}

export function joinCommaSeparatedList(values: string[]) {
  return values.join(", ");
}
