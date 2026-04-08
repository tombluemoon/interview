import { notFound } from "next/navigation";

import { updateAdminQuestionAction } from "@/app/actions";
import { QuestionEditorForm } from "@/components/admin/QuestionEditorForm";
import { PageHeader } from "@/components/layout/PageHeader";
import { Card } from "@/components/ui/Card";
import {
  getAdminQuestionById,
  listAdminCategories,
} from "@/modules/admin/admin.service";

interface EditQuestionPageProps {
  params: Promise<{
    questionId: string;
  }>;
  searchParams: Promise<{
    saved?: string;
    error?: string;
  }>;
}

export const dynamic = "force-dynamic";

export default async function EditQuestionPage({
  params,
  searchParams,
}: EditQuestionPageProps) {
  const { questionId } = await params;
  const query = await searchParams;
  const question = await getAdminQuestionById(questionId);
  const categories = await listAdminCategories();

  if (!question) {
    notFound();
  }

  const banner =
    query.saved === "draft"
      ? "Question saved as draft."
      : query.saved === "published"
        ? "Question published."
        : query.saved === "archived"
          ? "Question archived."
          : query.error === "slug"
            ? "That slug is already in use. Please choose another one."
            : query.error === "question"
              ? "Question update failed. Please review the form and try again."
              : null;

  return (
    <div className="page-stack">
      {banner ? <div className="demo-banner">{banner}</div> : null}
      <PageHeader
        title="Edit Question"
        description="This page reuses the same form structure as create-question."
      />

      <Card title={question.title} eyebrow="Editing existing content">
        <QuestionEditorForm
          action={updateAdminQuestionAction}
          categories={categories}
          question={question}
          mode="edit"
          returnTo={`/admin/questions/${question.id}/edit`}
        />
      </Card>
    </div>
  );
}
