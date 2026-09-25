# ── Makefile for E-CoM Market LaTeX paper ───────────────────────────────────
# Usage:
#   make        – build main.pdf (runs pdflatex + bibtex twice)
#   make clean  – remove all auxiliary files
#   make purge  – remove auxiliary files AND the output PDF

MAIN   = main
LATEX  = pdflatex
BIBTEX = bibtex
FLAGS  = -interaction=nonstopmode -halt-on-error

.PHONY: all clean purge

all: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex references.bib
	$(LATEX) $(FLAGS) $(MAIN)
	$(BIBTEX) $(MAIN)
	$(LATEX) $(FLAGS) $(MAIN)
	$(LATEX) $(FLAGS) $(MAIN)

clean:
	rm -f $(MAIN).aux $(MAIN).bbl $(MAIN).blg $(MAIN).log \
	       $(MAIN).out $(MAIN).toc $(MAIN).lof $(MAIN).lot

purge: clean
	rm -f $(MAIN).pdf
