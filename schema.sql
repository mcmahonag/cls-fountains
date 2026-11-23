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

-- Mall and plaza tree inventory (added November 2026). Safe to run again.
create table if not exists trees (
  id uuid primary key default gen_random_uuid(),
  site_id text not null,          -- the mall or plaza, e.g. MP-013
  tree_no text,                   -- numbered within each plaza
  status text,                    -- Tree, Vacant planting site, Stump
  species text,
  botanical text,
  dbh numeric,                    -- inches
  stems numeric,
  height text,                    -- class, e.g. 15–30 ft
  spread numeric,                 -- canopy spread, feet
  condition text,                 -- Good, Fair, Poor, Critical, Dead
  risk text,                      -- Low, Moderate, High, Extreme
  site_type text,                 -- tree pit, grate, planter, bed, lawn, parkway
  planted_year numeric,
  conflicts text[] not null default '{}',
  needs text[] not null default '{}',
  pests text,
  inspected date,
  notes text,
  lat double precision,
  lon double precision,
  loc_note text,
  created_at timestamptz not null default now()
);
alter table trees enable row level security;
drop policy if exists "signed in full access" on trees;
create policy "signed in full access" on trees for all to authenticated using (true) with check (true);
