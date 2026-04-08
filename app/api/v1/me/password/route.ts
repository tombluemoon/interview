import { NextResponse } from "next/server";

import { endSession, getSession } from "@/lib/auth";
import {
  changePassword,
  isProfileServiceError,
} from "@/modules/profile/profile.service";
import { parsePasswordChangeInput } from "@/modules/profile/profile.validation";

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
    const input = parsePasswordChangeInput({
      currentPassword: body.current_password ?? body.currentPassword,
      newPassword: body.new_password ?? body.newPassword,
      confirmPassword: body.confirm_password ?? body.confirmPassword,
    });

    await changePassword(session.user.id, input);
    await endSession();

    return NextResponse.json({
      data: {
        success: true,
      },
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
          message: "Password input is invalid.",
        },
      },
      { status: 400 },
    );
  }
}
