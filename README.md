# MTK Notes

Notes on dynamic modeling, nonlinear systems, ModelingToolkit.jl, hydropower, and power systems.

## Markdown blog

This repository includes a small Jekyll/GitHub Pages blog. Posts are ordinary Markdown files in `_posts/`, so they remain readable directly from GitHub.

First post:

- **Dynamic Modeling 006: Homotopy Methods** — continuation mathematics, predictor-corrector methods, DAE initialization, hydropower and AC power-flow connections, and abstract Julia pseudocode.

## Add a new post

Create a file with the pattern:

```text
_posts/YYYY-MM-DD-dynamic-modeling-NNN-topic.md
```

and include front matter:

```yaml
---
layout: default
title: "Dynamic Modeling NNN: Topic"
date: YYYY-MM-DD
category: Dynamic Modeling
description: "One-line summary."
---
```

Equations use MathJax and can be written directly in Markdown with `$...$` or `$$...$$`.

## Deployment

The GitHub Pages workflow in `.github/workflows/pages.yml` builds and deploys the site when changes reach `main`.
