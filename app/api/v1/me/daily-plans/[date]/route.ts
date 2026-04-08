import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { getDailyPlan } from "@/modules/daily-plan/daily-plan.service";

interface DailyPlanRouteProps {
  params: Promise<{
    date: string;
  }>;
}

export async function GET(_: Request, { params }: DailyPlanRouteProps) {
  const session = await getSession();

  if (!session) {
    return NextResponse.json(
      {
        error: {
          code: "UNAUTHORIZED",
          message: "Login is required.",
        },
      },
      { status: 401 },
    );
  }

  const { date } = await params;

  try {
    const plan = await getDailyPlan(date, session.user.id);

    return NextResponse.json({
      data: plan,
    });
  } catch (error) {
    return NextResponse.json(
      {
        error: {
          code: "VALIDATION_ERROR",
          message:
            error instanceof Error ? error.message : "Plan lookup failed.",
        },
      },
      { status: 400 },
    );
  }
}
