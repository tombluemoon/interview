import Link from "next/link";

import { archiveAdminQuestionAction } from "@/app/actions";
import type { QuestionContentStatus } from "@/types/domain";

interface AdminQuestionRow {
  id: string;
  title: string;
  slug: string;
  categoryId: string;
  categoryName: string;
  difficulty: string;
  contentStatus: QuestionContentStatus;
  statusLabel: string;
}

interface QuestionTableProps {
  rows: AdminQuestionRow[];
  returnTo: string;
}

export function QuestionTable({ rows, returnTo }: QuestionTableProps) {
  return (
    <div className="table-shell">
      <table className="admin-table">
        <thead>
          <tr>
            <th>Title</th>
            <th>Category</th>
            <th>Difficulty</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row.id}>
              <td>
                <div className="page-stack">
                  <strong>{row.title}</strong>
                  <span className="muted-copy">{row.slug}</span>
                </div>
              </td>
              <td>{row.categoryName}</td>
              <td>{row.difficulty}</td>
              <td>{row.statusLabel}</td>
              <td>
                <div className="button-row">
                  <Link
                    href={`/admin/questions/${row.id}/edit`}
                    className="button-secondary"
                  >
                    Edit
                  </Link>
                  {row.contentStatus !== "ARCHIVED" ? (
                    <form action={archiveAdminQuestionAction} className="inline-form">
                      <input type="hidden" name="questionId" value={row.id} />
                      <input type="hidden" name="returnTo" value={returnTo} />
                      <button type="submit" className="button-secondary">
                        Archive
                      </button>
                    </form>
                  ) : null}
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
