import { NextResponse } from "next/server";

import { getSql, isDatabaseConfigured } from "@/lib/db";
import { getAppTimeZone } from "@/lib/time";

export async function GET() {
  const databaseConfigured = isDatabaseConfigured();
  let databaseReachable = false;

  if (databaseConfigured) {
    try {
      const sql = getSql();
      await sql`SELECT 1`;
      databaseReachable = true;
    } catch {
      return NextResponse.json(
        {
          status: "degraded",
          database: {
            configured: true,
            reachable: false,
          },
          appTimeZone: getAppTimeZone(),
        },
        { status: 503 },
      );
    }
  }

  return NextResponse.json({
    status: "ok",
    database: {
      configured: databaseConfigured,
      reachable: databaseReachable,
    },
    appTimeZone: getAppTimeZone(),
  });
}
