import { expect, test } from "@playwright/test";

test("admin can log in and create a category from the browser", async ({
  page,
}) => {
  const suffix = Date.now();
  const categoryName = `Behavioral ${suffix}`;
  const categorySlug = `behavioral-${suffix}`;

  await page.goto(`/login?next=${encodeURIComponent("/admin/categories")}`);

  await page.getByLabel("Email").fill("admin@example.com");
  await page.getByLabel("Password").fill("admin1234");
  await page.getByRole("button", { name: "Log In" }).click();

  await expect(page).toHaveURL(/\/admin\/categories\?auth=login$/);
  await expect(
    page.getByRole("heading", { name: "Categories", exact: true, level: 1 }),
  ).toBeVisible();

  const createCategoryForm = page.locator("form").filter({
    has: page.getByRole("button", { name: "Save Category" }),
  });

  await createCategoryForm.locator('input[name="name"]').fill(categoryName);
  await createCategoryForm.locator('input[name="slug"]').fill(categorySlug);
  await createCategoryForm
    .locator('textarea[name="description"]')
    .fill("Browser-created category for Playwright coverage.");
  await createCategoryForm.getByRole("button", { name: "Save Category" }).click();

  await expect(page).toHaveURL(/\/admin\/categories\?saved=created$/);
  await expect(page.getByText("Category created.")).toBeVisible();
  await expect(page.getByRole("heading", { name: categoryName })).toBeVisible();
  await expect(page.getByText(categorySlug)).toBeVisible();
});
