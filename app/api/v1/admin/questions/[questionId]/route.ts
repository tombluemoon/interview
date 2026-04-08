import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import {
  getAdminQuestionById,
  isAdminServiceError,
  listAdminCategories,
  updateAdminQuestion,
} from "@/modules/admin/admin.service";
import { parseAdminQuestionInput } from "@/modules/admin/admin.validation";

interface AdminQuestionRouteProps {
  params: Promise<{
    questionId: string;
  }>;
}

export async function GET(_: Request, { params }: AdminQuestionRouteProps) {
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

  const { questionId } = await params;
  const question = await getAdminQuestionById(questionId);

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

export async function PUT(request: Request, { params }: AdminQuestionRouteProps) {
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

  const { questionId } = await params;

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
    const question = await updateAdminQuestion(questionId, input);

    return NextResponse.json({
      data: question,
    });
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
