import type { ReactNode } from "react";

interface CardProps {
  title?: string;
  eyebrow?: string;
  children: ReactNode;
  className?: string;
}

export function Card({ title, eyebrow, children, className }: CardProps) {
  return (
    <section className={`card${className ? ` ${className}` : ""}`}>
      {eyebrow ? <p className="card-eyebrow">{eyebrow}</p> : null}
      {title ? <h3 className="card-title">{title}</h3> : null}
      {children}
    </section>
  );
}
