LATEXMK ?= latexmk
LATEXFLAGS = -pdf -interaction=nonstopmode -halt-on-error

SOURCES := $(wildcard diagrams/*.tex)
PDFS := $(patsubst diagrams/%.tex,build/%.pdf,$(SOURCES))

.PHONY: all one clean

all: $(PDFS)

build:
	mkdir -p build

build/%.pdf: diagrams/%.tex | build
	$(LATEXMK) $(LATEXFLAGS) -outdir=build $<

one:
	@test -n "$(FILE)" || (echo "Usage: make FILE=diagrams/name.tex one" && exit 1)
	mkdir -p build
	$(LATEXMK) $(LATEXFLAGS) -outdir=build $(FILE)

clean:
	$(LATEXMK) -C -outdir=build $(SOURCES) || true
	rm -rf build
