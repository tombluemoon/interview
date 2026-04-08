import { NextResponse } from "next/server";

import { listCategories } from "@/modules/question-bank/question-bank.service";

export async function GET() {
  const categories = await listCategories();

  return NextResponse.json({
    data: categories,
  });
}
