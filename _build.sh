#!/bin/sh

mkdir -p docs

pushd src/functions-reference
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook', output_dir='../../docs/functions-reference', clean=TRUE)"
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
mv _book/_main.pdf ../../docs/stan-functions-reference.pdf
rm -rf _book
popd

pushd src/reference-manual
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook', output_dir='../../docs/reference-manual', clean=TRUE)"
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
mv _book/_main.pdf ../../docs/stan-reference-manual.pdf
rm -rf _book
popd


