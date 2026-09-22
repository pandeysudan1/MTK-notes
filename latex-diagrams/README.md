# LaTeX Diagram Project

Reusable publication-quality technical diagrams built with LaTeX and TikZ.

## Purpose

This module is a compact diagram library for:

- hydropower component chains
- control-system block diagrams
- FCR prequalification workflows
- SMIB and AGC architectures
- power-system model figures
- ModelingToolkit component/connector diagrams
- figures for papers, reports and Beamer slides

## Current catalogue

| File | Purpose |
|---|---|
| `template_block_diagram.tex` | Generic closed-loop control template |
| `hydropower_control.tex` | Governor-waterway-turbine-generator control loop |
| `hydropower_waterway.tex` | Reservoir-intake-penstock-surge-tank-turbine-tailrace chain |
| `smib_architecture.tex` | Hydropower single-machine infinite-bus architecture |
| `fcr_prequalification.tex` | Frequency test to power-response evaluation workflow |
| `two_area_agc.tex` | Two-area AGC with ACE and tie-line feedback |
| `mtk_component_architecture.tex` | ModelingToolkit component/connector composition and reduction flow |

## Structure

```text
latex-diagrams/
├── diagrams/
│   ├── template_block_diagram.tex
│   ├── hydropower_control.tex
│   ├── hydropower_waterway.tex
│   ├── smib_architecture.tex
│   ├── fcr_prequalification.tex
│   ├── two_area_agc.tex
│   └── mtk_component_architecture.tex
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
make FILE=diagrams/smib_architecture.tex one
```

Clean generated files:

```bash
make clean
```

## Diagram conventions

1. Inputs enter from the left and outputs leave to the right.
2. Dynamic components use rectangular blocks.
3. Summing junctions use circular nodes.
4. Physical and control paths are distinguished by topology and labels, not decorative styling.
5. Symbols should match the equations used in the corresponding model.
6. Every figure compiles as a standalone PDF for direct use in papers and Beamer.
7. Hydropower diagrams should expose the physical sequence first, then control and measurement loops.
8. FCR figures should separate test signal, controller, plant response and requirement evaluation.

## Planned additions

Next additions should include:

- two-area AGC
- turbine lookup-table architecture
- ModelingToolkit connector/component graph
- FCR-D activation/deactivation sequence
- causal vs acausal modeling comparison
- Nordic multi-machine frequency-response architecture
