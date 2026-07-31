-- ============================================================
-- KADO Personal — Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New query → Run
-- All tables use kp_ prefix and are locked to your user account only.
-- ============================================================

-- TASKS (personal errands, church, family, health etc.)
create table if not exists public.kp_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  text text not null,
  category text not null default 'errands',
  done boolean not null default false,
  created_at timestamptz not null default now()
);
alter table public.kp_tasks enable row level security;
drop policy if exists "kp_tasks_own" on public.kp_tasks;
create policy "kp_tasks_own" on public.kp_tasks for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- FINANCES (salary, studio income, rent, food, transport, everything personal)
create table if not exists public.kp_finances (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  description text not null,
  amount numeric not null,
  type text not null check (type in ('income', 'expense')),
  category text,
  date date not null default current_date,
  created_at timestamptz not null default now()
);
alter table public.kp_finances enable row level security;
drop policy if exists "kp_finances_own" on public.kp_finances;
create policy "kp_finances_own" on public.kp_finances for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- REMINDERS / ALARMS
create table if not exists public.kp_reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  time text not null,
  text text not null,
  fired boolean not null default false,
  created_at timestamptz not null default now()
);
alter table public.kp_reminders enable row level security;
drop policy if exists "kp_reminders_own" on public.kp_reminders;
create policy "kp_reminders_own" on public.kp_reminders for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- NOTES & JOURNAL
create table if not exists public.kp_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  title text,
  body text,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
alter table public.kp_notes enable row level security;
drop policy if exists "kp_notes_own" on public.kp_notes;
create policy "kp_notes_own" on public.kp_notes for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ============================================================
-- Done. All tables locked to your account via Row Level Security.
-- Planner, life balance sliders, and custom schedule are saved
-- locally in your browser (localStorage) — no extra tables needed.
-- ============================================================
