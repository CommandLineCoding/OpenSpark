"use client";

import { useFormStatus } from "react-dom";
import { useState } from "react";
import { createSpark } from "@/actions/spark";

function SubmitButton() {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="bg-accent text-bg font-mono px-6 py-3 rounded-bento hover:bg-accent/90 transition-colors disabled:opacity-50"
    >
      {pending ? "Igniting..." : "Ignite Spark"}
    </button>
  );
}

export default function SparkForm() {
  const [errors, setErrors] = useState<Record<string, string[]>>({});

  async function handleAction(formData: FormData) {
    const result = await createSpark(formData);
    if (result && !result.success && result.errors) {
      setErrors(result.errors);
    }
  }

  return (
    <form action={handleAction} className="space-y-6">
      <div>
        <label className="block font-mono text-foreground-primary mb-2">
          Title
        </label>
        <input
          type="text"
          name="title"
          required
          minLength={5}
          maxLength={200}
          placeholder="Your project idea..."
          className="w-full bg-bg border-[1.5px] border-border rounded-bento px-4 py-3 text-foreground-primary font-mono placeholder:text-foreground-muted focus:outline-none focus:border-accent transition-colors"
        />
        {errors.title && (
          <p className="text-red-400 text-sm mt-1">{errors.title[0]}</p>
        )}
      </div>

      <div>
        <label className="block font-mono text-foreground-primary mb-2">
          Description (Markdown)
        </label>
        <textarea
          name="description_markdown"
          required
          rows={6}
          placeholder="Describe your idea in Markdown..."
          className="w-full bg-bg border-[1.5px] border-border rounded-bento px-4 py-3 text-foreground-primary font-mono placeholder:text-foreground-muted focus:outline-none focus:border-accent transition-colors resize-y"
        />
        {errors.description_markdown && (
          <p className="text-red-400 text-sm mt-1">
            {errors.description_markdown[0]}
          </p>
        )}
      </div>

      <div>
        <label className="block font-mono text-foreground-primary mb-2">
          Tech Stack (comma-separated)
        </label>
        <input
          type="text"
          name="tech_stack"
          placeholder="react, next.js, supabase..."
          className="w-full bg-bg border-[1.5px] border-border rounded-bento px-4 py-3 text-foreground-primary font-mono placeholder:text-foreground-muted focus:outline-none focus:border-accent transition-colors"
        />
        <p className="text-foreground-muted text-xs mt-1">
          Optional. Separate tags with commas.
        </p>
      </div>

      {errors.server && (
        <p className="text-red-400 text-sm">{errors.server[0]}</p>
      )}

      <SubmitButton />
    </form>
  );
}