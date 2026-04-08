import { cookies } from "next/headers";
import { redirect } from "next/navigation";

import { demoAdmin, demoUser } from "@/lib/mock-data";
import { isDatabaseConfigured } from "@/lib/db";
import {
  createUserSession,
  deleteUserSession,
  getUserBySessionToken,
} from "@/modules/auth/auth.service";
import {
  SESSION_MAX_AGE_SECONDS,
} from "@/modules/auth/auth.helpers";
import type { UserProfile, UserRole } from "@/types/domain";

const AUTH_COOKIE_NAME = "interview_review_session";
const AUTH_UNAVAILABLE_REDIRECT = "/login?error=auth_unavailable";

export interface Session {
  user: UserProfile;
  role: UserRole;
  demoMode: boolean;
}

function buildDemoSession(role: UserRole = "USER"): Session {
  const user = role === "ADMIN" ? demoAdmin : demoUser;

  return {
    user,
    role,
    demoMode: true,
  };
}

export async function getSession(
  expectedRole?: UserRole,
): Promise<Session | null> {
  if (!isDatabaseConfigured()) {
    return null;
  }

  const cookieStore = await cookies();
  const token = cookieStore.get(AUTH_COOKIE_NAME)?.value;

  if (!token) {
    return null;
  }

  const user = await getUserBySessionToken(token);

  if (!user) {
    return null;
  }

  if (expectedRole && user.role !== expectedRole) {
    return null;
  }

  return {
    user,
    role: user.role,
    demoMode: false,
  };
}

export async function requireSession() {
  if (!isDatabaseConfigured()) {
    redirect(AUTH_UNAVAILABLE_REDIRECT);
  }

  const session = await getSession();

  if (!session) {
    redirect("/login");
  }

  return session;
}

export async function requireAdminSession() {
  if (!isDatabaseConfigured()) {
    redirect(AUTH_UNAVAILABLE_REDIRECT);
  }

  const session = await getSession();

  if (!session) {
    redirect("/login");
  }

  if (session.role !== "ADMIN") {
    redirect("/app/today");
  }

  return session;
}

export async function startSession(user: UserProfile) {
  if (!isDatabaseConfigured()) {
    return buildDemoSession(user.role);
  }

  const cookieStore = await cookies();
  const { token, expiresAt } = await createUserSession(user.id);

  cookieStore.set(AUTH_COOKIE_NAME, token, {
    httpOnly: true,
    sameSite: "lax",
    secure: process.env.NODE_ENV === "production",
    path: "/",
    expires: expiresAt,
    maxAge: SESSION_MAX_AGE_SECONDS,
  });

  return {
    user,
    role: user.role,
    demoMode: false,
  };
}

export async function endSession() {
  const cookieStore = await cookies();
  const token = cookieStore.get(AUTH_COOKIE_NAME)?.value;

  if (token) {
    await deleteUserSession(token);
  }

  cookieStore.delete(AUTH_COOKIE_NAME);
}
