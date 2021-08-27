# Repository `docs`

Repository for the sources and published documentation set, versioned for each Stan minor release.

* The Stan User's Guide - example models and techniques for coding statistical models in Stan and using them to do inference and prediction.
* The Stan Reference Manual - specification for Stan language and core inference algorithms.
* The Stan Functions Reference - functions and distributions built into the Stan language.
* The CmdStan Guide - guide to the reference command-line interface.


## Repository directory structure

* `src` : directory of source files for Stan and CmdStan guides and reference manuals, each in its own named subdirectory:
    + `src/cmdstan-guide` - CmdStan Guide
    + `src/functions-reference` - Stan Functions Reference
	+ `src/reference-manual` - Stan Reference Manual
	+ `src/stan-users-guide` - Stan Users Guide

* `docs`: the directory `docs` on branch `master` is the [publishing source](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/) for the project pages site.  Whenever a verified member of the Stan organization pushes to `docs` on branch `master`,
GitHub (re)builds and (re)deploys the website.

## Documentation toolset

The documentation source files are written in [Rmarkdown](https://rmarkdown.rstudio.com)
and the RStudio's [bookdown package](https://github.com/rstudio/bookdown) converts these to HTML and pdf.
**Required bookdown version:** 2.23 or higher, cf [the bookdown changelog](https://github.com/rstudio/bookdown/blob/main/NEWS.md#changes-in-bookdown-version-023).
Reported via [issue #380](https://github.com/stan-dev/docs/issues/380).


The conversion engine is [Pandoc](https://pandoc.org).  It is bundled with RStudio.
To use the build scripts to build the docset,
you might need to [install Pandoc](https://pandoc.org/installing.html) separately.

To build the pdf version of the docs, you will need to [install LaTeX](https://www.latex-project.org/get/) as well.
The Stan documentation uses the [Lucida fonts](https://www.pctex.com/Lucida_Fonts.html),
which must be [installed manually](https://tex.stackexchange.com/questions/88423/manual-font-installation).


## Scripts to build and maintain the docset

**`build.py`**

The program `build.py` convert the markdown files under `src` to html and pdf and populates the `docs` dir with the generated documentation.
Requires Python 3.5 or higher, due to call to `subproces.run`.
  + 2 required argments:  <Major> <minor> Stan version, expecting 2 positive integer arguments, e.g. `2 28`
  + 2 optional arguments:  <document> <format>.  The document name corresponds to the name of the `src` subdirectory or `all`.  The output format is either `html` or `pdf`.


**Build script examples**

* `python build.py 2 28` - creates directory `docs/2_28` as needed; populates it will all generated documentation.
* `python build.py 2 28 functions-reference` - builds both HTML and pdf versions of the Stan functions reference, resulting documents are under `docs/2_28`
* `python build.py 2 28 functions-reference pdf` - builds only the pdf version of the Stan functions reference,  resulting document is `docs/2_28/functions-reference_2_28.pdf`
* `python build.py 2 28 all pdf` - builds all pdfs from the Stan documentation set, resulting pdfs are in `docs/2_28`.
 

**Additional scripts**

The release process generates a new documentation set and adds links and redirects across the docset.

* `add_redirects.py` manages the redirects from unversioned links to the latest version.
* `link_to_latest.py` adds the "latest version" link into a docset.

The Stan Functions Reference contains HTML comments which describe the function signature for all functions.  The script `extract_function_sigs.py` is used to scrape these signatures into a plain text file.

## Build a single docset in R:  `bookdown::render_book`

To build a single documet, you must have R or RStudio installed.
To build a document from the command line, first `cd` to the correct `src` dir,
then use the `Rscript` utility.

```
# build html
> Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook')"

# build pdf
> Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
```

The output will be written to subdirectory `_build`.

## GitHub Pages

This repository uses
[GitHub Pages](https://help.github.com/categories/github-pages-basics)
to serve the
[project pages](https://help.github.com/articles/user-organization-and-project-pages/#project-pages-sites) site
with URL `https://mc-stan.org/docs`.
The publishing strategy is to serve the contents of the directory `docs` on branch `master`.
The `docs` directory contains an empty file named `.nojekyll` so that GitHub will treat the contents
as pre-generated HTML instead of trying to run [jekyll](https://jekyllrb.com).

