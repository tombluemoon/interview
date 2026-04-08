import path from "node:path";

import { configDefaults, defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "node",
    exclude: [
      ...configDefaults.exclude,
      "tests/integration/**/*.test.ts",
      "tests/e2e/**/*.spec.ts",
    ],
    coverage: {
      provider: "v8",
      reporter: ["text"],
      include: ["lib/**/*.ts", "modules/**/*.ts"],
      exclude: ["**/*.d.ts", "lib/mock-data.ts"],
      thresholds: {
        statements: 100,
        branches: 100,
        functions: 100,
        lines: 100,
      },
    },
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "."),
    },
  },
});
