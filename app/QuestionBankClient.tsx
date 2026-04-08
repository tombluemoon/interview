"use client";

import { useState, useCallback, useEffect } from "react";
import { Category, Question } from "@/types/domain";
import { renderMarkdown } from "@/lib/render-markdown";

interface QuestionBankProps {
  categories: Category[];
  questions: Question[];
}

const ORDER_KEY = "interview-review-category-order";
const EXPANDED_KEY = "interview-review-expanded-categories";
const SELECTED_KEY = "interview-review-selected-question";

function loadFromStorage<T>(key: string, fallback: T): T {
  try {
    const stored = localStorage.getItem(key);
    if (stored) {
      return JSON.parse(stored);
    }
  } catch {
    // ignore
  }
  return fallback;
}

function saveToStorage(key: string, value: unknown) {
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch {
    // ignore
  }
}

export default function QuestionBankClient({ categories, questions }: QuestionBankProps) {
  const [categoryOrder, setCategoryOrder] = useState<string[]>(() => categories.map((c) => c.id));
  const [expandedIds, setExpandedIds] = useState<string[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [draggedId, setDraggedId] = useState<string | null>(null);
  const [isHydrated, setIsHydrated] = useState(false);

  // Restore state from localStorage after hydration
  useEffect(() => {
    // Restore category order
    const savedOrder = loadFromStorage<string[] | null>(ORDER_KEY, null);
    if (savedOrder) {
      const savedIds = new Set(savedOrder);
      const allIds = categories.map((c) => c.id);
      const merged = [...savedOrder.filter((id) => allIds.includes(id))];
      for (const id of allIds) {
        if (!savedIds.has(id)) {
          merged.push(id);
        }
      }
      setCategoryOrder(merged);
    }

    // Restore selected question
    const savedSelected = loadFromStorage<string | null>(SELECTED_KEY, null);
    let restoredSelectedId: string | null = null;
    if (savedSelected) {
      const exists = questions.some((q) => q.id === savedSelected);
      if (exists) {
        restoredSelectedId = savedSelected;
      }
    }

    // Restore expanded categories
    const savedExpanded = loadFromStorage<string[] | null>(EXPANDED_KEY, null);
    if (savedExpanded) {
      const allIds = new Set(categories.map((c) => c.id));
      const restoredExpanded = savedExpanded.filter((id) => allIds.has(id));
      // If a question is selected, ensure its category is expanded
      if (restoredSelectedId) {
        const selectedQuestion = questions.find((q) => q.id === restoredSelectedId);
        if (selectedQuestion && !restoredExpanded.includes(selectedQuestion.categoryId)) {
          restoredExpanded.push(selectedQuestion.categoryId);
        }
      }
      setExpandedIds(restoredExpanded);
    } else {
      // Default: all expanded
      setExpandedIds(categories.map((c) => c.id));
    }

    setSelectedId(restoredSelectedId);
    setIsHydrated(true);
  }, [categories, questions]);

  // Persist state changes
  useEffect(() => {
    if (isHydrated) {
      saveToStorage(ORDER_KEY, categoryOrder);
    }
  }, [categoryOrder, isHydrated]);

  useEffect(() => {
    if (isHydrated) {
      saveToStorage(EXPANDED_KEY, expandedIds);
    }
  }, [expandedIds, isHydrated]);

  useEffect(() => {
    if (isHydrated) {
      saveToStorage(SELECTED_KEY, selectedId);
    }
  }, [selectedId, isHydrated]);

  const toggleCategory = useCallback((categoryId: string) => {
    setExpandedIds((prev) => {
      if (prev.includes(categoryId)) {
        return prev.filter((id) => id !== categoryId);
      }
      return [...prev, categoryId];
    });
  }, []);

  const expandAll = useCallback(() => {
    setExpandedIds(categories.map((c) => c.id));
  }, [categories]);

  const collapseAll = useCallback(() => {
    setExpandedIds([]);
  }, []);

  const selectQuestion = useCallback((questionId: string) => {
    setSelectedId(questionId);
  }, []);

  const handleDragStart = useCallback((e: React.DragEvent<HTMLDivElement>, categoryId: string) => {
    setDraggedId(categoryId);
    e.dataTransfer.effectAllowed = "move";
    (e.target as HTMLElement).classList.add("qb-dragging");
  }, []);

  const handleDragOver = useCallback((e: React.DragEvent, targetId: string) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = "move";
    if (draggedId && draggedId !== targetId) {
      setCategoryOrder((prev) => {
        const newOrder = [...prev];
        const draggedIndex = newOrder.indexOf(draggedId);
        const targetIndex = newOrder.indexOf(targetId);
        if (draggedIndex === -1 || targetIndex === -1) return prev;
        newOrder.splice(draggedIndex, 1);
        const newTargetIndex = newOrder.indexOf(targetId);
        newOrder.splice(newTargetIndex, 0, draggedId);
        return newOrder;
      });
    }
  }, [draggedId]);

  const handleDrop = useCallback((e: React.DragEvent, targetId: string) => {
    e.preventDefault();
    if (draggedId && draggedId !== targetId) {
      setCategoryOrder((prev) => {
        const newOrder = [...prev];
        const draggedIndex = newOrder.indexOf(draggedId);
        const targetIndex = newOrder.indexOf(targetId);
        if (draggedIndex === -1 || targetIndex === -1) return prev;
        newOrder.splice(draggedIndex, 1);
        const newTargetIndex = newOrder.indexOf(targetId);
        newOrder.splice(newTargetIndex, 0, draggedId);
        return newOrder;
      });
    }
    setDraggedId(null);
  }, [draggedId]);

  const handleDragEnd = useCallback((e: React.DragEvent) => {
    setDraggedId(null);
    (e.target as HTMLElement).classList.remove("qb-dragging");
  }, []);

  const categoryMap = new Map(categories.map((c) => [c.id, c]));
  const questionsByCategory = new Map<string, Question[]>();
  for (const q of questions) {
    if (!questionsByCategory.has(q.categoryId)) {
      questionsByCategory.set(q.categoryId, []);
    }
    questionsByCategory.get(q.categoryId)!.push(q);
  }

  const selectedQuestion = questions.find((q) => q.id === selectedId) || null;

  // Get sorted categories based on saved order
  const sortedCategories = categoryOrder
    .map((id) => categoryMap.get(id))
    .filter((c): c is Category => c !== undefined);

  return (
    <div className="qb-shell">
      <aside className="qb-sidebar">
        <div className="qb-sidebar-header">
          <span>{questions.length} questions</span>
          <div className="qb-expand-controls">
            <button type="button" onClick={expandAll} className="qb-small-btn">Expand All</button>
            <button type="button" onClick={collapseAll} className="qb-small-btn">Collapse</button>
          </div>
        </div>
        <div className="qb-category-tree">
          {sortedCategories.map((category) => {
            const catQuestions = (questionsByCategory.get(category.id) || []).sort((a, b) =>
              a.title.localeCompare(b.title)
            );
            const isExpanded = expandedIds.includes(category.id);
            const isDragging = draggedId === category.id;

            // Check if any question in this category is selected
            const hasSelectedQuestion = selectedId && catQuestions.some((q) => q.id === selectedId);

            return (
              <div
                key={category.id}
                data-category-id={category.id}
                className={`qb-category${isDragging ? " qb-dragging" : ""}${hasSelectedQuestion ? " qb-category-active" : ""}`}
                draggable
                onDragStart={(e) => handleDragStart(e, category.id)}
                onDragOver={(e) => handleDragOver(e, category.id)}
                onDrop={(e) => handleDrop(e, category.id)}
                onDragEnd={handleDragEnd}
              >
                <div
                  className="qb-category-header"
                  onClick={() => toggleCategory(category.id)}
                >
                  <span className="qb-drag-handle" title="Drag to reorder">⋮⋮</span>
                  <span className="qb-chevron">{isExpanded ? "▾" : "▸"}</span>
                  <span className="qb-category-name">{category.name}</span>
                  <span className="qb-count">{catQuestions.length}</span>
                </div>
                {isExpanded && (
                  <div className="qb-question-list">
                    {catQuestions.map((q) => (
                      <div
                        key={q.id}
                        className={`qb-question-item${selectedId === q.id ? " qb-active" : ""}`}
                        onClick={() => selectQuestion(q.id)}
                      >
                        {q.title}
                      </div>
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </aside>
      <main className="qb-detail">
        {selectedQuestion ? (
          <article className="qb-detail-content">
            <div className="qb-detail-header">
              <span className="qb-detail-category">{categoryMap.get(selectedQuestion.categoryId)?.name}</span>
              <span className={`qb-detail-difficulty qb-difficulty-${selectedQuestion.difficulty.toLowerCase()}`}>
                {selectedQuestion.difficulty}
              </span>
            </div>
            <h1 className="qb-detail-title">{selectedQuestion.title}</h1>
            {selectedQuestion.tags.length > 0 && (
              <div className="qb-detail-tags">
                {selectedQuestion.tags.map((tag) => (
                  <span key={tag} className="qb-tag">{tag}</span>
                ))}
              </div>
            )}
            {selectedQuestion.body && (
              <div className="qb-detail-body">
                <div
                  className="qb-md-content"
                  dangerouslySetInnerHTML={{ __html: renderMarkdown(selectedQuestion.body) }}
                />
              </div>
            )}
            {selectedQuestion.referenceAnswer && (
              <div className="qb-detail-answer">
                <h3>Reference Answer</h3>
                <div
                  className="qb-md-content"
                  dangerouslySetInnerHTML={{ __html: renderMarkdown(selectedQuestion.referenceAnswer) }}
                />
              </div>
            )}
          </article>
        ) : (
          <div className="qb-empty-state">
            <p>Select a question from the left panel to view details.</p>
          </div>
        )}
      </main>
    </div>
  );
}
