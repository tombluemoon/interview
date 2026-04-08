"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

import {
  endSession,
  requireAdminSession,
  requireSession,
  startSession,
} from "@/lib/auth";
import {
  createAdminCategory,
  deleteAdminCategory,
  createAdminQuestion,
  getAdminCategoryById,
  getAdminQuestionById,
  isAdminServiceError,
  listAdminCategories,
  updateAdminCategory,
  updateAdminQuestion,
} from "@/modules/admin/admin.service";
import {
  parseAdminCategoryInput,
  parseAdminQuestionInput,
  parseAdminQuestionIntent,
} from "@/modules/admin/admin.validation";
import {
  authenticateUser,
  createUserAccount,
  isAuthServiceError,
} from "@/modules/auth/auth.service";
import {
  getPostAuthRedirectPath,
  sanitizeNextPath,
} from "@/modules/auth/auth.helpers";
import {
  parseLoginInput,
  parseSignupInput,
} from "@/modules/auth/auth.validation";
import {
  carryOverTask,
  completeTask,
  createTask,
  deleteTask,
  reopenTask,
  updateTask,
} from "@/modules/daily-plan/daily-plan.service";
import { parseCreateTaskInput } from "@/modules/daily-plan/daily-plan.validation";
import {
  findQuestionBySlug,
  listCategories,
  upsertQuestionProgress,
} from "@/modules/question-bank/question-bank.service";
import { parseProgressStatusInput } from "@/modules/question-bank/question-bank.validation";
import {
  changePassword,
  isProfileServiceError,
  updateProfile,
} from "@/modules/profile/profile.service";
import {
  parsePasswordChangeInput,
  parseProfileUpdateInput,
} from "@/modules/profile/profile.validation";

function readString(formData: FormData, key: string) {
  const value = formData.get(key);

  return typeof value === "string" ? value : "";
}

function readStringList(formData: FormData, key: string) {
  return formData
    .getAll(key)
    .filter((value): value is string => typeof value === "string");
}

function appendQueryValue(path: string, key: string, value: string) {
  const separator = path.includes("?") ? "&" : "?";

  return `${path}${separator}${key}=${value}`;
}

function revalidateTaskViews() {
  revalidatePath("/app/today");
  revalidatePath("/app/plans");
  revalidatePath("/app/reports");
}

function revalidateCategoryViews() {
  revalidatePath("/");
  revalidatePath("/admin/categories");
  revalidatePath("/admin/questions");
  revalidatePath("/admin/questions/new");
  revalidatePath("/questions");
  revalidatePath("/app/profile");
  revalidatePath("/app/today");
  revalidatePath("/app/reports");
}

function revalidateAdminQuestionViews(questionId?: string, slugs: string[] = []) {
  revalidatePath("/admin/questions");
  revalidatePath("/admin/questions/new");
  revalidatePath("/questions");

  if (questionId) {
    revalidatePath(`/admin/questions/${questionId}/edit`);
  }

  for (const slug of slugs) {
    if (slug) {
      revalidatePath(`/questions/${slug}`);
    }
  }
}

function getTaskReturnPath(formData: FormData, fallback: string) {
  return sanitizeNextPath(readString(formData, "returnTo")) ?? fallback;
}

function getAdminReturnPath(formData: FormData, fallback: string) {
  return sanitizeNextPath(readString(formData, "returnTo")) ?? fallback;
}

function getAdminQuestionSavedParam(value: string) {
  switch (value) {
    case "PUBLISHED":
      return "published";
    case "ARCHIVED":
      return "archived";
    default:
      return "draft";
  }
}

async function parseAdminQuestionFormData(
  formData: FormData,
  options?: { allowArchive?: boolean },
) {
  const categories = await listAdminCategories();
  const contentStatus = parseAdminQuestionIntent(
    readString(formData, "intent"),
    options,
  );

  return parseAdminQuestionInput(
    {
      title: readString(formData, "title"),
      slug: readString(formData, "slug"),
      categoryId: readString(formData, "categoryId"),
      difficulty: readString(formData, "difficulty"),
      tags: readString(formData, "tags"),
      excerpt: readString(formData, "excerpt"),
      body: readString(formData, "body"),
      hint: readString(formData, "hint"),
      referenceAnswer: readString(formData, "referenceAnswer"),
      relatedSlugs: readString(formData, "relatedSlugs"),
      visibility: readString(formData, "visibility"),
      contentStatus,
    },
    categories.map((category) => category.id),
  );
}

function parseAdminCategoryFormData(formData: FormData) {
  return parseAdminCategoryInput({
    name: readString(formData, "name"),
    slug: readString(formData, "slug"),
    description: readString(formData, "description"),
  });
}

