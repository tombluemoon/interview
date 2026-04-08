import { NextResponse } from "next/server";

import { startSession } from "@/lib/auth";
import {
  authenticateUser,
  isAuthServiceError,
} from "@/modules/auth/auth.service";
import { parseLoginInput } from "@/modules/auth/auth.validation";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const input = parseLoginInput({
      email: body.email,
      password: body.password,
      nextPath: body.next_path ?? body.nextPath,
    });
    const user = await authenticateUser(input);
    const session = await startSession(user);

    return NextResponse.json({
      data: session,
    });
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
          code: "LOGIN_FAILED",
          message: error instanceof Error ? error.message : "Login failed.",
        },
      },
      { status: 400 },
    );
  }
}
