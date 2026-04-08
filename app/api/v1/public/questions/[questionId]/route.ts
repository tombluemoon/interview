import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { findQuestionById } from "@/modules/question-bank/question-bank.service";

interface QuestionRouteProps {
  params: Promise<{
    questionId: string;
  }>;
}

export async function GET(_: Request, { params }: QuestionRouteProps) {
  const { questionId } = await params;
  const session = await getSession();
  const question = await findQuestionById(questionId, session?.user.id);

  if (!question) {
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
    data: question,
  });
}