async function parseProfileUpdateFormData(formData: FormData) {
  const categories = await listCategories();

  return parseProfileUpdateInput(
    {
      displayName: readString(formData, "displayName"),
      email: readString(formData, "email"),
      preferredTracks: readStringList(formData, "preferredTracks"),
    },
    categories.map((category) => category.name),
  );
}

function parsePasswordChangeFormData(formData: FormData) {
  return parsePasswordChangeInput({
    currentPassword: readString(formData, "currentPassword"),
    newPassword: readString(formData, "newPassword"),
    confirmPassword: readString(formData, "confirmPassword"),
  });
}

export async function createTaskAction(formData: FormData) {
  const session = await requireSession();

  try {
    const categories = await listCategories();
    const input = parseCreateTaskInput({
      title: readString(formData, "title"),
      taskType: readString(formData, "taskType"),
      priority: readString(formData, "priority"),
      categoryName: readString(formData, "categoryName"),
      linkedQuestionSlug: readString(formData, "linkedQuestionSlug"),
      linkedQuestionTitle: readString(formData, "linkedQuestionTitle"),
    }, categories.map((category) => category.name));

    const task = await createTask(input, session.user.id);

    if (!task) {
      throw new Error("Task creation failed.");
    }
  } catch {
    redirect("/app/today?error=task");
  }

  revalidateTaskViews();
  redirect("/app/today?task=created");
}

export async function completeTaskAction(formData: FormData) {
  const session = await requireSession();
  const taskId = readString(formData, "taskId");

  if (!taskId) {
    redirect("/app/today?error=task");
  }

  const task = await completeTask(taskId, session.user.id);

  if (!task) {
    redirect("/app/today?error=task");
  }

  revalidateTaskViews();
  redirect("/app/today?task=completed");
}

export async function updateTaskAction(formData: FormData) {
  const session = await requireSession();
  const taskId = readString(formData, "taskId");
  const returnTo = getTaskReturnPath(formData, "/app/today");

  if (!taskId) {
    redirect("/app/today?error=task");
  }

  try {
    const categories = await listCategories();
    const input = parseCreateTaskInput({
      title: readString(formData, "title"),
      taskType: readString(formData, "taskType"),
      priority: readString(formData, "priority"),
      categoryName: readString(formData, "categoryName"),
      linkedQuestionSlug: readString(formData, "linkedQuestionSlug"),
      linkedQuestionTitle: readString(formData, "linkedQuestionTitle"),
    }, categories.map((category) => category.name));
    const task = await updateTask(taskId, input, session.user.id);

    if (!task) {
      throw new Error("Task not found.");
    }
  } catch {
    redirect(appendQueryValue(returnTo, "error", "task"));
  }

  revalidateTaskViews();
  redirect(appendQueryValue(returnTo, "task", "updated"));
}

export async function deleteTaskAction(formData: FormData) {
  const session = await requireSession();
  const taskId = readString(formData, "taskId");
  const returnTo = getTaskReturnPath(formData, "/app/today");

  if (!taskId) {
    redirect(appendQueryValue(returnTo, "error", "task"));
  }

  const task = await deleteTask(taskId, session.user.id);

  if (!task) {
    redirect(appendQueryValue(returnTo, "error", "task"));
  }

  revalidateTaskViews();
  redirect(appendQueryValue(returnTo, "task", "deleted"));
}

export async function reopenTaskAction(formData: FormData) {
  const session = await requireSession();
  const taskId = readString(formData, "taskId");
  const returnTo = getTaskReturnPath(formData, "/app/today");

  if (!taskId) {
    redirect(appendQueryValue(returnTo, "error", "task"));
  }

  const task = await reopenTask(taskId, session.user.id);

  if (!task) {
    redirect(appendQueryValue(returnTo, "error", "task"));
  }

  revalidateTaskViews();
  redirect(appendQueryValue(returnTo, "task", "reopened"));
}

export async function carryOverTaskAction(formData: FormData) {
  const session = await requireSession();
  const taskId = readString(formData, "taskId");
  const returnTo = getTaskReturnPath(formData, "/app/today");

  if (!taskId) {
    redirect(appendQueryValue(returnTo, "error", "task"));
  }

  const result = await carryOverTask(taskId, session.user.id);

  if (!result) {
    redirect(appendQueryValue(returnTo, "error", "task"));
  }

  revalidateTaskViews();
  redirect(appendQueryValue(returnTo, "task", "carried"));
}

