# The Stan Book

This is the repository for *Bayesian Statistics Using Stan", which
serves as both the Stan users' guide and an introduction to Bayesian
statistics.

### Directory Structure

* `*.Rmd` files: basic text
* `_bookdown.yml`: book includes
* `_output.yml`: output config
* `bib/all.bib`: BibTeX file for references


### Building the Book from Source

You will need to have RStan installed in the R environment from which
you build.

#### RStudio

In RStudio: to build the project, open `index.Rmd` in RStudio and click `knit`
    - change output on first line of `index.Rmd` for `gitbook` and `pdf_book` (not differeing `_`)

#### Outside of RStudio

First, you will need to install `pandoc` and `pandoc-citeproc` in
addition to the `bookdown` package in R.  Then

```
> setwd('docs/src/stan-users-guide')
```

Then execute one of the following commands depending on whether
you want HTML or PDF output.

**HTML**  To build the HTML version,
```
> bookdown::render_book('index.Rmd', 'gitbook')
```
The home of the output will be in `_book/index.html`.

**PDF** To build the PDF version,
```
bookdown::render_book('index.Rmd', 'pdf_book')
```
The output will be in the single file `_book/main.pdf`.

#### From the shell

R can be run as a script from the shell in the source diectory.  First
change to the source directory:

```
$ cd docs/src/stan-users-guide
```

Then execute one of the following for HTML or PDF output.

**HTML**
```
$ Rscript -e "bookdown::render_book('index.Rmd')"
```
The home of the output will be in `_book/index.html`.


**PDF**
```
$ Rscript -e "bookdown::render_book('index.Rmd', 'pdf_book')"
```
The output will be in the single file `_book/main.pdf`.


### Style Guide for Authors

* All lines should be 80 or fewer characters unless absolutely
mandated by content

* y ~ normal(mu, sigma) # Not: N(), not sigma^2, roman font for
  "normal", LaTeX math for $y$, $\mu$, $\sigma$

* normal(y | mu, sigma) # Vertical bar, not semicolon

* Poisson, Weibull, LKJ # Use capital letters for distributions that
  are named after people

* E(y)  # Roman font for E, LaTeX math for $y$, parentheses not brackets

* ()  # Always parentheses, never brackets

* No special fonts for distributions, just roman and math fonts

* p(y) # Probability density and probability mass function

* Pr(A)  # probability of an event

* Follow the Stan style guide for code
    - int<lower=0> N;  # Put in the lower bound
    - for (n in 1:N) {...} # Not:  for (i in 1:n), always bracketed
    - foo_bar # Underscores rather than dots or CamelCase

* No R/Python code in the finished book except in appendix

* All Stan code should be best practice except when explaining
  something, in which case we should explicitly show the best-practice
  alternative


### Licensing

The code is licensed under BSD-3 and the text under CC-BY ND 4.0.
