import Link from "next/link";

import { PageHeader } from "@/components/layout/PageHeader";
import { ScheduledTaskList } from "@/components/daily-plan/ScheduledTaskList";
import { TaskHistoryList } from "@/components/daily-plan/TaskHistoryList";
import { Card } from "@/components/ui/Card";
import { requireSession } from "@/lib/auth";
import {
  getPlanSectionMeta,
  getTomorrowPlan,
  listOverdueTasks,
  listRecentTaskHistory,
} from "@/modules/daily-plan/daily-plan.service";

export const dynamic = "force-dynamic";

interface PlansPageProps {
  searchParams: Promise<{
    task?: string;
    auth?: string;
    error?: string;
  }>;
}

function getPlansBanner(params: {
  task?: string;
  auth?: string;
  error?: string;
}) {
  if (params.auth === "login") {
    return "Logged in successfully.";
  }

  if (params.auth === "signup") {
    return "Account created successfully.";
  }

  if (params.task === "carried") {
    return "Task carried over to tomorrow.";
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

  if (params.error === "task") {
    return "Task action failed. Please try again.";
  }

  return null;
}

export default async function PlansPage({ searchParams }: PlansPageProps) {
  const params = await searchParams;
  const session = await requireSession();
  const tomorrowPlan = await getTomorrowPlan(session.user.id);
  const overdueTasks = await listOverdueTasks(session.user.id);
  const recentHistory = await listRecentTaskHistory(session.user.id);
  const banner = getPlansBanner(params);
  const meta = getPlanSectionMeta();

  return (
    <div className="page-stack">
      {banner ? <div className="demo-banner">{banner}</div> : null}
      <PageHeader
        title="Plans"
        description="Look ahead to tomorrow, clean up overdue work, and review recent task history."
        actions={
          <div className="button-row">
            <Link href="/app/today" className="button-secondary">
              Open Today
            </Link>
            <Link href="/questions" className="button-secondary">
              Browse Questions
            </Link>
          </div>
        }
      />

      <section className="stats-grid">
        <div className="stat-card">
          <p>Tomorrow</p>
          <strong>{tomorrowPlan.tasks.length}</strong>
        </div>
        <div className="stat-card">
          <p>Overdue</p>
          <strong>{overdueTasks.length}</strong>
        </div>
        <div className="stat-card">
          <p>Recent History</p>
          <strong>{recentHistory.length}</strong>
        </div>
        <div className="stat-card">
          <p>Next Plan Date</p>
          <strong>{meta.tomorrowLabel}</strong>
        </div>
      </section>

      <section className="grid-two">
        <Card title="Tomorrow" eyebrow={meta.tomorrowLabel}>
          <ScheduledTaskList
            tasks={tomorrowPlan.tasks.map((task) => ({
              ...task,
              planDate: tomorrowPlan.planDate,
            }))}
            emptyTitle="Nothing planned for tomorrow"
            emptyDescription="Carry over an unfinished task or add one tomorrow when you know the right focus."
          />
        </Card>

        <Card title="Overdue" eyebrow="Pending before today">
          <ScheduledTaskList
            tasks={overdueTasks}
            emptyTitle="No overdue tasks"
            emptyDescription="Your plan backlog is under control."
            allowCarryOver
          />
        </Card>
      </section>

      <Card title="Recent History" eyebrow="Latest completed and carried-over tasks">
        <TaskHistoryList
          tasks={recentHistory}
          emptyTitle="No task history yet"
          emptyDescription="Completed and carried-over tasks will start showing here once you build momentum."
        />
      </Card>
    </div>
  );
}
