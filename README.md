# Repository `docs`

Documentation for Stan language and platform

## GitHub Pages

This repository has configured
[GitHub Pages](https://help.github.com/categories/github-pages-basics)
to serve a 
[_project pages_](https://help.github.com/articles/user-organization-and-project-pages/#project-pages-sites) site
with URL `https://mc-stan.org/docs`.
It contains the documentation source files and build scripts to generate the static HTML.

## Directory Structure

* `src` : directory of source files for Stan manuals and book, each in its own named subdirectory.

* `docs`: the directory `docs` on branch `master` is the [publishing source](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/) for the project pages site.  Whenever a verified member of the Stan organization pushes to `docs` on branch `master`,
GitHub (re)builds and (re)deploys the website.

  
* `build.py`: python script which compiles markdown files under `src` to html and pdf and populates the `docs` dir with the generated documentation.

  + arg 1: MAJOR Stan version, required (expecting number, should be positive int)
  + arg 2: MINOR Stan version, required (expecting number, should be positive int)
  + arg 3: name of document (optional - will build entire docset)
  + arg 4: output format, either "html" or "pdf" (optional - default builds both html and pdfs)
  
* `LICENSE`: licensing terms.


## Generating the static site

1. Install R packages:  bookdown

2. Install on OS and ensure on PATH: pandoc, pandoc-citeproc, pdflatex

3. In the shell, run ./build.py.

4. The generated documents will be in directory `docs`.
