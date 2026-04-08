import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { listCategories } from "@/modules/question-bank/question-bank.service";
import {
  createTask,
  getTodayPlan,
} from "@/modules/daily-plan/daily-plan.service";
import { parseCreateTaskInput } from "@/modules/daily-plan/daily-plan.validation";

export async function GET() {
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

  const plan = await getTodayPlan(session.user.id);

  return NextResponse.json({
    data: plan.tasks,
  });
}

export async function POST(request: Request) {
  try {
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
    const task = await createTask(input, session.user.id);

    if (!task) {
      return NextResponse.json(
        {
          error: {
            code: "CREATE_FAILED",
            message: "Task creation failed.",
          },
        },
        { status: 500 },
      );
    }

    return NextResponse.json(
      {
        data: task,
      },
      { status: 201 },
    );
  } catch (error) {
    return NextResponse.json(
      {
        error: {
          code: "VALIDATION_ERROR",
          message:
            error instanceof Error ? error.message : "Task creation failed.",
        },
      },
      { status: 400 },
    );
  }
}
