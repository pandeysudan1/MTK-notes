# LaTeX Diagram Project

Reusable publication-quality technical diagrams built with LaTeX and TikZ.

## Purpose

This module is a small diagram laboratory for:

- control-system block diagrams
- hydropower plant schematics
- signal-flow diagrams
- power-system diagrams
- mathematical model architecture figures
- figures for papers, reports and Beamer slides

## Structure

```text
latex-diagrams/
├── diagrams/
│   ├── hydropower_control.tex
│   └── template_block_diagram.tex
├── build/
├── Makefile
└── README.md
```

## Compile locally

A TeX installation with TikZ and `latexmk` is required.

```bash
cd latex-diagrams
make
```

Compiled PDFs are written to `latex-diagrams/build/`.

Compile one figure:

```bash
make FILE=diagrams/hydropower_control.tex one
```

Clean generated files:

```bash
make clean
```

## Diagram convention

1. Inputs enter from the left and outputs leave to the right.
2. Dynamic components are rectangular blocks.
3. Summing junctions use circular nodes.
4. Physical-energy paths and control-signal paths are kept visually distinct by geometry and labels rather than decorative styling.
5. Symbols should match the equations used in the corresponding model.
6. Each diagram should compile as a standalone PDF so it can be included directly in papers or Beamer slides.

## Next diagrams

Planned figures include reservoir-pipe-surge-tank-turbine-generator chains, governor/FCR loops, SMIB models, two-area AGC, and ModelingToolkit component/connector architecture.
