---
layout: default
title: "Dynamic Modeling 006: Homotopy Methods"
date: 2026-09-25
category: Dynamic Modeling
description: "From topological deformation to numerical continuation, nonlinear DAE initialization, and Julia implementation."
---

# Dynamic Modeling 006: Homotopy Methods

<div class="post-meta">25 September 2026 · Dynamic Modeling</div>

<p class="lede">Homotopy turns a difficult nonlinear problem into a path-following problem: solve an easier system first, then continuously deform it into the model we actually want.</p>

Homotopy methods sit at the intersection of topology and numerical computation. The topological idea is simple: continuously deform one object into another. Numerical continuation converts that idea into an algorithm for nonlinear equations. Instead of asking a local solver to jump directly to a difficult solution, we construct a family of problems indexed by a continuation parameter and track a solution along that family.

The historical roots lie in topology around Poincaré's *Analysis Situs* (1895), followed by twentieth-century homotopy theory. In numerical analysis, continuation and homotopy became practical tools for nonlinear algebraic systems, polynomial systems, equilibrium problems, and difficult initialization problems. Modern tools include Bertini, PHCpack, HOMPACK-style solvers, and Julia's HomotopyContinuation.jl.

> Homotopy is not automatically global optimization. It is a structured way of connecting a problem with known solutions to a problem whose solutions we want, while tracking one or more solution paths.

For polynomial systems, numerical homotopy continuation can enumerate isolated complex solutions under suitable assumptions. For general nonlinear DAEs and optimization problems, continuation is commonly used to improve initialization, reveal branches, or solve a sequence of progressively harder problems. A global optimum is not guaranteed merely by introducing a homotopy.

## 1. Starting point: a nonlinear system

Consider

$$
F(x)=0,
\qquad
x\in\mathbb{R}^n,
\qquad
F:\mathbb{R}^n\rightarrow\mathbb{R}^n.
$$

Newton's method gives

$$
x_{k+1}=x_k-J_F(x_k)^{-1}F(x_k),
$$

where

$$
J_F(x)=\frac{\partial F}{\partial x}.
$$

Newton is locally powerful, but convergence depends on the initial guess. A difficult engineering model may converge to an unintended root, diverge, encounter a poorly conditioned Jacobian, or miss other relevant solutions.

Homotopy changes the question from solving the final nonlinear system immediately to following a solution from an easier system.

## 2. Constructing the homotopy

Let

$$
G(x)=0
$$

be an easy start problem with a known solution. Define

$$
H(x,\lambda)=0,
\qquad
\lambda\in[0,1].
$$

The simplest deformation is

$$
\boxed{
H(x,\lambda)=(1-\lambda)G(x)+\lambda F(x)
}
$$

so that

$$
H(x,0)=G(x),
\qquad
H(x,1)=F(x).
$$

If a continuous solution branch exists,

$$
x=x(\lambda),
$$

then

$$
H(x(\lambda),\lambda)=0.
$$

Starting from

$$
G(x_0)=0
$$

at $\lambda=0$, the goal is to track the branch to $\lambda=1$.

## 3. Continuation equation

Differentiate

$$
H(x(\lambda),\lambda)=0
$$

with respect to $\lambda$:

$$
\frac{\partial H}{\partial x}\frac{dx}{d\lambda}
+
\frac{\partial H}{\partial\lambda}
=0.
$$

Therefore,

$$
H_x\frac{dx}{d\lambda}=-H_\lambda.
$$

When $H_x$ is nonsingular,

$$
\boxed{
\frac{dx}{d\lambda}
=
-H_x^{-1}H_\lambda
}
$$

For the linear homotopy,

$$
H_x=(1-\lambda)J_G+\lambda J_F,
$$

and

$$
H_\lambda=F(x)-G(x).
$$

Hence

$$
\boxed{
\frac{dx}{d\lambda}
=
-\left[(1-\lambda)J_G+\lambda J_F\right]^{-1}
\left[F(x)-G(x)\right]
}
$$

