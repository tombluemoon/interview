import { useState } from "react";

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

interface MarkdownToolbarProps {
  targetId: string;
}

function MarkdownToolbar({ targetId }: MarkdownToolbarProps) {
  const insertText = (before: string, after: string = "", placeholder: string = "") => {
    const textarea = document.getElementById(targetId) as HTMLTextAreaElement | null;
    if (!textarea) return;
    textarea.focus();
    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const selected = textarea.value.substring(start, end) || placeholder;
    const newText = textarea.value.substring(0, start) + before + selected + after + textarea.value.substring(end);
    textarea.value = newText;
    textarea.selectionStart = start + before.length;
    textarea.selectionEnd = start + before.length + selected.length;
    textarea.dispatchEvent(new Event("input", { bubbles: true }));
  };

  const btnClass = "qb-md-btn";

  return (
    <div className="qb-md-toolbar">
      <button type="button" className={btnClass} onClick={() => insertText("**", "**", "bold")} title="Bold">
        <strong>B</strong>
      </button>
      <button type="button" className={btnClass} onClick={() => insertText("*", "*", "italic")} title="Italic">
        <em>I</em>
      </button>
      <button type="button" className={btnClass} onClick={() => insertText("`", "`", "code")} title="Inline code">
        {"< >"}
      </button>
      <button type="button" className={btnClass} onClick={() => insertText("```\n", "\n```", "code block")} title="Code block">
        {"</>"}
      </button>
      <button type="button" className={btnClass} onClick={() => insertText("![", "](https://example.com/image.png)", "alt text")} title="Image">
        {"IMG"}
      </button>
      <button type="button" className={btnClass} onClick={() => insertText("[", "](https://example.com)", "link text")} title="Link">
        {"LINK"}
      </button>
      <button type="button" className={btnClass} onClick={() => insertText("- ", "", "list item")} title="Bullet list">
        {"•"}
      </button>
      <button type="button" className={btnClass} onClick={() => insertText("> ", "", "quote")} title="Blockquote">
        {">"}
      </button>
      <button type="button" className={btnClass} onClick={() => insertText("\n---\n")} title="Horizontal rule">
        {"—"}
      </button>
    </div>
  );
}

interface MarkdownEditorProps {
  name: string;
  defaultValue?: string;
  placeholder?: string;
  rows?: number;
  label: string;
  helpText?: string;
}

function MarkdownEditor({ name, defaultValue, placeholder, rows = 8, label, helpText }: MarkdownEditorProps) {
  const [preview, setPreview] = useState(false);
  const textareaId = `md-editor-${name}`;

  return (
    <div className="field-full qb-md-editor-field">
      <div className="qb-md-editor-header">
        <label htmlFor={textareaId}>{label}</label>
        <button
          type="button"
          className="qb-md-preview-btn"
          onClick={() => setPreview(!preview)}
        >
          {preview ? "Edit" : "Preview"}
        </button>
      </div>
      <MarkdownToolbar targetId={textareaId} />
      {helpText ? <p className="qb-md-help">{helpText}</p> : null}
      {preview ? (
        <div
          className="qb-md-content qb-md-preview"
          dangerouslySetInnerHTML={{
            __html: defaultValue
              ? defaultValue
                  .split("\n")
                  .map((line) => `<p class="qb-md-p">${line}</p>`)
                  .join("\n")
              : '<p class="qb-md-p" style="color: var(--muted)">Nothing to preview</p>',
          }}
        />
      ) : null}
      <textarea
        id={textareaId}
        rows={rows}
        name={name}
        defaultValue={defaultValue}
        placeholder={placeholder}
        className="qb-md-textarea"
      />
    </div>
  );
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

      <MarkdownEditor
        name="body"
        defaultValue={question?.body}
        placeholder="Write the interview question here. Supports markdown: **bold**, *italic*, ![image](url), etc."
        rows={6}
        label="Question Body"
        helpText="Supports markdown: headings, bold, italic, code blocks, images, lists, links."
      />

      <label className="field-full">
        Hint
        <textarea
          rows={3}
          name="hint"
          defaultValue={question?.hint}
          placeholder="Optional hint text."
        />
      </label>

      <MarkdownEditor
        name="referenceAnswer"
        defaultValue={question?.referenceAnswer}
        placeholder="Optional reference answer. Supports markdown: **bold**, *italic*, ![image](url), etc."
        rows={8}
        label="Reference Answer"
        helpText="Supports markdown: headings, bold, italic, code blocks, images, lists, links."
      />

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
