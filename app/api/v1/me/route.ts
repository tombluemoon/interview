import { NextResponse } from "next/server";

import { getSession } from "@/lib/auth";
import { listCategories } from "@/modules/question-bank/question-bank.service";
import {
  getProfile,
  isProfileServiceError,
  updateProfile,
} from "@/modules/profile/profile.service";
import { parseProfileUpdateInput } from "@/modules/profile/profile.validation";

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

  const profile = await getProfile(session.user.id);

  return NextResponse.json({
    data: profile,
  });
}

export async function PUT(request: Request) {
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

  try {
    const body = await request.json();
    const categories = await listCategories();
    const input = parseProfileUpdateInput(
      {
        displayName: body.display_name ?? body.displayName,
        email: body.email,
        preferredTracks: body.preferred_tracks ?? body.preferredTracks,
      },
      categories.map((category) => category.name),
    );
    const profile = await updateProfile(session.user.id, input);

    return NextResponse.json({
      data: profile,
    });
  } catch (error) {
    if (isProfileServiceError(error)) {
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
          message: "Profile input is invalid.",
        },
      },
      { status: 400 },
    );
  }
}
