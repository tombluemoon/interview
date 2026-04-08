import {
  createAdminCategoryAction,
  deleteAdminCategoryAction,
  updateAdminCategoryAction,
} from "@/app/actions";
import { PageHeader } from "@/components/layout/PageHeader";
import { Card } from "@/components/ui/Card";
import { listAdminCategories } from "@/modules/admin/admin.service";

export const dynamic = "force-dynamic";

interface AdminCategoriesPageProps {
  searchParams: Promise<{
    saved?: string;
    error?: string;
  }>;
}

function getAdminCategoriesBanner(params: {
  saved?: string;
  error?: string;
}) {
  if (params.saved === "created") {
    return "Category created.";
  }

  if (params.saved === "updated") {
    return "Category updated.";
  }

  if (params.saved === "deleted") {
    return "Category deleted.";
  }

  if (params.error === "slug") {
    return "That slug is already in use. Please choose another one.";
  }

  if (params.error === "name") {
    return "That category name is already in use. Please choose another one.";
  }

  if (params.error === "in_use") {
    return "Delete is blocked while this category is still referenced by questions, tasks, or profile preferences.";
  }

  if (params.error === "category") {
    return "Category save failed. Please review the form and try again.";
  }

  return null;
}

export default async function AdminCategoriesPage({
  searchParams,
}: AdminCategoriesPageProps) {
  const params = await searchParams;
  const categories = await listAdminCategories();
  const banner = getAdminCategoriesBanner(params);

  return (
    <div className="page-stack">
      {banner ? <div className="demo-banner">{banner}</div> : null}
      <PageHeader
        title="Categories"
        description="Version 1 only needs a simple list with lightweight edits."
      />

      <div className="grid-two">
        <Card title="Current Categories">
          <div className="page-stack">
            {categories.map((category) => (
              <div key={category.id} className="surface-panel">
                <div className="section-heading">
                  <h3>{category.name}</h3>
                  <span className="tag-chip">{category.questionCount} questions</span>
                </div>
                <p className="muted-copy">{category.slug}</p>
                <p>{category.description}</p>
                <details className="task-edit-details">
                  <summary className="button-secondary task-edit-summary">
                    Edit
                  </summary>
                  <form action={updateAdminCategoryAction} className="form-grid task-edit-form">
                    <input type="hidden" name="categoryId" value={category.id} />
                    <label className="field-full">
                      Name
                      <input type="text" name="name" defaultValue={category.name} />
                    </label>
                    <label className="field-full">
                      Slug
                      <input type="text" name="slug" defaultValue={category.slug} />
                    </label>
                    <label className="field-full">
                      Description
                      <textarea
                        rows={4}
                        name="description"
                        defaultValue={category.description}
                      />
                    </label>
                    <div className="field-full">
                      <button type="submit" className="button-primary">
                        Save Changes
                      </button>
                    </div>
                  </form>
                  <div className="button-row">
                    <form action={deleteAdminCategoryAction} className="inline-form">
                      <input type="hidden" name="categoryId" value={category.id} />
                      <button
                        type="submit"
                        className="button-danger"
                        disabled={category.questionCount > 0}
                        title={
                          category.questionCount > 0
                            ? "Move or archive linked questions before deleting this category."
                            : undefined
                        }
                      >
                        Delete
                      </button>
                    </form>
                  </div>
                  {category.questionCount > 0 ? (
                    <p className="muted-copy">
                      Delete is disabled while questions still belong to this category.
                    </p>
                  ) : null}
                </details>
              </div>
            ))}
          </div>
        </Card>

        <Card title="Create Category">
          <form action={createAdminCategoryAction} className="form-grid">
            <label className="field-full">
              Name
              <input type="text" name="name" placeholder="Behavioral" />
            </label>
            <label className="field-full">
              Slug
              <input type="text" name="slug" placeholder="Leave blank to auto-generate" />
            </label>
            <label className="field-full">
              Description
              <textarea
                rows={4}
                name="description"
                placeholder="Short category explanation."
              />
            </label>
            <div className="field-full">
              <button type="submit" className="button-primary">
                Save Category
              </button>
            </div>
          </form>
        </Card>
      </div>
    </div>
  );
}
