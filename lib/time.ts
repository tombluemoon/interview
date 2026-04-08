const DEFAULT_APP_TIME_ZONE = "Asia/Tokyo";

function pad(value: number) {
  return String(value).padStart(2, "0");
}

export function getAppTimeZone() {
  const configuredTimeZone = process.env.APP_TIME_ZONE?.trim();

  if (!configuredTimeZone) {
    return DEFAULT_APP_TIME_ZONE;
  }

  try {
    new Intl.DateTimeFormat("en-US", {
      timeZone: configuredTimeZone,
    }).format(new Date());

    return configuredTimeZone;
  } catch {
    return DEFAULT_APP_TIME_ZONE;
  }
}

export function toDateOnlyInAppTimeZone(date: Date) {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat("en-US", {
      timeZone: getAppTimeZone(),
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
    })
      .formatToParts(date)
      .filter((part) => part.type !== "literal")
      .map((part) => [part.type, part.value]),
  ) as Record<"year" | "month" | "day", string>;

  return `${parts.year}-${parts.month}-${parts.day}`;
}

export function shiftDateOnly(dateOnly: string, offsetDays = 0) {
  const [year, month, day] = dateOnly.split("-").map(Number);
  const shiftedDate = new Date(Date.UTC(year, month - 1, day + offsetDays, 12));

  return `${shiftedDate.getUTCFullYear()}-${pad(
    shiftedDate.getUTCMonth() + 1,
  )}-${pad(shiftedDate.getUTCDate())}`;
}

export function getCurrentDateInAppTimeZone(
  offsetDays = 0,
  referenceDate = new Date(),
) {
  return shiftDateOnly(toDateOnlyInAppTimeZone(referenceDate), offsetDays);
}

export function formatDateOnlyForDisplay(
  dateOnly: string,
  locale = "en-US",
) {
  const [year, month, day] = dateOnly.split("-").map(Number);
  const date = new Date(Date.UTC(year, month - 1, day, 12));

  return new Intl.DateTimeFormat(locale, {
    timeZone: "UTC",
    month: "short",
    day: "numeric",
    weekday: "short",
  }).format(date);
}

export function formatTimeInAppTimeZone(value: string | Date) {
  const date = value instanceof Date ? value : new Date(value);

  return new Intl.DateTimeFormat("en-GB", {
    timeZone: getAppTimeZone(),
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  }).format(date);
}
