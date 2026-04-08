import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { listCategories } from "@/modules/question-bank/question-bank.service";
import { getOverviewReport } from "@/modules/reports/reports.service";
import { parseReportFilters } from "@/modules/reports/reports.validation";

export async function GET(request: Request) {
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

  const { searchParams } = new URL(request.url);
  const categories = await listCategories();
  const filters = parseReportFilters(
    {
      range: searchParams.get("range") ?? undefined,
      category: searchParams.get("category") ?? undefined,
    },
    categories.map((category) => category.id),
  );
  const selectedCategory = categories.find(
    (category) => category.id === filters.categoryId,
  );
  const report = await getOverviewReport(session.user.id, {
    rangeDays: filters.rangeDays,
    categoryId: selectedCategory?.id,
    categoryName: selectedCategory?.name,
  });

  return NextResponse.json({
    data: report,
  });
}
