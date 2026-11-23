# CDOT Site Tracker

A map-based tracker for CDOT's landscaped traffic-calming sites, malls and plazas, and fountains
(708 sites). Traffic calming and malls and plazas fall under the CLS (Comprehensive Landscape Services)
contracts by region; fountains are a separate citywide contract. The app logs maintenance visits,
community partners and a tree inventory for the malls and plazas, and works on a desktop or a phone.

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
| CLS Region 1 | A Safe Haven |
| CLS Regions 2 and 6 | Christy Webber |
| CLS Regions 3 and 5 | Lizzette Medina |
| Citywide fountains (separate contract) | Fountain Pros |

## Tree inventory (malls and plazas)

Open a mall or plaza on the map and tap **Add tree**. Then either tap the tree on the map (switch the
basemap to Satellite with the layers button) or stand at the trunk and tap **Use my GPS**. Each tree is
numbered within its plaza (e.g. `MP-016-T01`) and records species, DBH, height, canopy spread,
condition, risk, planting site, conflicts, work needed, pests and inspection date. Vacant planting
sites and stumps can be recorded too. The **Trees** tab lists and filters every tree and exports the
inventory to Excel.

If you set up Supabase before the tree inventory was added, run `schema.sql` again once; it adds the
`trees` table and leaves your other tables alone.

## Updating the site list

Site details (name, type, ward, region, coordinates) come from `sites.json`. Records are keyed by
site ID (`TC-0035`, `MP-013`, `FT-07`), so fixing a site's details keeps its history attached.
