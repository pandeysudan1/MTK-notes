2+5
using Plots

# Gate signal
uv = collect(0.1:0.1:0.9)

# Efficiency data (NaN = not defined region)
η_pelton    = [0.05, 0.75, 0.85, 0.89, 0.91, 0.91, 0.90, 0.89, 0.87]
η_crossflow = [0.00, 0.70, 0.78, 0.80, 0.81, 0.81, 0.80, 0.80, 0.79]
η_kaplan    = [NaN, 0.28, 0.55, 0.70, 0.78, 0.83, 0.86, 0.88, 0.89]
η_francis   = [NaN, 0.00, 0.35, 0.55, 0.70, 0.80, 0.87, 0.90, 0.91]
η_propeller = [NaN, NaN, NaN, 0.05, 0.30, 0.50, 0.65, 0.78, 0.86]

# Plot
plot(
    uv, η_pelton,
    label = "Pelton",
    lw = 2,
    xlabel = "Gate signal uᵥ",
    ylabel = "Efficiency η",
    legend = :bottomright,
    ylim = (0, 1),
    xlim = (0, 1),
)

plot!(uv, η_crossflow, label="Cross-flow", lw=2)
plot!(uv, η_kaplan,    label="Kaplan",     lw=2)
plot!(uv, η_francis,  label="Francis",    lw=2)
plot!(uv, η_propeller,label="Propeller",  lw=2)

display(current())

using Plots

# Analytical efficiency model
η(u, ηmax, u0, a) = u <= u0 ? 0.0 : ηmax * (1 - exp(-a * (u - u0)))

# Parameters (ηmax, u0, a)
params = Dict(
    "Pelton"     => (0.92, 0.15, 15.0),
    "Cross-flow" => (0.82, 0.10, 10.0),
    "Kaplan"     => (0.90, 0.20,  4.0),
    "Francis"    => (0.92, 0.25,  3.0),
    "Propeller"  => (0.88, 0.40,  2.0),
)

# Gate signal grid
uv = range(0, 1; length=500)

# Plot
plt = plot(
    xlabel = "Gate signal uᵥ",
    ylabel = "Efficiency η",
    xlim = (0, 1),
    ylim = (0, 1),
    legend = :bottomright,
    lw = 2,
)

for (name, (ηmax, u0, a)) in params
    plot!(plt, uv, [η(u, ηmax, u0, a) for u in uv], label=name)
end

display(plt)

