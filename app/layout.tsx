import type { Metadata } from "next";

import "./globals.css";

export const metadata: Metadata = {
  title: "Interview Review",
  description: "A simplified interview preparation workspace built for V1.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        <div className="root-shell">{children}</div>
      </body>
    </html>
  );
}
