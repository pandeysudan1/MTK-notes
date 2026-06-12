# E-CoM Market — LaTeX Research Proposal

This folder contains the LaTeX source for the postdoctoral research proposal:

> **Electrical Center-of-Mass Theory for Spatially-Aware Electricity Markets
> and Digital Twin Control of Net-Zero Power Systems**
> *2–3 Year Postdoctoral Research Programme*
> Power Systems · Market Design · Control Theory · Digital Twins

## Structure

```
latex/
├── main.tex        # Full proposal (Parts I–IV, ~28 pages)
├── references.bib  # BibTeX bibliography (power systems references)
└── Makefile        # Build automation
```

## Contents

| Part | Title | Sections |
|------|-------|----------|
| I    | The Problem | Market gaps, spatial instability, central hypothesis |
| II   | The Theory  | E-CoM definition, five service centers, dynamics equation |
| III  | The Solution | Four markets, Extended LMP*, Digital Twin architecture |
| IV   | Research Programme | Work packages, Nordic demo, hydropower WP |

## Building the PDF

Requires a full TeX Live or MiKTeX distribution (for `tcolorbox`, `listings`,
`tikz`, `natbib`, etc.).

```bash
cd latex
make
```

This runs `pdflatex` + `bibtex` + two more `pdflatex` passes and produces
**`main.pdf`**.

### Other targets

| Command       | Description                                   |
|---------------|-----------------------------------------------|
| `make`        | Build `main.pdf`                              |
| `make clean`  | Remove auxiliary files (keep PDF)             |
| `make purge`  | Remove auxiliary files **and** `main.pdf`     |

### Manual build (without make)

```bash
pdflatex main
bibtex   main
pdflatex main
pdflatex main
```

