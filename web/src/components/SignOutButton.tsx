"use client";

import { createClient } from "@/utils/supabase/client";

export default function SignOutButton() {
  const supabase = createClient();

  return (
    <button
      onClick={() => supabase.auth.signOut()}
      className="bg-surface border-[1.5px] border-border rounded-lg px-3 py-1 text-sm text-foreground-muted hover:border-red-500 hover:text-red-400 transition-colors"
    >
      Sign out
    </button>
  );
}