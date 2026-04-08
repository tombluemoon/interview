import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { carryOverTask } from "@/modules/daily-plan/daily-plan.service";

interface CarryOverTaskRouteProps {
  params: Promise<{
    taskId: string;
  }>;
}

export async function POST(_: Request, { params }: CarryOverTaskRouteProps) {
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

  const { taskId } = await params;
  const result = await carryOverTask(taskId, session.user.id);

  if (!result) {
    return NextResponse.json(
      {
        error: {
          code: "NOT_FOUND",
          message: "Task not found or cannot be carried over.",
        },
      },
      { status: 404 },
    );
  }

  return NextResponse.json({
    data: result,
  });
}
