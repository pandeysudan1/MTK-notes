# Source-to-Diagram Mapping

This document records which repository source files define the equations and connector conventions used in the LaTeX diagrams.

## OpenHPLjl

Reference branch: `pandeysudan1/OpenHPLjl@main`.

| Diagram concept | Source file | Exact implementation convention |
|---|---|---|
| Hydraulic connector | `src/Interfaces/HydraulicPort.jl` | `H(t)` is the across variable; `Q(t)` is a `connect = Flow` variable; positive flow enters a component |
| Rotational connector | `src/Interfaces/RotationalPort.jl` | `omega(t)` is across; `tau(t)` is flow; positive torque enters a component |
| Reservoir | `src/Reservoirs/Reservoir.jl` | `A*D(H) ~ Qin + port.Q`, `port.H ~ H` |
| Rigid pipe | `src/Waterways/RigidPipes/RigidPipe.jl` | `D(Q) ~ (g*A/L)*(inlet.H-outlet.H-hf)`, inlet/outlet flows are `Q` and `-Q` |
| Surge tank | `src/Waterways/SurgeTanks/SurgeTank.jl` | `As*D(H) ~ inlet.Q + outlet.Q`; both port heads equal tank head |
| Turbine | `src/Turbines/ShaftCoupledTurbine.jl` | gate is causal `SignalSocket`; hydraulic and rotational ports are acausal; exported shaft power uses a negative port sign |
| Shaft | `src/Mechanical/Shafts/LumpedShaft.jl` | `J*D(omega) ~ drive.tau + load.tau - damping*(omega-omega0)` |
| SMIB generator | `src/Electrical/Generators/SMIBGenerator.jl` | angle state is separate from shaft inertia; `Pe=Pmax*sin(delta)`; exported grid power is negative at the generator port |
| Droop governor | `src/Controls/DroopGovernor.jl` | `y_cmd=y0+(f_ref-f_meas)/R`; `Tg*D(y)=y_cmd-y` |

## HydroPowerDynamics.jl

Reference branch: `pandeysudan1/HydroPowerDynamics.jl@master`.

| Diagram concept | Source file | Exact implementation convention |
|---|---|---|
| Hydraulic connector | `src/connectors.jl` | pressure `p(t)` is across; mass flow `dm(t)` is flow |
| Rotational connector | `src/connectors.jl` | `phi(t)`, `omega(t)` are across; `tau(t)` is flow |
| Reservoir | `src/hydraulic.jl` | constant-head boundary: `port.p ~ p_atm + rho*g*H` |
| Penstock | `src/hydraulic.jl` | mass-flow inertia + Darcy friction; pressure-domain hydraulic ports |
| Surge tank | `src/hydraulic.jl` | free-surface storage in pressure/mass-flow formulation |
| Francis turbine | `src/turbine.jl` | affinity-law flow, parabolic efficiency model, mechanical torque output |
| Pelton turbine | `src/turbine.jl` | jet velocity, nozzle area and impulse-torque model |
| Rotor inertia | `src/mechanical.jl` | states `theta, omega`; two acausal rotational ports |
| PID / GGOV1 governors | `src/governor.jl` | dynamic control assembled from ModelingToolkitStandardLibrary blocks |
| Simple AGC governor | `src/agc.jl` | primary droop + secondary integral state + gate servo |

## Important distinction

The two libraries are physically compatible but use different hydraulic state/port coordinates:

[
p = p_{m ref} + ho g H,
qquad
dot m = ho Q.
]

Therefore a diagram should never label an OpenHPLjl hydraulic connector as `p, dm` or a HydroPowerDynamics.jl connector as `H, Q` unless the conversion is explicitly shown.

## Diagram maintenance rule

Whenever a component source equation changes, update its paired diagram and this mapping file in the same pull request.
