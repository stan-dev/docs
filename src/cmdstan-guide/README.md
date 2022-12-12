Steps to build functions manual:

1.  Install R packages:  bookdown

2.  Install on OS and ensure on PATH: pandoc, pandoc-citeproc,
pdflatex

3.  To build single manual, such as cmdstan-guide, functions-reference, reference-manual, or stan-users-guide, using Rscript
    a. In shell change directory to `docs/src/<MANUAL>`
    b. In shell, execute 
       ```
       # build html
       > Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook')"
       # build pdf
       > Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
       ```
       The output will be written to subdirectory `_build`.

4. For other build options see `docs/README.md`
