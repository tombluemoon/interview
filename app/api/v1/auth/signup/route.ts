import { NextResponse } from "next/server";

import { startSession } from "@/lib/auth";
import {
  createUserAccount,
  isAuthServiceError,
} from "@/modules/auth/auth.service";
import { parseSignupInput } from "@/modules/auth/auth.validation";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const input = parseSignupInput({
      displayName: body.display_name ?? body.displayName,
      email: body.email,
      password: body.password,
      confirmPassword: body.confirm_password ?? body.confirmPassword,
      nextPath: body.next_path ?? body.nextPath,
    });
    const user = await createUserAccount(input);
    const session = await startSession(user);

    return NextResponse.json(
      {
        data: {
          ...session,
          created: true,
        },
      },
      { status: 201 },
    );
  } catch (error) {
    if (isAuthServiceError(error)) {
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
          code: "SIGNUP_FAILED",
          message: error instanceof Error ? error.message : "Signup failed.",
        },
      },
      { status: 400 },
    );
  }
}
