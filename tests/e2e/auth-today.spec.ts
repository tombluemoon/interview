import { expect, test } from "@playwright/test";

test("user can log in, create a task, and complete it", async ({ page }) => {
  const taskTitle = `Playwright task ${Date.now()}`;

  await page.goto("/login");

  await page.getByLabel("Email").fill("alex@example.com");
  await page.getByLabel("Password").fill("demo1234");
  await page.getByRole("button", { name: "Log In" }).click();

  await expect(page).toHaveURL(/\/app\/today\?auth=login$/);
  await expect(page.getByText("Logged in successfully.")).toBeVisible();

  const quickAddForm = page.locator("form").filter({
    has: page.getByRole("button", { name: "Add Task" }),
  });

  await quickAddForm.locator('input[name="title"]').fill(taskTitle);
  await quickAddForm.locator('select[name="taskType"]').selectOption("FREEFORM");
  await quickAddForm.locator('select[name="categoryName"]').selectOption("AI");
  await quickAddForm.locator('select[name="priority"]').selectOption("5");
  await quickAddForm.getByRole("button", { name: "Add Task" }).click();

  await expect(page).toHaveURL(/\/app\/today\?task=created$/);
  await expect(
    page.getByText("Task created and saved to PostgreSQL."),
  ).toBeVisible();

  const pendingSection = page.locator("section").filter({
    has: page.getByRole("heading", { name: "Pending Tasks" }),
  });
  const taskItem = pendingSection.locator("li.task-item").filter({
    has: page.getByRole("heading", { name: taskTitle }),
  });

  await expect(taskItem).toBeVisible();
  await taskItem.getByRole("button", { name: "Complete" }).click();

  await expect(page).toHaveURL(/\/app\/today\?task=completed$/);
  await expect(page.getByText("Task marked completed.")).toBeVisible();

  const completedSection = page.locator("section").filter({
    has: page.getByRole("heading", { name: "Completed Tasks" }),
  });

  await expect(
    completedSection.getByRole("heading", { name: taskTitle }),
  ).toBeVisible();
});
