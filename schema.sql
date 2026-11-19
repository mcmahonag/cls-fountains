-- CDOT Site Tracker: Supabase tables
-- Run this once in your Supabase project: SQL Editor > New query > paste > Run.
-- The site list itself (sites.json) ships with the app. These tables hold
-- everything you log against a site, keyed by site_id (e.g. TC-0035, MP-013, FT-07).

create table if not exists visits (
  id uuid primary key default gen_random_uuid(),
  site_id text not null,
  visit_date date not null,
  work_types text[] not null default '{}',
  done_by text,              -- CDOT crew, contractor name, or partner
  source text,               -- Confirmed, or Contractor schedule
  hours numeric,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists partners (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  partner_type text,
  contact_name text,
  contact_email text,
  contact_phone text,
  agreement_start date,
  agreement_end date,
  waiver text,               -- Yes, No, Pending
  commitments text,
  site_ids text[] not null default '{}',
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists site_notes (
  site_id text primary key,
  condition text,            -- Good, Fair, Poor
  notes text,
  updated_at timestamptz not null default now()
);

create table if not exists settings (
  key text primary key,
  value jsonb
);

-- Only signed-in users can read or write. With one login (yours), that's just you.
do $$
declare t text;
begin
  foreach t in array array['visits','partners','site_notes','settings'] loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists "signed in full access" on %I', t);
    execute format('create policy "signed in full access" on %I for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;

-- If you created the tables before the schedule import was added, this adds the new column:
alter table visits add column if not exists source text;