This is the tangent equation for the solution path.

## 4. Predictor-corrector continuation

Given a converged point $(x_k,\lambda_k)$, first compute a tangent:

$$
H_x(x_k,\lambda_k)t_k=-H_\lambda(x_k,\lambda_k).
$$

Then predict

$$
\lambda_{k+1}=\lambda_k+\Delta\lambda,
$$

$$
x_{k+1}^{(0)}=x_k+\Delta\lambda\,t_k.
$$

At the new continuation parameter, correct the predicted point using Newton:

$$
J_H(x^{(j)},\lambda_{k+1})\Delta x^{(j)}
=
-H(x^{(j)},\lambda_{k+1}),
$$

$$
x^{(j+1)}=x^{(j)}+\Delta x^{(j)}.
$$

Accept the point when

$$
\left\|H(x^{(j+1)},\lambda_{k+1})\right\|<\varepsilon.
$$

The computational pattern is therefore

$$
\boxed{
\text{start solve}
\rightarrow
\text{predict}
\rightarrow
\text{correct}
\rightarrow
\text{adapt step}
\rightarrow
\text{repeat}
}
$$

A practical algorithm increases $\Delta\lambda$ when correction is easy and reduces it when Newton struggles.

## 5. Pseudo-arclength continuation

Simple parameter continuation can fail at folds because $x$ may no longer be a single-valued function of $\lambda$. Introduce

$$
y=
\begin{bmatrix}
x\\
\lambda
\end{bmatrix}
$$

and let $\tau_k$ be the normalized path tangent. Solve the augmented system

$$
\boxed{
\begin{bmatrix}
H(x,\lambda)\\
\tau_k^T(y-y_k)-\Delta s
\end{bmatrix}
=0
}
$$

with Newton Jacobian

$$
\boxed{
\begin{bmatrix}
H_x & H_\lambda\\
\tau_x^T & \tau_\lambda
\end{bmatrix}
}
$$

This allows the path to turn in the $(x,\lambda)$ plane and is useful for folds and bifurcations.

## 6. Polynomial homotopy continuation

For a polynomial target system $F(x)=0$, a common form is

$$
H(x,t)=\gamma(1-t)G(x)+tF(x),
$$

with a generic complex scalar $\gamma$.

A solution path satisfies

$$
H(x(t),t)=0.
$$

Differentiating gives

$$
H_x\dot{x}+H_t=0,
$$

therefore

$$
\dot{x}=-H_x^{-1}H_t.
$$

HomotopyContinuation.jl uses predictor-corrector path tracking and endgame methods for difficult endpoints. Its documentation describes both start-target homotopies and the tracking of multiple isolated polynomial solutions.

## 7. Dynamic models and DAE initialization

A nonlinear dynamic engineering model is commonly written

$$
\dot{x}=f(x,z,u,p),
$$

$$
0=g(x,z,u,p),
$$

where $x$ are differential states and $z$ are algebraic variables.

Before time integration begins, consistent initial conditions must satisfy a nonlinear residual system:

$$
R_{\mathrm{full}}(y,p)=0,
\qquad
y=
\begin{bmatrix}
x_0\\
z_0
\end{bmatrix}.
$$

Instead of solving the full residual directly, construct

$$
\boxed{
R_H(y,p,\lambda)
=
(1-\lambda)R_{\mathrm{simple}}(y,p)
+
\lambda R_{\mathrm{full}}(y,p)
}
$$

At $\lambda=0$, solve an easier model. Then continue to $\lambda=1$.

This is closely aligned with the Modelica homotopy concept used during initialization: a simplified relation helps the nonlinear solve, after which the equations are continuously transformed into the actual relation. The Modelica specification explicitly recommends treating the transformation conceptually across the relevant coupled nonlinear system rather than as unrelated local substitutions.

## 8. Hydropower example: nonlinear pressure loss

Take the nonlinear head-loss model

