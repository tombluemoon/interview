import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { upsertQuestionProgress } from "@/modules/question-bank/question-bank.service";
import { parseProgressStatusInput } from "@/modules/question-bank/question-bank.validation";

interface QuestionProgressRouteProps {
  params: Promise<{
    questionId: string;
  }>;
}

export async function PUT(
  request: Request,
  { params }: QuestionProgressRouteProps,
) {
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

  const { questionId } = await params;

  try {
    const body = await request.json();
    const progressStatus = parseProgressStatusInput(
      body.progress_status ?? body.progressStatus,
    );
    const progress = await upsertQuestionProgress({
      questionId,
      progressStatus,
    }, session.user.id);

    if (!progress) {
      return NextResponse.json(
        {
          error: {
            code: "NOT_FOUND",
            message: "Question not found.",
          },
        },
        { status: 404 },
      );
    }

    return NextResponse.json({
      data: progress,
    });
  } catch (error) {
    return NextResponse.json(
      {
        error: {
          code: "VALIDATION_ERROR",
          message:
            error instanceof Error
              ? error.message
              : "Progress update failed.",
        },
      },
      { status: 400 },
    );
  }
}
