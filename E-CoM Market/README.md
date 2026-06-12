# E-CoM Market — LaTeX Paper

This folder contains the LaTeX project for the **E-CoM Market** research paper.

## Structure

```
latex/
├── main.tex        # Main LaTeX source file
├── references.bib  # BibTeX bibliography
└── Makefile        # Build automation
```

## Building the PDF

Make sure you have a TeX distribution installed (e.g. TeX Live or MiKTeX), then run:

```bash
cd latex
make
```

This will produce **`main.pdf`** in the same directory.

### Other targets

| Command       | Description                                      |
|---------------|--------------------------------------------------|
| `make`        | Build `main.pdf`                                 |
| `make clean`  | Remove auxiliary files (keep PDF)                |
| `make purge`  | Remove auxiliary files **and** the output PDF    |

## Manual build (without make)

```bash
pdflatex main
bibtex   main
pdflatex main
pdflatex main
```
