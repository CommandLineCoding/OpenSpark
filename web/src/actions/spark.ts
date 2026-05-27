"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/utils/supabase/server";

// Validation schema
const sparkSchema = z.object({
  title: z.string().min(5, "Title must be at least 5 characters").max(200),
  description_markdown: z.string().min(1, "Description is required"),
  tech_stack_raw: z.string().optional(), // raw comma-separated input
});

export async function createSpark(formData: FormData) {
  const supabase = await createClient();

  // 1. Check if user is logged in
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    throw new Error("You must be signed in to create a spark.");
  }

  // 2. Parse and validate input
  const raw = {
    title: formData.get("title") as string,
    description_markdown: formData.get("description_markdown") as string,
    tech_stack_raw: formData.get("tech_stack") as string,
  };

  const parsed = sparkSchema.safeParse(raw);
  if (!parsed.success) {
    // Return validation errors to the client (we'll handle in the form)
    return {
      errors: parsed.error.flatten().fieldErrors,
      success: false,
    };
  }

  // 3. Convert tech_stack_raw to array
  const tech_stack = parsed.data.tech_stack_raw
    ? parsed.data.tech_stack_raw
        .split(",")
        .map((t) => t.trim())
        .filter(Boolean)
    : [];

  // 4. Insert into database
  const { error } = await supabase.from("sparks").insert({
    author_id: user.id,
    title: parsed.data.title,
    description_markdown: parsed.data.description_markdown,
    tech_stack,
  });

  if (error) {
    console.error("Insert error:", error);
    return {
      errors: { server: ["Failed to create spark. Please try again."] },
      success: false,
    };
  }

  // 5. Revalidate the dashboard feed and redirect
  revalidatePath("/");
  redirect("/");
}