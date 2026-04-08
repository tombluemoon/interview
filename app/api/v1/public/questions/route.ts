import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { listQuestions } from "@/modules/question-bank/question-bank.service";

export async function GET(request: Request) {
  const url = new URL(request.url);
  const q = url.searchParams.get("q") ?? undefined;
  const category = url.searchParams.get("category") ?? undefined;
  const session = await getSession();
  const questions = await listQuestions({ q, category }, session?.user.id);

  return NextResponse.json({
    data: questions,
    meta: {
      total: questions.length,
    },
  });
}
