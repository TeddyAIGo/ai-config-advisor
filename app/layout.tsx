import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "AI//CONFIG — What AI do you actually need?",
  description: "Independent AI hardware advice. Find your Cloud, Hybrid, or Local configuration.",
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
