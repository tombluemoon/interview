import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { completeTask } from "@/modules/daily-plan/daily-plan.service";

interface CompleteTaskRouteProps {
  params: Promise<{
    taskId: string;
  }>;
}

export async function POST(_: Request, { params }: CompleteTaskRouteProps) {
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
  const task = await completeTask(taskId, session.user.id);

  if (!task) {
    return NextResponse.json(
      {
        error: {
          code: "NOT_FOUND",
          message: "Task not found.",
        },
      },
      { status: 404 },
    );
  }

  return NextResponse.json({
    data: task,
  });
}
