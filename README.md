# ResScan tutorial

A hands-on tutorial that walks users through the recommended workflow for
metagenomic AMR quantification:

**QC + host removal ([VANISH](https://github.com/hsgweon/vanish)) → AMR quantification ([ResScan](https://github.com/hsgweon/resscan)) → analysis.**

It ships a small teaching dataset so users can run the full pipeline in minutes,
and a set of full-depth pre-computed results so the analysis is meaningful. A
[Quarto](https://quarto.org) website presents it as step-by-step pages.

---

## ✍️ Where to edit the text — page map

**Each page of the website is one `.qmd` file in this folder. Edit the `.qmd`; that
is the source.** They render (in the order below) to the site. Filenames don't sort
in reading order, so this table is the map:

| # | Page (as it appears on the site) | Edit this file | What it covers |
|---|---|---|---|
| — | **Landing page** | [`index.qmd`](index.qmd) | Hero, tagline, the three workflow cards. The site's front door. |
| 1 | **Overview** | [`overview.qmd`](overview.qmd) | The story — why replacing the sinks didn't fix the resistance problem; what you'll do and run it on. |
| 2 | **Setup** | [`setup.qmd`](setup.qmd) | Install the environments, fetch the teaching data, build the CARD database. |
| 3 | **Step 1 · QC & host removal** | [`vanish.qmd`](vanish.qmd) | Running VANISH — quality-control the reads and remove human DNA. |
| 4 | **Step 2 · Quantify with ResScan** | [`resscan.qmd`](resscan.qmd) | Running ResScan (one sample, then batch), and the RPKPMC default metric. |
| 5 | **Output reference** | [`output-reference.qmd`](output-reference.qmd) | Understanding ResScan's output — files, columns, metric names, the `multiple` label. |
| 6 | **Step 3 · Analysis** | [`analysis.qmd`](analysis.qmd) | The R analysis: load, composition (NMDS), gene families, VarScan — with the four figures. |
| 7 | **Appendix · Your own data** | [`appendix.qmd`](appendix.qmd) | Bring-your-own-reads: real human index, keeping CARD current, cleanup. |

The **navigation order** (navbar + sidebar) is defined in `_quarto.yml`, *not* by the
filenames — so you can edit a page without touching anything else. If you add or
reorder pages, update the `contents:` list in `_quarto.yml`.

### How to edit and see your changes

```bash
quarto preview      # live local preview with hot-reload — edit a .qmd and the page updates
```

Edit prose directly in the `.qmd` files (they're Markdown with a small YAML header
for the title/subtitle). Code blocks on the pages are **illustrative** — they are not
executed when the site builds, so you don't need R, conda, or Nextflow just to edit
and preview text.

---

## Look & feel (brand)

| File | What it controls |
|---|---|
| `theme.scss` | All site styling — the ResScan **pink** brand colour (`#e5177e`), fonts, layout, hero, cards, callouts. Change colours here. |
| `logo/ResScanLogo_web.png` | The logo shown in the **navbar** and **landing hero** (transparent background). |
| `favicon.png` | Browser-tab icon (the pink "R", cropped from the logo). |
| `logo/ResScanLogo.png` | Original logo (white background). `logo/ResScanLogo.ai` is the editable Illustrator source. |

---

## Repository layout

```
resscan-tutorial-project/
├── _quarto.yml                 # site config: navbar, sidebar/nav ORDER, output → docs/
├── theme.scss                  # site styling (pink brand theme, fonts, layout)
├── favicon.png                 # browser-tab icon (the "R")
│
├── index.qmd                   # landing page          ── see the PAGE MAP above ──
├── overview.qmd                # Overview
├── setup.qmd                   # Setup
├── vanish.qmd                  # Step 1 · QC & host removal
├── resscan.qmd                 # Step 2 · Quantify with ResScan
├── output-reference.qmd        # Output reference
├── analysis.qmd                # Step 3 · Analysis
├── appendix.qmd                # Appendix · Your own data
│
├── logo/                       # ResScanLogo_web.png (used), ResScanLogo.png, ResScanLogo.ai
├── figures/                    # the four analysis plots shown on analysis.qmd
│                               #   load.png · nmds.png · families.png · varscan.png
├── scripts/
│   ├── make_subset.sh          # provenance: how rawdata_10K was made from the full data
│   └── build_toy_index.sh      # builds the toy Bowtie2 index from chrM.fa
├── data/
│   ├── rawdata_10K/            # 36 samples × 10,000 read pairs (150 bp) — the teaching subset
│   ├── reports_full/           # full-depth ResScan output (SR_*.tsv) + metadata — used by analysis.qmd
│   ├── host_index/             # prebuilt toy Bowtie2 index (toy_human.*) + chrM.fa source
│   ├── read_pairs.csv          # ready-made VANISH input (portable; filenames only)
│   ├── samplesheet.csv         # ready-made ResScan batch input (portable; relative paths)
│   └── sampleid2fileprefix.csv # sample→file mapping for the optional samplesheet helper
│
└── docs/                       # RENDERED site (what GitHub Pages serves) — do not hand-edit
```

> **Don't edit `docs/`** — it's generated. Edit the `.qmd` (and `theme.scss`), then
> re-run `quarto render` and the whole `docs/` folder is rebuilt.

---

## Build & preview the site

Install [Quarto](https://quarto.org/docs/get-started/), then from the repo root:

```bash
quarto preview      # live local preview with hot-reload (best while editing)
quarto render       # write the final static site to docs/
```

## Publish on GitHub Pages

The rendered site lives in `docs/` and is committed. To serve it:

1. Push the repo to GitHub.
2. **Settings → Pages → Build and deployment → Source: _Deploy from a branch_**, then
   pick your default branch and the **`/docs`** folder.

The site appears at `https://<user>.github.io/<repo>/`. After editing any `.qmd` or
`theme.scss`, re-run `quarto render` and commit the updated `docs/`. (`.nojekyll` is
included so GitHub serves the files as-is.)

---

## About the datasets

| Dataset | What it is | Why |
|---|---|---|
| `data/rawdata_10K/` | The **first 10,000 read pairs** of each of the 36 sink-drain samples | Small enough to download and run in minutes; teaches the *mechanics* |
| `data/reports_full/` | Full-depth ResScan reports for all 36 samples (the published run) | The teaching subset is too shallow for meaningful biology, so the **analysis uses the full results** |
| `data/host_index/toy_human.*` | **Prebuilt** Bowtie2 index of the human mitochondrial genome (`chrM.fa`, NC_012920.1, 16,569 bp) | A **tiny stand-in host** so the VANISH step runs in seconds without the ~4 GB GRCh38 index. Shipped prebuilt so users run the exact same command they would in real life. Real research uses the full human index (documented in the tutorial); the toy removes only a little, so the tutorial shows the true host-removal numbers from the full run. |

**Provenance.** The samples are from NCBI SRA BioProject **PRJNA587635**
(ICU sink-drain biofilms, before/after plumbing replacement). The full raw reads
remain on SRA; only the small subset lives here.

## The two shipped CSVs (and the one you generate)

- `read_pairs.csv` — VANISH input. Portable (filenames relative to `--fastq_dir`).
  Regenerate with `vanish-prep --fastq_dir data/rawdata_10K --r1 "_1" --r2 "_2"`.
- `samplesheet.csv` — ResScan **batch** input: one row per sample,
  `sample_id,R1,R2` (commas separate a run's mates, `;` separates runs). Paths are
  relative to the launch directory; `resscan_batch` resolves them (absolute works
  too), so this ships ready to use.
- `sampleid2fileprefix.csv` — a simple `sample_id,file_prefix` mapping, used only
  by the *optional* helper `create_samplesheet_from_mapping` if you'd rather
  generate `samplesheet.csv` yourself.
