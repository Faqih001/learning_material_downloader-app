-- SQL for Supabase SQL Editor: Create a table to store chatbot messages
create table if not exists chatbot_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  role text not null check (role in ('user', 'ai')),
  content text not null,
  created_at timestamptz not null default now()
);

-- Index for faster queries by user
create index if not exists idx_chatbot_messages_user_id on chatbot_messages(user_id);

-- Index for ordering by time
create index if not exists idx_chatbot_messages_created_at on chatbot_messages(created_at);
