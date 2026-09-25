---
layout: default
title: Dynamic Modeling Notes
---

# Dynamic Modeling Notes

A compact engineering notebook on nonlinear dynamic models, equation-based modeling, power systems, hydropower, and Julia.

<ul class="post-list">
{% for post in site.posts %}
  <li>
    <div class="post-meta">{{ post.date | date: "%d %B %Y" }} · {{ post.category | default: "Dynamic Modeling" }}</div>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    {% if post.description %}<p>{{ post.description }}</p>{% endif %}
  </li>
{% endfor %}
</ul>

## Scope

The notes move from physical equations to numerical formulation and then to Julia implementation. Posts are written as standalone Markdown so the repository remains useful even without the website.
