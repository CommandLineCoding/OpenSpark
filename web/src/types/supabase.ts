export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          username: string
          github_url: string | null
          avatar_url: string | null
          spark_points: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          username: string
          github_url?: string | null
          avatar_url?: string | null
          spark_points?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          username?: string
          github_url?: string | null
          avatar_url?: string | null
          spark_points?: number
          created_at?: string
          updated_at?: string
        }
      }
      sparks: {
        Row: {
          id: string
          author_id: string
          title: string
          description_markdown: string
          tech_stack: string[]
          status: 'seed' | 'sprout' | 'ignited'
          upvotes: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          author_id: string
          title: string
          description_markdown: string
          tech_stack?: string[]
          status?: 'seed' | 'sprout' | 'ignited'
          upvotes?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          author_id?: string
          title?: string
          description_markdown?: string
          tech_stack?: string[]
          status?: 'seed' | 'sprout' | 'ignited'
          upvotes?: number
          created_at?: string
          updated_at?: string
        }
      }
      votes: {
        Row: {
          user_id: string
          spark_id: string
          created_at: string
        }
        Insert: {
          user_id: string
          spark_id: string
          created_at?: string
        }
        Update: {
          user_id?: string
          spark_id?: string
          created_at?: string
        }
      }
    }
    Views: {}
    Functions: {
      toggle_vote: {
        Args: {
          p_spark_id: string
        }
        Returns: void
      }
    }
    Enums: {}
    CompositeTypes: {}
  }
}