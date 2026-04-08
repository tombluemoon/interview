import { createTaskAction } from "@/app/actions";
import { PageHeader } from "@/components/layout/PageHeader";
import { TaskList } from "@/components/daily-plan/TaskList";
import { Card } from "@/components/ui/Card";
import { requireSession } from "@/lib/auth";
import { getTodayPlan } from "@/modules/daily-plan/daily-plan.service";
import { listCategories } from "@/modules/question-bank/question-bank.service";

export const dynamic = "force-dynamic";

interface TodayPageProps {
  searchParams: Promise<{
    task?: string;
    auth?: string;
    error?: string;
  }>;
}

function getTodayBanner(params: { task?: string; auth?: string; error?: string }) {
  if (params.auth === "login") {
    return "Logged in successfully.";
  }

  if (params.auth === "signup") {
    return "Account created successfully.";
  }

  if (params.task === "created") {
    return "Task created and saved to PostgreSQL.";
  }

  if (params.task === "completed") {
    return "Task marked completed.";
  }

  if (params.task === "updated") {
    return "Task details updated.";
  }

  if (params.task === "deleted") {
    return "Task deleted.";
  }

  if (params.task === "reopened") {
    return "Task moved back to pending.";
  }

  if (params.task === "carried") {
    return "Task carried over to tomorrow.";
  }

  if (params.error === "task") {
    return "Task action failed. Please check the input and try again.";
  }

  return null;
}

export default async function TodayPage({ searchParams }: TodayPageProps) {
  const params = await searchParams;
  const session = await requireSession();
  const categories = await listCategories();
  const plan = await getTodayPlan(session.user.id);
  const banner = getTodayBanner(params);
  const categoryNames = categories.map((category) => category.name);
  const defaultCategoryName = categoryNames.includes("SQL")
    ? "SQL"
    : (categoryNames[0] ?? "");

  return (
    <div className="page-stack">
      {banner ? <div className="demo-banner">{banner}</div> : null}
      <PageHeader
        title="Today"
        description="Your main working page for daily interview preparation."
      />

      <section className="grid-two">
        <Card title="Today summary" eyebrow="Operational snapshot">
          <div className="stats-grid">
            <div className="stat-card">
              <p>Tasks today</p>
              <strong>{plan.summary.taskCount}</strong>
            </div>
            <div className="stat-card">
              <p>Completed</p>
              <strong>{plan.summary.completedCount}</strong>
            </div>
            <div className="stat-card">
              <p>Pending</p>
              <strong>{plan.summary.pendingCount}</strong>
            </div>
          </div>
        </Card>

        <Card title="Quick add task" eyebrow="V1 lightweight form">
          <form action={createTaskAction} className="form-grid">
            <label className="field-full">
              Title
              <input
                type="text"
                name="title"
                placeholder="Review 3 SQL locking questions"
              />
            </label>
            <label className="field">
              Type
              <select name="taskType" defaultValue="CATEGORY_PRACTICE">
                <option value="CATEGORY_PRACTICE">Category practice</option>
                <option value="FREEFORM">Freeform</option>
              </select>
            </label>
            <label className="field">
              Category
              <select name="categoryName" defaultValue={defaultCategoryName}>
                <option value="">None</option>
                {categoryNames.map((categoryName) => (
                  <option key={categoryName} value={categoryName}>
                    {categoryName}
                  </option>
                ))}
              </select>
            </label>
            <label className="field">
              Priority
              <select name="priority" defaultValue="3">
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
              </select>
            </label>
            <div className="field">
              <span>&nbsp;</span>
              <button type="submit" className="button-primary">
                Add Task
              </button>
            </div>
          </form>
        </Card>
      </section>

      <TaskList
        title="Pending Tasks"
        tasks={plan.pendingTasks}
        categoryNames={categoryNames}
        emptyTitle="No pending tasks"
        emptyDescription="Add your first task for today and keep the loop small."
      />

      <TaskList
        title="Completed Tasks"
        tasks={plan.completedTasks}
        categoryNames={categoryNames}
        emptyTitle="Nothing completed yet"
        emptyDescription="Completed items will show here to keep momentum visible."
      />
    </div>
  );
}
