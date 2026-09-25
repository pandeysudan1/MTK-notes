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
| `equation_aware_waterway.tex` | Waterway blocks with governing balances and states |
| `equation_aware_smib.tex` | SMIB blocks with governing dynamic equations |
| `component_contract.tex` | Generic physical-law/algebraic/connection contract for an MTK component |
| `modeling_workflow.tex` | Physics-to-equations-to-MTK-to-simulation workflow |
| `component_reservoir.tex` | Reservoir balance, state, parameters and ports |
| `component_rigid_pipe.tex` | Pipe momentum balance and friction law |
| `component_surge_tank.tex` | Surge-tank storage and hydrostatic relation |
| `component_turbine.tex` | Turbine flow, power and torque relations |
| `component_generator.tex` | Classical generator swing and power-angle model |
| `component_governor.tex` | Droop governor and actuator dynamics |
| `component_atlas.tex` | One-page overview of the full hydropower component chain |
| `library_connector_mapping.tex` | OpenHPLjl vs HydroPowerDynamics.jl connector conventions |
| `openhpljl_model_code_pair.tex` | OpenHPLjl equations paired with MTK implementation |
| `openhpljl_turbine_shaft_pair.tex` | Source-aligned turbine-shaft-SMIB generator chain |
| `hpd_model_code_pair.tex` | HydroPowerDynamics.jl Francis/rotor/AGC equations paired with MTK ports |

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
│   ├── mtk_component_architecture.tex
│   ├── equation_aware_waterway.tex
│   ├── equation_aware_smib.tex
│   ├── component_contract.tex
│   ├── modeling_workflow.tex
│   ├── component_reservoir.tex
│   ├── component_rigid_pipe.tex
│   ├── component_surge_tank.tex
│   ├── component_turbine.tex
│   ├── component_generator.tex
│   ├── component_governor.tex
│   └── component_atlas.tex
├── build/
├── NOTATION.md
├── SOURCE_MAPPING.md
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


## Source alignment

The equation-aware figures are tied to the live Julia implementations. See `SOURCE_MAPPING.md` for the exact OpenHPLjl and HydroPowerDynamics.jl source file behind each diagram.

The two hydraulic connector conventions are intentionally kept distinct:

- OpenHPLjl: head `H` + volumetric flow `Q`
- HydroPowerDynamics.jl: pressure `p` + mass flow `dm`

Use the conversion `p = p_ref + rho*g*H` and `dm = rho*Q` only when explicitly bridging the libraries.
