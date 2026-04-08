import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import {
  createAdminCategory,
  isAdminServiceError,
  listAdminCategories,
} from "@/modules/admin/admin.service";
import { parseAdminCategoryInput } from "@/modules/admin/admin.validation";

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

  return NextResponse.json({
    data: categories,
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
    const input = parseAdminCategoryInput({
      name: body.name,
      slug: body.slug,
      description: body.description,
    });
    const category = await createAdminCategory(input);

    return NextResponse.json(
      {
        data: category,
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
          message: "Category input is invalid.",
        },
      },
      { status: 400 },
    );
  }
}