export async function addQuestionToTodayAction(formData: FormData) {
  const session = await requireSession();
  const slug = readString(formData, "slug");

  try {
    const categories = await listCategories();
    const input = parseCreateTaskInput({
      title: readString(formData, "title"),
      taskType: "QUESTION_LINKED",
      priority: "3",
      categoryName: readString(formData, "categoryName"),
      linkedQuestionSlug: slug,
      linkedQuestionTitle: readString(formData, "linkedQuestionTitle"),
    }, categories.map((category) => category.name));

    const task = await createTask(input, session.user.id);

    if (!task) {
      throw new Error("Task creation failed.");
    }
  } catch {
    redirect(`/questions/${slug}?error=task`);
  }

  revalidateTaskViews();
  revalidatePath(`/questions/${slug}`);
  redirect(`/questions/${slug}?task=added`);
}

export async function updateQuestionProgressAction(formData: FormData) {
  const session = await requireSession();
  const questionId = readString(formData, "questionId");
  const slug = readString(formData, "slug");

  try {
    const progressStatus = parseProgressStatusInput(
      readString(formData, "progressStatus"),
    );

    const progress = await upsertQuestionProgress({
      questionId,
      progressStatus,
    }, session.user.id);

    if (!progress) {
      throw new Error("Progress update failed.");
    }
  } catch {
    redirect(`/questions/${slug}?error=progress`);
  }

  revalidatePath(`/questions/${slug}`);
  revalidatePath("/questions");
  revalidatePath("/app/reports");
  redirect(`/questions/${slug}?progress=updated`);
}

export async function addCurrentQuestionToTodayBySlug(slug: string) {
  const session = await requireSession();
  const question = await findQuestionBySlug(slug, session.user.id);

  if (!question) {
    redirect(`/questions/${slug}?error=task`);
  }

  const task = await createTask({
    title: `Review ${question.title}`,
    taskType: "QUESTION_LINKED",
    priority: 3,
    categoryName: question.categoryName,
    linkedQuestionSlug: question.slug,
    linkedQuestionTitle: question.title,
  }, session.user.id);

  if (!task) {
    redirect(`/questions/${slug}?error=task`);
  }

  revalidateTaskViews();
  revalidatePath(`/questions/${slug}`);
}

export async function createAdminCategoryAction(formData: FormData) {
  await requireAdminSession();

  try {
    const input = parseAdminCategoryFormData(formData);

    await createAdminCategory(input);
  } catch (error) {
    if (isAdminServiceError(error)) {
      if (error.code === "SLUG_TAKEN") {
        redirect("/admin/categories?error=slug");
      }

      if (error.code === "NAME_TAKEN") {
        redirect("/admin/categories?error=name");
      }
    }

    redirect("/admin/categories?error=category");
  }

  revalidateCategoryViews();
  redirect("/admin/categories?saved=created");
}

export async function updateAdminCategoryAction(formData: FormData) {
  await requireAdminSession();

  const categoryId = readString(formData, "categoryId");

  if (!categoryId) {
    redirect("/admin/categories?error=category");
  }

  const existingCategory = await getAdminCategoryById(categoryId);

  if (!existingCategory) {
    redirect("/admin/categories?error=category");
  }

  try {
    const input = parseAdminCategoryFormData(formData);

    await updateAdminCategory(categoryId, input);
  } catch (error) {
    if (isAdminServiceError(error)) {
      if (error.code === "SLUG_TAKEN") {
        redirect("/admin/categories?error=slug");
      }

      if (error.code === "NAME_TAKEN") {
        redirect("/admin/categories?error=name");
      }
    }

    redirect("/admin/categories?error=category");
  }

  revalidateCategoryViews();
  redirect("/admin/categories?saved=updated");
}

export async function deleteAdminCategoryAction(formData: FormData) {
  await requireAdminSession();

  const categoryId = readString(formData, "categoryId");

  if (!categoryId) {
    redirect("/admin/categories?error=category");
  }

  try {
    await deleteAdminCategory(categoryId);
  } catch (error) {
    if (isAdminServiceError(error) && error.code === "CATEGORY_IN_USE") {
      redirect("/admin/categories?error=in_use");
    }

    redirect("/admin/categories?error=category");
  }

  revalidateCategoryViews();
  redirect("/admin/categories?saved=deleted");
}

export async function createAdminQuestionAction(formData: FormData) {
  await requireAdminSession();
  let question;

  try {
    const input = await parseAdminQuestionFormData(formData);
    question = await createAdminQuestion(input);
  } catch (error) {
    if (isAdminServiceError(error) && error.code === "SLUG_TAKEN") {
      redirect("/admin/questions/new?error=slug");
    }

    redirect("/admin/questions/new?error=question");
  }

  revalidateAdminQuestionViews(question.id, [question.slug]);
  redirect(
    `/admin/questions/${question.id}/edit?saved=${getAdminQuestionSavedParam(question.contentStatus ?? "DRAFT")}`,
  );
}

