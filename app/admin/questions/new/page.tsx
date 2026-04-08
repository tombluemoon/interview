import { createAdminQuestionAction } from "@/app/actions";
import { QuestionEditorForm } from "@/components/admin/QuestionEditorForm";
import { PageHeader } from "@/components/layout/PageHeader";
import { Card } from "@/components/ui/Card";
import { listAdminCategories } from "@/modules/admin/admin.service";

interface NewQuestionPageProps {
  searchParams: Promise<{
    error?: string;
  }>;
}

function getNewQuestionBanner(params: { error?: string }) {
  if (params.error === "slug") {
    return "That slug is already in use. Please choose another one.";
  }

  if (params.error === "question") {
    return "Question creation failed. Please review the form and try again.";
  }

  return null;
}

export default async function NewQuestionPage({
  searchParams,
}: NewQuestionPageProps) {
  const params = await searchParams;
  const categories = await listAdminCategories();
  const banner = getNewQuestionBanner(params);

  return (
    <div className="page-stack">
      {banner ? <div className="demo-banner">{banner}</div> : null}
      <PageHeader
        title="Create Question"
        description="One editor form is enough for the first release."
      />

      <Card title="Question Editor" eyebrow="Draft first, publish later">
        <QuestionEditorForm
          action={createAdminQuestionAction}
          categories={categories}
          mode="create"
        />
      </Card>
    </div>
  );
}
