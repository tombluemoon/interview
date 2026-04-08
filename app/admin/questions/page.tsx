import Link from "next/link";

import { PageHeader } from "@/components/layout/PageHeader";
import { QuestionTable } from "@/components/admin/QuestionTable";
import { Card } from "@/components/ui/Card";
import {
  listAdminCategories,
  listAdminQuestions,
} from "@/modules/admin/admin.service";
import { parseAdminQuestionFilters } from "@/modules/admin/admin.validation";

export const dynamic = "force-dynamic";

interface AdminQuestionsPageProps {
  searchParams: Promise<{
    q?: string;
    category?: string;
    status?: string;
    saved?: string;
    error?: string;
  }>;
}

function getAdminQuestionsBanner(params: {
  saved?: string;
  error?: string;
}) {
  if (params.saved === "draft") {
    return "Question saved as draft.";
  }

  if (params.saved === "published") {
    return "Question published.";
  }

  if (params.saved === "archived") {
    return "Question archived.";
  }

  if (params.error === "slug") {
    return "That slug is already in use. Please choose another one.";
  }

  if (params.error === "question") {
    return "Question save failed. Please review the form and try again.";
  }

  return null;
}

export default async function AdminQuestionsPage({
  searchParams,
}: AdminQuestionsPageProps) {
  const params = await searchParams;
  const categories = await listAdminCategories();
  const filters = parseAdminQuestionFilters(
    params,
    categories.map((category) => category.id),
  );
  const questions = await listAdminQuestions(filters);
  const banner = getAdminQuestionsBanner(params);
  const queryParams = new URLSearchParams();

  if (filters.q) {
    queryParams.set("q", filters.q);
  }

  if (filters.category) {
    queryParams.set("category", filters.category);
  }

  if (filters.status) {
    queryParams.set("status", filters.status);
  }

  const queryString = queryParams.toString();
  const returnTo = `/admin/questions${queryString ? `?${queryString}` : ""}`;

  return (
    <div className="page-stack">
      {banner ? <div className="demo-banner">{banner}</div> : null}
      <PageHeader
        title="Admin Questions"
        description="Search, filter, and maintain interview question content."
        actions={
          <Link href="/admin/questions/new" className="button-primary">
            Create Question
          </Link>
        }
      />

      <Card title="Filters" eyebrow="Keep admin controls practical">
        <form className="form-grid" action="/admin/questions">
          <label className="field">
            Search
            <input
              type="text"
              name="q"
              defaultValue={filters.q}
              placeholder="LRU cache, MVCC, RAG..."
            />
          </label>
          <label className="field">
            Category
            <select name="category" defaultValue={filters.category ?? ""}>
              <option value="">All</option>
              {categories.map((category) => (
                <option key={category.id} value={category.id}>
                  {category.name}
                </option>
              ))}
            </select>
          </label>
          <label className="field">
            Status
            <select name="status" defaultValue={filters.status ?? ""}>
              <option value="">All</option>
              <option value="PUBLISHED">Published</option>
              <option value="DRAFT">Draft</option>
              <option value="ARCHIVED">Archived</option>
            </select>
          </label>
          <div className="field">
            <span>&nbsp;</span>
            <button type="submit" className="button-secondary">
              Apply Filters
            </button>
          </div>
        </form>
      </Card>

      <QuestionTable rows={questions} returnTo={returnTo} />
    </div>
  );
}
