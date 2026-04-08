import { PageHeader } from "@/components/layout/PageHeader";
import { StatCard } from "@/components/reports/StatCard";
import { Card } from "@/components/ui/Card";
import { requireSession } from "@/lib/auth";
import { listCategories } from "@/modules/question-bank/question-bank.service";
import {
  getBacklogReport,
  getCategoryProgressReport,
  getDailyTrendReport,
  getOverviewReport,
} from "@/modules/reports/reports.service";
import {
  getReportRangeLabel,
  getReportSummaryLabel,
  parseReportFilters,
  reportRangeOptions,
} from "@/modules/reports/reports.validation";

export const dynamic = "force-dynamic";

interface ReportsPageProps {
  searchParams: Promise<{
    range?: string;
    category?: string;
  }>;
}

export default async function ReportsPage({ searchParams }: ReportsPageProps) {
  const params = await searchParams;
  const session = await requireSession();
  const categories = await listCategories();
  const filters = parseReportFilters(
    params,
    categories.map((category) => category.id),
  );
  const selectedCategory = categories.find(
    (category) => category.id === filters.categoryId,
  );
  const reportFilters = {
    rangeDays: filters.rangeDays,
    categoryId: selectedCategory?.id,
    categoryName: selectedCategory?.name,
  };
  const [overview, trend, progress, backlog] = await Promise.all([
    getOverviewReport(session.user.id, reportFilters),
    getDailyTrendReport(session.user.id, reportFilters),
    getCategoryProgressReport(session.user.id, reportFilters),
    getBacklogReport(session.user.id, reportFilters),
  ]);

  return (
    <div className="page-stack">
      <PageHeader
        title="Reports"
        description="Keep reporting simple: summary, trend, category coverage, and backlog."
        actions={
          <form action="/app/reports" className="filter-row report-filter-form">
            <label className="field">
              Period
              <select name="range" defaultValue={filters.range}>
                {reportRangeOptions.map((option) => (
                  <option key={option.value} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </label>
            <label className="field">
              Category
              <select name="category" defaultValue={filters.categoryId ?? ""}>
                <option value="">All categories</option>
                {categories.map((category) => (
                  <option key={category.id} value={category.id}>
                    {category.name}
                  </option>
                ))}
              </select>
            </label>
            <button type="submit" className="button-secondary">
              Apply Filters
            </button>
          </form>
        }
      />

      <section className="stats-grid">
        <StatCard
          label={getReportSummaryLabel(filters.range)}
          value={overview.tasksCompletedInRange}
        />
        <StatCard label="Reviewed" value={overview.reviewedQuestions} />
        <StatCard label="Mastered" value={overview.masteredQuestions} />
        <StatCard label="Current Streak" value={`${overview.currentStreak} days`} />
      </section>

      <section className="reports-grid">
        <Card
          title="Daily trend"
          eyebrow={`${getReportRangeLabel(filters.range)} completion view${
            selectedCategory ? ` for ${selectedCategory.name}` : ""
          }`}
          className="chart-card"
        >
          <div className="mini-bars">
            {trend.map((point) => (
              <div key={point.label} className="mini-bar">
                <div
                  className="mini-bar-fill"
                  style={{ height: `${Math.max(point.value * 24, 24)}px` }}
                />
                <span className="mini-bar-label">{point.label}</span>
              </div>
            ))}
          </div>
        </Card>

        <Card
          title="Category progress"
          eyebrow={
            selectedCategory
              ? `Reviewed vs total for ${selectedCategory.name}`
              : "Reviewed vs total"
          }
          className="chart-card"
        >
          <div className="progress-list">
            {progress.map((entry) => {
              const percentage = Math.round(
                (entry.reviewedCount / entry.totalCount) * 100,
              );

              return (
                <div key={entry.categoryName} className="progress-row">
                  <span>{entry.categoryName}</span>
                  <div className="progress-track">
                    <div
                      className="progress-fill"
                      style={{ width: `${percentage}%` }}
                    />
                  </div>
                  <span>{percentage}%</span>
                </div>
              );
            })}
          </div>
        </Card>

        <Card
          title="Backlog"
          eyebrow={
            selectedCategory
              ? `Where to intervene next in ${selectedCategory.name}`
              : "Where to intervene next"
          }
          className="chart-card"
        >
          <div className="backlog-list">
            {backlog.map((item) => (
              <div key={item.id} className="backlog-item">
                <h3>{item.title}</h3>
                <p>{item.detail}</p>
              </div>
            ))}
          </div>
        </Card>
      </section>
    </div>
  );
}
