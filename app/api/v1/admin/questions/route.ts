import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import {
  createAdminQuestion,
  isAdminServiceError,
  listAdminCategories,
  listAdminQuestions,
} from "@/modules/admin/admin.service";
import {
  parseAdminQuestionFilters,
  parseAdminQuestionInput,
} from "@/modules/admin/admin.validation";

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

  if (session.role !== "ADMIN") {
    return NextResponse.json(
      {
        error: {
          code: "FORBIDDEN",
          message: "Admin access is required.",
        },
      },
      { status: 403 },
    );
  }

  const categories = await listAdminCategories();
  const { searchParams } = new URL(request.url);
  const filters = parseAdminQuestionFilters(
    {
      q: searchParams.get("q"),
      category: searchParams.get("category"),
      status: searchParams.get("status"),
    },
    categories.map((category) => category.id),
  );
  const questions = await listAdminQuestions(filters);

  return NextResponse.json({
    data: questions,
  });
}

export async function POST(request: Request) {
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

  if (session.role !== "ADMIN") {
    return NextResponse.json(
      {
        error: {
          code: "FORBIDDEN",
          message: "Admin access is required.",
        },
      },
      { status: 403 },
    );
  }

  try {
    const body = await request.json();
    const categories = await listAdminCategories();
    const input = parseAdminQuestionInput(
      {
        title: body.title,
        slug: body.slug,
        categoryId: body.category_id ?? body.categoryId,
        difficulty: body.difficulty,
        tags: body.tags,
        excerpt: body.excerpt,
        body: body.body,
        hint: body.hint,
        referenceAnswer: body.reference_answer ?? body.referenceAnswer,
        relatedSlugs: body.related_slugs ?? body.relatedSlugs,
        visibility: body.visibility,
        contentStatus: body.content_status ?? body.contentStatus,
      },
      categories.map((category) => category.id),
    );
    const question = await createAdminQuestion(input);

    return NextResponse.json(
      {
        data: question,
      },
      { status: 201 },
    );
  } catch (error) {
    if (isAdminServiceError(error)) {
      return NextResponse.json(
        {
          error: {
            code: error.code,
            message: error.message,
          },
        },
        { status: error.status },
      );
    }

    return NextResponse.json(
      {
        error: {
          code: "BAD_REQUEST",
          message: "Question input is invalid.",
        },
      },
      { status: 400 },
    );
  }
}
