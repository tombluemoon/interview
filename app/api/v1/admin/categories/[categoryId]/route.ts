import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import {
  deleteAdminCategory,
  getAdminCategoryById,
  isAdminServiceError,
  updateAdminCategory,
} from "@/modules/admin/admin.service";
import { parseAdminCategoryInput } from "@/modules/admin/admin.validation";

interface AdminCategoryRouteProps {
  params: Promise<{
    categoryId: string;
  }>;
}

async function requireAdminApiSession() {
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

  return null;
}

export async function GET(_: Request, { params }: AdminCategoryRouteProps) {
  const authError = await requireAdminApiSession();

  if (authError) {
    return authError;
  }

  const { categoryId } = await params;
  const category = await getAdminCategoryById(categoryId);

  if (!category) {
    return NextResponse.json(
      {
        error: {
          code: "NOT_FOUND",
          message: "Category not found.",
        },
      },
      { status: 404 },
    );
  }

  return NextResponse.json({
    data: category,
  });
}

export async function PUT(request: Request, { params }: AdminCategoryRouteProps) {
  const authError = await requireAdminApiSession();

  if (authError) {
    return authError;
  }

  const { categoryId } = await params;

  try {
    const body = await request.json();
    const input = parseAdminCategoryInput({
      name: body.name,
      slug: body.slug,
      description: body.description,
    });
    const category = await updateAdminCategory(categoryId, input);

    return NextResponse.json({
      data: category,
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
          message: "Category input is invalid.",
        },
      },
      { status: 400 },
    );
  }
}

export async function DELETE(_: Request, { params }: AdminCategoryRouteProps) {
  const authError = await requireAdminApiSession();

  if (authError) {
    return authError;
  }

  const { categoryId } = await params;

  try {
    const category = await deleteAdminCategory(categoryId);

    return NextResponse.json({
      data: category,
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
          message: "Category deletion failed.",
        },
      },
      { status: 400 },
    );
  }
}
