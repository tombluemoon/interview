import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { listCategories } from "@/modules/question-bank/question-bank.service";
import {
  deleteTask,
  updateTask,
} from "@/modules/daily-plan/daily-plan.service";
import { parseCreateTaskInput } from "@/modules/daily-plan/daily-plan.validation";

interface TaskRouteProps {
  params: Promise<{
    taskId: string;
  }>;
}

export async function PUT(request: Request, { params }: TaskRouteProps) {
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

  try {
    const body = await request.json();
    const categories = await listCategories();
    const input = parseCreateTaskInput({
      title: body.title,
      taskType: body.task_type ?? body.taskType,
      priority: body.priority,
      categoryName: body.category_name ?? body.categoryName,
      linkedQuestionSlug: body.linked_question_slug ?? body.linkedQuestionSlug,
      linkedQuestionTitle:
        body.linked_question_title ?? body.linkedQuestionTitle,
    }, categories.map((category) => category.name));
    const task = await updateTask(taskId, input, session.user.id);

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
  } catch (error) {
    return NextResponse.json(
      {
        error: {
          code: "VALIDATION_ERROR",
          message: error instanceof Error ? error.message : "Task update failed.",
        },
      },
      { status: 400 },
    );
  }
}

export async function DELETE(_: Request, { params }: TaskRouteProps) {
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
  const task = await deleteTask(taskId, session.user.id);

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
    data: {
      deletedTaskId: task.id,
    },
  });
}
