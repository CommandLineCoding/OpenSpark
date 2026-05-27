import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "OpenSpark",
  description: "Collaborative Open-Source Blueprinting Engine",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-bg text-foreground-primary antialiased">
        {children}
      </body>
    </html>
  );
}