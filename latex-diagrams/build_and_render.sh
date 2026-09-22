#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/diagrams"
GEN="$ROOT/generated"
TMP="$ROOT/.ci-build"

rm -rf "$TMP"
mkdir -p "$TMP" "$GEN"
rm -f "$GEN"/*.pdf "$GEN"/*.png

python3 - "$SRC" "$TMP" <<'PY'
from pathlib import Path
import re, sys

src = Path(sys.argv[1])
tmp = Path(sys.argv[2])

for path in sorted(src.glob("*.tex")):
    text = path.read_text(encoding="utf-8")

    # TikZ nodes cannot contain display-math environments. The project used
    # \[...\] in several node labels, so normalize those to inline
    # display-style math in the temporary compile copy.
    def repl(match):
        body = re.sub(r"\s*\n\s*", " ", match.group(1)).strip()
        return r"$\displaystyle " + body + r"$\\"

    text = re.sub(r"\\\[\s*([\s\S]*?)\s*\\\]", repl, text)
    (tmp / path.name).write_text(text, encoding="utf-8")
PY

failed=0
for tex in "$TMP"/*.tex; do
  base="$(basename "$tex" .tex)"
  echo "==> compiling $base"
  if pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$TMP" "$tex"; then
    cp "$TMP/$base.pdf" "$GEN/$base.pdf"
    pdftoppm -png -singlefile -r 180 "$TMP/$base.pdf" "$GEN/$base"
  else
    echo "ERROR: failed to compile $base" >&2
    failed=1
  fi
done

if [ "$failed" -ne 0 ]; then
  exit 1
fi

echo "Generated $(find "$GEN" -maxdepth 1 -name '*.pdf' | wc -l) PDFs and $(find "$GEN" -maxdepth 1 -name '*.png' | wc -l) PNG previews."