$$
\Delta h=KQ|Q|.
$$

Around a nominal operating point, use a linearized relation

$$
\Delta h_{\mathrm{lin}}=R_nQ.
$$

Define

$$
\boxed{
\Delta h
=
(1-\lambda)R_nQ
+
\lambda KQ|Q|
}
$$

At $\lambda=0$, the waterway relation is linear. At $\lambda=1$, the full nonlinear pressure-loss relation is recovered.

The same strategy can be applied to nonlinear turbine equations, generator-network algebraic loops, saturation, converter limits, and other initialization relations, provided the simplified and actual equations remain physically compatible.

## 9. AC power flow

Write the AC power-flow equations abstractly as

$$
F_{\mathrm{AC}}(V,\theta)=0.
$$

Choose a tractable start system

$$
G(V,\theta)=0
$$

and construct

$$
H(V,\theta,\lambda)
=
(1-\lambda)G(V,\theta)
+
\lambda F_{\mathrm{AC}}(V,\theta).
$$

Continuation can trace operating-point branches and reveal multiple solutions. In polynomial formulations, numerical homotopy continuation can also enumerate isolated solutions, which is valuable for studying the nonlinear structure behind voltage stability and bifurcations.

## 10. OPF and contingencies

An AC optimal power-flow problem has the generic form

$$
\min_x C(x)
$$

subject to

$$
g(x)=0,
\qquad
h(x)\le 0.
$$

Security-constrained OPF adds many coupled contingency cases. A continuation strategy can connect a tractable base problem to a stressed contingency problem using a deformation parameter.

For Nordic grid studies, a useful engineering sequence is

$$
\text{base dispatch}
\rightarrow
\text{AC feasibility}
\rightarrow
\text{reactive constraints}
\rightarrow
\text{converter limits}
\rightarrow
\text{contingencies}.
$$

This can improve warm starts and expose the geometry of the solution landscape. Specially structured methods can have stronger theoretical properties, but homotopy alone is not a universal global-optimality certificate for arbitrary AC-OPF.

## 11. Abstract Julia pseudocode

The following deliberately exposes the algorithm before choosing a package.

```julia
function F(x, p)
    target_residual(x, p)
end

function G(x, p)
    simplified_residual(x, p)
end

function H(x, λ, p)
    (1 - λ) .* G(x, p) .+ λ .* F(x, p)
end

function Hx(x, λ, p)
    jacobian(z -> H(z, λ, p), x)
end

function Hλ(x, λ, p)
    F(x, p) .- G(x, p)
end

function tangent(x, λ, p)
    -(Hx(x, λ, p) \ Hλ(x, λ, p))
end

function newton_correct(x0, λ, p; tol=1e-9, maxiters=12)
    x = copy(x0)

    for k in 1:maxiters
        r = H(x, λ, p)

        if norm(r) < tol
            return x, true, k
        end

        Δx = -(Hx(x, λ, p) \ r)
        x += Δx
    end

    return x, false, maxiters
end

function continuation(x_start, p;
                      λ0=0.0,
                      λtarget=1.0,
                      Δλ0=0.05,
                      Δλmin=1e-5,
                      Δλmax=0.2)

    x = copy(x_start)
    λ = λ0
    Δλ = Δλ0
    path = [(λ=λ, x=copy(x))]

    while λ < λtarget
        λtrial = min(λ + Δλ, λtarget)

        # predictor
        t = tangent(x, λ, p)
        xpred = x + (λtrial - λ) .* t

        # corrector
        xnew, ok, niters = newton_correct(xpred, λtrial, p)

        if ok
            x = xnew
            λ = λtrial
            push!(path, (λ=λ, x=copy(x)))

            if niters <= 3
                Δλ = min(1.5 * Δλ, Δλmax)
            elseif niters >= 8
                Δλ = max(0.5 * Δλ, Δλmin)
            end
        else
            Δλ *= 0.5
            Δλ < Δλmin && error("Continuation path failed")
        end
    end

    return x, path
end
```

