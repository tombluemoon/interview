import type {
  Difficulty,
  QuestionContentStatus,
  QuestionVisibility,
} from "@/types/domain";

import { joinCommaSeparatedList } from "@/modules/admin/admin.helpers";

interface CategoryOption {
  id: string;
  name: string;
}

interface QuestionEditorFormValues {
  id?: string;
  title?: string;
  slug?: string;
  categoryId?: string;
  difficulty?: Difficulty;
  tags?: string[];
  excerpt?: string;
  body?: string;
  hint?: string;
  referenceAnswer?: string;
  relatedSlugs?: string[];
  visibility?: QuestionVisibility;
  contentStatus?: QuestionContentStatus;
}

interface QuestionEditorFormProps {
  action: (formData: FormData) => Promise<void>;
  categories: CategoryOption[];
  question?: QuestionEditorFormValues;
  mode: "create" | "edit";
  returnTo?: string;
}

export function QuestionEditorForm({
  action,
  categories,
  question,
  mode,
  returnTo,
}: QuestionEditorFormProps) {
  return (
    <form action={action} className="form-grid">
      {question?.id ? <input type="hidden" name="questionId" value={question.id} /> : null}
      {returnTo ? <input type="hidden" name="returnTo" value={returnTo} /> : null}

      <label className="field-full">
        Title
        <input
          type="text"
          name="title"
          defaultValue={question?.title}
          placeholder="How would you implement an O(1) LRU cache?"
        />
      </label>

      <label className="field">
        Slug
        <input
          type="text"
          name="slug"
          defaultValue={question?.slug}
          placeholder="Leave blank to auto-generate"
        />
      </label>

      <label className="field">
        Category
        <select name="categoryId" defaultValue={question?.categoryId ?? categories[0]?.id}>
          {categories.map((category) => (
            <option key={category.id} value={category.id}>
              {category.name}
            </option>
          ))}
        </select>
      </label>

      <label className="field">
        Difficulty
        <select name="difficulty" defaultValue={question?.difficulty ?? "Medium"}>
          <option value="Easy">Easy</option>
          <option value="Medium">Medium</option>
          <option value="Hard">Hard</option>
        </select>
      </label>

      <label className="field">
        Visibility
        <select name="visibility" defaultValue={question?.visibility ?? "PUBLIC"}>
          <option value="PUBLIC">Public</option>
          <option value="PRIVATE">Private</option>
        </select>
      </label>

      <label className="field-full">
        Tags
        <input
          type="text"
          name="tags"
          defaultValue={joinCommaSeparatedList(question?.tags ?? [])}
          placeholder="hashmap, linked-list, design"
        />
      </label>

      <label className="field-full">
        Excerpt
        <textarea
          rows={3}
          name="excerpt"
          defaultValue={question?.excerpt}
          placeholder="Short summary shown in the question bank list."
        />
      </label>

      <label className="field-full">
        Question Body
        <textarea
          rows={6}
          name="body"
          defaultValue={question?.body}
          placeholder="Write the interview question here."
        />
      </label>

      <label className="field-full">
        Hint
        <textarea
          rows={3}
          name="hint"
          defaultValue={question?.hint}
          placeholder="Optional hint text."
        />
      </label>

      <label className="field-full">
        Reference Answer
        <textarea
          rows={5}
          name="referenceAnswer"
          defaultValue={question?.referenceAnswer}
          placeholder="Optional reference answer."
        />
      </label>

      <label className="field-full">
        Related Slugs
        <input
          type="text"
          name="relatedSlugs"
          defaultValue={joinCommaSeparatedList(question?.relatedSlugs ?? [])}
          placeholder="rate-limiter, mvcc-explained"
        />
      </label>

      <div className="field-full button-row">
        <button type="submit" name="intent" value="draft" className="button-secondary">
          Save Draft
        </button>
        <button type="submit" name="intent" value="publish" className="button-primary">
          Publish
        </button>
        {mode === "edit" ? (
          <button
            type="submit"
            name="intent"
            value="archive"
            className="button-secondary"
          >
            Archive
          </button>
        ) : null}
      </div>
    </form>
  );
}
