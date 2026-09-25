# Diagram Notation

This project uses a consistent notation across hydropower, control, and ModelingToolkit diagrams.

## Core variables

| Symbol | Meaning | Typical unit |
|---|---|---|
| $Q$ | volumetric flow | m³/s |
| $H$ | hydraulic head | m |
| $p$ | pressure | Pa |
| $V$ | stored water volume | m³ |
| $y_g$ | guide-vane / gate opening | pu or % |
| $T_m$ | mechanical torque | N·m or pu |
| $P_m$ | mechanical power | W or pu |
| $P_e$ | electrical power | W or pu |
| $\omega$ | rotor speed | rad/s or pu |
| $\delta$ | rotor electrical angle | rad |
| $\Delta f$ | frequency deviation | Hz |
| $x$ | differential state vector | context dependent |
| $z$ | algebraic variable vector | context dependent |
| $u$ | external input vector | context dependent |
| $p$ | parameter vector | context dependent |

## Component modeling convention

Each physical component should be described in this order:

1. **Mass balance**
   \[
   \frac{d}{dt}(\text{stored mass}) = \text{inflow} - \text{outflow}.
   \]

2. **Momentum balance**
   \[
   \text{inertial term} = \text{driving pressure/head} - \text{losses}.
   \]

3. **Algebraic constitutive relations**
   such as friction, turbine maps, generator power-angle relations, or boundary conditions.

4. **Connection equations**
   with effort-like variables continuous across a connection and flow-like variables conserved.

## MTK state-space/DAE convention

The generic model is written as

\[
M(x,p)\dot{x}=f(x,z,u,p),
\]

with algebraic constraints

\[
0=g(x,z,u,p).
\]

This form is intentionally broad enough to include explicit ODEs, semi-explicit DAEs, and structurally reduced ModelingToolkit systems.

## Diagram rule

A block should show only the equations needed to communicate its physics. Full derivations belong in the accompanying report or source documentation.
