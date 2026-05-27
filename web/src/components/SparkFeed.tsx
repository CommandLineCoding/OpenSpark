import { createClient } from "@/utils/supabase/server";
import SparkCard from "./SparkCard";

export default async function SparkFeed() {
  const supabase = await createClient();

  const { data: sparks, error } = await supabase
    .from("sparks")
    .select("*, profiles!sparks_author_id_fkey(username, avatar_url)")
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Supabase query error:", error);
    return (
      <div className="bg-surface border-[1.5px] border-border rounded-bento p-8 text-center">
        <p className="text-foreground-muted font-mono">
          Error loading sparks. Check terminal logs.
        </p>
      </div>
    );
  }

  if (!sparks || sparks.length === 0) {
    return (
      <div className="bg-surface border-[1.5px] border-border rounded-bento p-8 text-center">
        <p className="text-foreground-muted font-mono">
          No sparks yet. Be the first to ignite one!
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {sparks.map(spark => (
        <SparkCard key={spark.id} spark={spark} />
      ))}
    </div>
  );
}