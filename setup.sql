-- Run this entire file in the Supabase SQL editor (supabase.com → your project → SQL Editor)

create table restaurants (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  notes text,
  submitted_by text,
  created_at timestamptz default now(),
  is_active boolean default true
);

create table ballots (
  id uuid default gen_random_uuid() primary key,
  week_of date not null,
  created_at timestamptz default now(),
  closed boolean default false,
  winner_id uuid references restaurants(id)
);

create table ballot_options (
  id uuid default gen_random_uuid() primary key,
  ballot_id uuid references ballots(id) on delete cascade,
  restaurant_id uuid references restaurants(id)
);

create table votes (
  id uuid default gen_random_uuid() primary key,
  ballot_id uuid references ballots(id) on delete cascade,
  restaurant_id uuid references restaurants(id),
  voter_name text not null,
  voted_at timestamptz default now(),
  unique(ballot_id, voter_name)
);

create table visits (
  id uuid default gen_random_uuid() primary key,
  restaurant_id uuid references restaurants(id),
  visited_on date not null,
  created_at timestamptz default now()
);

-- RLS: enabled but fully open (internal team tool, no sensitive data)
alter table restaurants enable row level security;
alter table ballots enable row level security;
alter table ballot_options enable row level security;
alter table votes enable row level security;
alter table visits enable row level security;

create policy "public_all" on restaurants for all using (true) with check (true);
create policy "public_all" on ballots for all using (true) with check (true);
create policy "public_all" on ballot_options for all using (true) with check (true);
create policy "public_all" on votes for all using (true) with check (true);
create policy "public_all" on visits for all using (true) with check (true);