export async function updateAdminQuestionAction(formData: FormData) {
  await requireAdminSession();

  const questionId = readString(formData, "questionId");
  const returnTo = getAdminReturnPath(
    formData,
    questionId ? `/admin/questions/${questionId}/edit` : "/admin/questions",
  );

  if (!questionId) {
    redirect(appendQueryValue(returnTo, "error", "question"));
  }

  const existingQuestion = await getAdminQuestionById(questionId);

  if (!existingQuestion) {
    redirect(appendQueryValue(returnTo, "error", "question"));
  }

  let question;

  try {
    const input = await parseAdminQuestionFormData(formData, {
      allowArchive: true,
    });
    question = await updateAdminQuestion(questionId, input);
  } catch (error) {
    if (isAdminServiceError(error) && error.code === "SLUG_TAKEN") {
      redirect(appendQueryValue(returnTo, "error", "slug"));
    }

    redirect(appendQueryValue(returnTo, "error", "question"));
  }

  revalidateAdminQuestionViews(question.id, [
    existingQuestion.slug,
    question.slug,
  ]);
  redirect(
    appendQueryValue(
      returnTo,
      "saved",
      getAdminQuestionSavedParam(question.contentStatus ?? "DRAFT"),
    ),
  );
}

export async function archiveAdminQuestionAction(formData: FormData) {
  await requireAdminSession();

  const questionId = readString(formData, "questionId");
  const returnTo = getAdminReturnPath(formData, "/admin/questions");

  if (!questionId) {
    redirect(appendQueryValue(returnTo, "error", "question"));
  }

  const question = await getAdminQuestionById(questionId);

  if (!question) {
    redirect(appendQueryValue(returnTo, "error", "question"));
  }

  let archivedQuestion;

  try {
    archivedQuestion = await updateAdminQuestion(questionId, {
      title: question.title,
      slug: question.slug,
      categoryId: question.categoryId,
      difficulty: question.difficulty,
      tags: question.tags,
      excerpt: question.excerpt,
      body: question.body,
      hint: question.hint,
      referenceAnswer: question.referenceAnswer,
      relatedSlugs: question.relatedSlugs,
      visibility: question.visibility ?? "PUBLIC",
      contentStatus: "ARCHIVED",
    });
  } catch {
    redirect(appendQueryValue(returnTo, "error", "question"));
  }

  revalidateAdminQuestionViews(archivedQuestion.id, [question.slug]);
  redirect(appendQueryValue(returnTo, "saved", "archived"));
}

export async function updateProfileAction(formData: FormData) {
  const session = await requireSession();

  try {
    const input = await parseProfileUpdateFormData(formData);

    await updateProfile(session.user.id, input);
  } catch (error) {
    if (isProfileServiceError(error) && error.code === "EMAIL_TAKEN") {
      redirect("/app/profile?error=email");
    }

    redirect("/app/profile?error=profile");
  }

  revalidatePath("/app/profile");
  redirect("/app/profile?saved=profile");
}

export async function changePasswordAction(formData: FormData) {
  const session = await requireSession();

  try {
    const input = parsePasswordChangeFormData(formData);

    await changePassword(session.user.id, input);
  } catch (error) {
    if (
      isProfileServiceError(error) &&
      error.code === "CURRENT_PASSWORD_INVALID"
    ) {
      redirect("/app/profile?error=current_password");
    }

    redirect("/app/profile?error=password");
  }

  await endSession();
  redirect("/login?password_changed=1");
}

export async function loginAction(formData: FormData) {
  let redirectPath: string;

  try {
    const input = parseLoginInput({
      email: readString(formData, "email"),
      password: readString(formData, "password"),
      nextPath: readString(formData, "nextPath"),
    });
    const user = await authenticateUser(input);

    await startSession(user);
    redirectPath = appendQueryValue(
      getPostAuthRedirectPath(user.role, input.nextPath),
      "auth",
      "login",
    );
  } catch (error) {
    if (isAuthServiceError(error)) {
      redirect(`/login?error=${error.code.toLowerCase()}`);
    }

    redirect("/login?error=login_failed");
  }

  redirect(redirectPath);
}

export async function signupAction(formData: FormData) {
  let redirectPath: string;

  try {
    const input = parseSignupInput({
      displayName: readString(formData, "displayName"),
      email: readString(formData, "email"),
      password: readString(formData, "password"),
      confirmPassword: readString(formData, "confirmPassword"),
      nextPath: readString(formData, "nextPath"),
    });
    const user = await createUserAccount(input);

    await startSession(user);
    redirectPath = appendQueryValue(
      getPostAuthRedirectPath(user.role, input.nextPath),
      "auth",
      "signup",
    );
  } catch (error) {
    if (isAuthServiceError(error)) {
      redirect(`/signup?error=${error.code.toLowerCase()}`);
    }

    redirect("/signup?error=signup_failed");
  }

  redirect(redirectPath);
}

export async function logoutAction() {
  await endSession();
  redirect("/login?logged_out=1");
}