A production implementation should add automatic differentiation, sparse linear algebra, scaling, line searches or trust regions, singularity diagnostics, pseudo-arclength continuation, and careful stopping criteria.

## 12. ModelingToolkit-oriented form

For an equation-based Julia model, define full and simplified residual vectors with the same unknowns:

$$
R_{\mathrm{full}}(y,p)=0,
$$

$$
R_{\mathrm{simple}}(y,p)=0.
$$

Then

$$
R_H(y,p,\lambda)
=
(1-\lambda)R_{\mathrm{simple}}(y,p)
+
\lambda R_{\mathrm{full}}(y,p).
$$

Conceptually:

```julia
using ModelingToolkit

@parameters λ
@variables y[1:n]

Rfull   = [...]
Rsimple = [...]

Rhom = (1 - λ) .* Rsimple .+ λ .* Rfull
eqs = [0 ~ Rhom[i] for i in eachindex(Rhom)]

# Build the symbolic nonlinear initialization system.
# A continuation driver solves it repeatedly for λ: 0 → 1,
# using the previous solution as the next initial guess.
```

The numerical workflow is

```text
physical equations
      ↓
full nonlinear residual
      ↓
construct simplified residual
      ↓
introduce λ
      ↓
solve λ = 0
      ↓
continue λ → 1
      ↓
consistent full-model initialization
      ↓
dynamic DAE simulation
```

## 13. Engineering rules

A good simplified model should preserve the important variables and equation meaning, be easy to solve, avoid unnecessary singularities, stay near the operating region of interest, and smoothly approach the actual model.

A practical hierarchy for dynamic modeling is

$$
\text{linear component laws}
\rightarrow
\text{nonlinear steady-state laws}
\rightarrow
\text{full nonlinear initialization}
\rightarrow
\text{dynamic simulation}.
$$

The main principle is

$$
\boxed{
\text{do not weaken the final physical model; make the path to it easier to solve}
}
$$

For ModelingToolkit-based hydropower and power-system models, that principle is especially useful when the equations are physically reasonable but initialization is numerically fragile.

## References

1. J. McCleary, *A History of Algebraic Topology*.  
   <http://math.uchicago.edu/~chonoles/expository-notes/courses/2012/317/McCleary%20-%20A%20History%20of%20Algebraic%20Topology.pdf>

2. T. Porter, "Origins and breadth of the theory of higher homotopies."  
   <https://arxiv.org/pdf/0710.2645>

3. S. J. Liao, "Basic Ideas and Brief History of the Homotopy Analysis Method."  
   <https://numericaltank.sjtu.edu.cn/BasicIdea-BriefHistory/BasicIdea-BriefHistory.pdf>

4. AMS Notices, *Polynomial Systems*.  
   <https://www.ams.org/notices/202301/rnoti-p151.pdf>

5. HomotopyContinuation.jl, introduction to numerical polynomial systems.  
   <https://www.juliahomotopycontinuation.org/guides/introduction/>

6. HomotopyContinuation.jl documentation.  
   <https://www.juliahomotopycontinuation.org/HomotopyContinuation.jl/stable/>

7. Modelica Language Specification, homotopy operator and initialization.  
   <https://specification.modelica.org/maint/3.5/operators-and-expressions.html>

8. S. Park, J. Lavaei, R. Baldick et al., homotopy methods for post-contingency / security-constrained OPF.  
   <https://people.eecs.berkeley.edu/~sojoudi/SCOPF_hom_2022.pdf>

9. Computational and numerical analysis of AC optimal power flow.  
   <https://www.osti.gov/servlets/purl/1846582>

10. HomotopyContinuation.jl package preprint.  
    <https://ar5iv.labs.arxiv.org/html/1711.10911>

---

**Next:** Dynamic Modeling 007 can apply the same continuation formulation to a nonlinear hydropower initialization problem: reservoir → penstock → surge tank → turbine → generator → grid.
