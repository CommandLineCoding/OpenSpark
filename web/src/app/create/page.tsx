import { createClient } from "@/utils/supabase/server";
import { redirect } from "next/navigation";
import SparkForm from "@/components/SparkForm";
import Link from "next/link";

export default async function CreateSparkPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    redirect("/?error=unauthorized");
  }

  return (
    <div className="flex min-h-screen">
      <aside className="w-[280px] bg-surface border-r-[1.5px] border-border p-6 shrink-0 flex flex-col">
        <Link href="/" className="font-mono text-2xl text-foreground-primary hover:text-accent mb-8">
          OpenSpark <span className="text-accent">▲</span>
        </Link>
        <div className="flex-1">
          <Link href="/" className="text-foreground-muted font-mono text-sm hover:text-foreground-primary transition-colors">
            ← Back to feed
          </Link>
        </div>
        <div className="mt-auto border-t-[1.5px] border-border pt-4">
          <div className="flex items-center gap-2">
            <img
              src={user.user_metadata.avatar_url}
              alt=""
              className="w-8 h-8 rounded-full border-[1.5px] border-border"
            />
            <span className="text-foreground-muted text-xs font-mono">
              {user.user_metadata.user_name ?? user.user_metadata.preferred_username}
            </span>
          </div>
        </div>
      </aside>

      <main className="flex-1 p-8 flex items-start justify-center">
        <div className="w-full max-w-2xl bg-surface border-[1.5px] border-border rounded-bento p-8 shadow-lg">
          <h2 className="text-2xl font-mono text-foreground-primary mb-8">
            Create a New Spark
          </h2>
          <SparkForm />
        </div>
      </main>
    </div>
  );
}