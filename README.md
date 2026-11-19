# CDOT Site Tracker

A map-based tracker for CDOT's landscaped traffic-calming sites, malls and plazas, and fountains
(716 sites across Regions 1, 2, 3, 5 and 6, plus the citywide fountain contract). It logs maintenance
visits and community partners, and works on a desktop or a phone.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole app |
| `sites.json` | The site list (cleaned from the geocoded traffic-calming, fountain and mall/plaza CSVs) |
| `manifest.webmanifest`, `sw.js`, `icon-*.png` | Let the app install on a phone's home screen and open with a weak signal |
| `schema.sql` | Creates the Supabase tables, if you want records synced across devices |

Visit records, partner contacts and invoice data are **not** stored in this repo. They live in the
browser (local mode) or in your Supabase project, and get loaded with Settings › Import records.

## Turn on GitHub Pages

1. In this repo: Settings › Pages › Source: **Deploy from a branch**, branch `main`, folder `/ (root)` › Save.
2. In a minute or two the app is live at `https://mcmahonag.github.io/cls-fountains/`.

It works right away in **local mode**: records save in that browser only.

## Sync with Supabase (optional, same setup as the Reno app)

1. At supabase.com create a new project (the free tier is plenty).
2. SQL Editor › New query › paste all of `schema.sql` › Run.
3. Authentication › Users › **Add user** to create your login. Then turn **off** "Allow new users to sign up".
4. Project Settings › API: copy the **Project URL** and the **anon public** key.
5. In the tracker: Settings › paste the URL and key, enter your email and password › Connect.
   Records already in that browser are copied up. Repeat step 5 on your phone.

## Loading contractor records

Claude turns contractor schedules and invoices into `.json` import files. Load one with
Settings › Import records. Importing the same file twice doesn't create duplicates, and an invoice
file replaces the planned (schedule) visits for that month.

Each visit has a record type: **Confirmed** (logged by CDOT), **Invoice** (from a contractor's
invoice backup) or **Contractor schedule** (planned).

## Contracts

| Contract | Contractor |
|---|---|
| Region 1 landscape | A Safe Haven |
| Regions 2 and 6 landscape | Christy Webber |
| Regions 3 and 5 landscape | Lizzette Medina |
| Citywide fountains | Fountain Pros |

## Updating the site list

Site details (name, type, ward, region, coordinates) come from `sites.json`. Records are keyed by
site ID (`TC-0035`, `MP-013`, `FT-07`), so fixing a site's details keeps its history attached.
