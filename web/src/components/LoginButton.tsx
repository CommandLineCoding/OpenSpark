"use client";

import { createClient } from "@/utils/supabase/client";

export default function LoginButton() {
  const supabase = createClient();

  const handleLogin = async () => {
    await supabase.auth.signInWithOAuth({
      provider: "github",
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
      },
    });
  };

  return (
    <button
      onClick={handleLogin}
      className="w-full bg-surface border-[1.5px] border-border rounded-bento px-4 py-2 font-mono text-foreground-primary hover:border-accent hover:text-accent transition-all"
    >
      Sign in with GitHub
    </button>
  );
}