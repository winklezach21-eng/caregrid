import type { ReactNode } from "react";
import "./globals.css";

export const metadata = { title: "CareGrid Management", description: "CareGrid staffing management dashboard" };

export default function RootLayout({ children }: { children: ReactNode }) {
  return <html lang="en"><body>{children}</body></html>;
}
