-- Run this in your Supabase SQL Editor

create table if not exists surprises (
  id uuid primary key default gen_random_uuid(),
  emoji text not null,
  title text not null,
  subtitle text not null default '',
  share_code text not null unique,
  created_at timestamptz default now()
);

create table if not exists surprise_elements (
  id uuid primary key default gen_random_uuid(),
  surprise_id uuid not null references surprises(id) on delete cascade,
  type text not null check (type in ('text', 'image', 'date', 'location', 'word_game')),
  label text not null,
  content text not null,
  unlock_code text not null,
  sort_order int not null default 0,
  created_at timestamptz default now()
);

-- Enable Row Level Security
alter table surprises enable row level security;
alter table surprise_elements enable row level security;

-- Public read access (anyone with share_code can view)
create policy "Public read surprises" on surprises for select using (true);
create policy "Public read elements" on surprise_elements for select using (true);

-- Anyone can insert (no auth required for this app)
create policy "Public insert surprises" on surprises for insert with check (true);
create policy "Public insert elements" on surprise_elements for insert with check (true);

-- Indexes
create index on surprises(share_code);
create index on surprise_elements(surprise_id, sort_order);
