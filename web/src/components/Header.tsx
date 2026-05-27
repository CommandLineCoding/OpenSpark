// src/components/Header.tsx
import { createClient } from "@/utils/supabase/server";
import SignOutButton from "./SignOutButton";
import Link from "next/link";

export default async function Header() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <header className="border-b border-border bg-surface/80 backdrop-blur">
      <div className="max-w-6xl mx-auto px-6 py-3 flex items-center justify-between">
        <Link href="/" className="font-mono text-xl text-foreground-primary hover:text-accent">
          OpenSpark <span className="text-accent">▲</span>
        </Link>

        {user ? (
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2">
              <img
                src={user.user_metadata.avatar_url}
                alt=""
                className="w-8 h-8 rounded-full border border-border"
              />
              <span className="text-foreground-primary text-sm font-mono">
                {user.user_metadata.user_name ?? user.user_metadata.preferred_username}
              </span>
            </div>
            <SignOutButton />
          </div>
        ) : (
          <span className="text-foreground-muted text-sm">Not signed in</span>
        )}
      </div>
    </header>
  );
}