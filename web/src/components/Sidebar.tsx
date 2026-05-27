import { createClient } from "@/utils/supabase/server";
import Link from "next/link";
import SignOutButton from "./SignOutButton";
import LoginButton from "./LoginButton";

export default async function Sidebar() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <aside className="w-[280px] min-h-screen bg-surface border-r-[1.5px] border-border flex flex-col p-6 shrink-0">
      <Link href="/" className="font-mono text-2xl text-foreground-primary hover:text-accent transition-colors mb-8">
        OpenSpark <span className="text-accent">▲</span>
      </Link>

      <div className="flex-1">
        {user ? (
          <div className="flex items-center gap-3 mb-6">
            <img
              src={user.user_metadata.avatar_url}
              alt=""
              className="w-10 h-10 rounded-full border-[1.5px] border-border"
            />
            <div className="overflow-hidden">
              <p className="text-foreground-primary font-mono text-sm truncate">
                {user.user_metadata.full_name ?? user.user_metadata.user_name}
              </p>
              <p className="text-foreground-muted text-xs font-mono truncate">
                @{user.user_metadata.preferred_username ?? user.user_metadata.user_name}
              </p>
            </div>
          </div>
        ) : (
          <div className="mb-6">
            <LoginButton />
          </div>
        )}

        <nav className="space-y-2">
          <Link
            href="/"
            className="block px-3 py-2 rounded-lg text-foreground-primary font-mono hover:bg-bg transition-colors"
          >
            ▲ Sparks
          </Link>
          {user && (
            <Link
              href="/create"
              className="block px-3 py-2 rounded-lg font-mono bg-accent/10 text-accent hover:bg-accent/20 transition-colors"
            >
              + New Spark
            </Link>
          )}
        </nav>
      </div>

      {user && (
        <div className="mt-auto border-t-[1.5px] border-border pt-4">
          <div className="flex items-center justify-between gap-2">
            <span className="text-foreground-muted text-xs font-mono truncate">
              {user.email}
            </span>
            <SignOutButton />
          </div>
        </div>
      )}
    </aside>
  );
}