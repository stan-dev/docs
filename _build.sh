#!/bin/sh

STAN_MAJOR=$1
STAN_MINOR=$2
VERSION_STRING=${STAN_MAJOR}_${STAN_MINOR}

mkdir -p docs/${VERSION_STRING}

pushd src/functions-reference
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook')"
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
mv _book/_main.pdf ../../docs/stan-functions-reference-${VERSION_STRING}.pdf
rm _book/*.md
mv _book ../../docs/${VERSION_STRING}/functions-reference
rm -rf _book _main.rds stan-manual.css
popd

pushd src/reference-manual
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook')"
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
mv _book/_main.pdf ../../docs/stan-reference-manual-${VERSION_STRING}.pdf
rm _book/*.md
mv _book ../../docs/${VERSION_STRING}/reference-manual
rm -rf _book _main.rds stan-manual.css
popd

pushd src/bayes-stats-stan
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook')"
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
mv _book/_main.pdf ../../docs/bayes-stats-stan-${VERSION_STRING}.pdf
rm _book/*.md
mv _book ../../docs/${VERSION_STRING}/bayes-stats-stan
rm -rf _book _main.rds stan-manual.css
popd

pushd src
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::html_book')"
mv _book/index.html ../docs/
rm -rf _book _main.rds
popd

