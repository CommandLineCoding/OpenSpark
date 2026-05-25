"use client";

import { useState, useEffect } from "react";
import { createClient } from "@/utils/supabase/client";
import type { Database } from "@/types/supabase";

type SparkRow = Database["public"]["Tables"]["sparks"]["Row"] & {
  profiles: { username: string; avatar_url: string | null };
};

export default function SparkCard({ spark }: { spark: SparkRow }) {
  const supabase = createClient();
  const [upvotes, setUpvotes] = useState(spark.upvotes);
  const [isVoted, setIsVoted] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const checkVote = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      const { data } = await supabase
        .from("votes")
        .select("*")
        .eq("user_id", user.id)
        .eq("spark_id", spark.id)
        .maybeSingle();
      setIsVoted(!!data);
    };
    checkVote();
  }, [spark.id]);

  const handleToggleVote = async () => {
    setIsLoading(true);
    if (isVoted) {
      setUpvotes(prev => prev - 1);
      setIsVoted(false);
    } else {
      setUpvotes(prev => prev + 1);
      setIsVoted(true);
    }

    const { error } = await supabase.rpc("toggle_vote", {
      p_spark_id: spark.id,
    });

    if (error) {
      setIsVoted(!isVoted);
      setUpvotes(spark.upvotes);
    }
    setIsLoading(false);
  };

  return (
    <div className="bg-surface border-[1.5px] border-border rounded-bento p-6 shadow-md hover:shadow-accent/20 hover:border-accent/50 transition-all duration-200">
      {/* Author row */}
      <div className="flex items-center gap-3 mb-4">
        {spark.profiles.avatar_url && (
          <img
            src={spark.profiles.avatar_url}
            alt=""
            className="w-8 h-8 rounded-full border-[1.5px] border-border"
          />
        )}
        <div className="flex flex-col">
          <span className="text-foreground-muted text-sm font-mono">
            @{spark.profiles.username}
          </span>
          <span className="text-foreground-muted text-xs">
            {new Date(spark.created_at).toLocaleDateString("en-US", {
              month: "short",
              day: "numeric",
              year: "numeric",
            })}
          </span>
        </div>
      </div>

      <h3 className="text-xl font-mono text-foreground-primary mb-2">
        {spark.title}
      </h3>

      <p className="text-foreground-muted text-sm line-clamp-2 mb-4">
        {spark.description_markdown.replace(/[#*`>\[\]!]/g, "").slice(0, 200)}
      </p>

      {spark.tech_stack && spark.tech_stack.length > 0 && (
        <div className="flex flex-wrap gap-2 mb-4">
          {spark.tech_stack.map(tech => (
            <span
              key={tech}
              className="bg-bg border-[1.5px] border-border rounded-md px-2 py-0.5 text-xs font-mono text-accent"
            >
              {tech}
            </span>
          ))}
        </div>
      )}

      <div className="flex items-center justify-between">
        <button
          onClick={handleToggleVote}
          disabled={isLoading}
          className={`flex items-center gap-1.5 font-mono text-sm transition-colors ${
            isVoted
              ? "text-accent hover:text-foreground-primary"
              : "text-foreground-muted hover:text-accent"
          }`}
        >
          <span className={`text-lg leading-none ${isVoted ? "text-accent" : ""}`}>
            ▲
          </span>
          <span>{upvotes}</span>
        </button>
        <span className="text-[10px] font-mono text-foreground-muted uppercase bg-bg px-2 py-0.5 rounded border-[1.5px] border-border">
          {spark.status}
        </span>
      </div>
    </div>
  );
}