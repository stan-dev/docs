#!/bin/sh

mkdir -p docs
rmdir -rf docs/bayes-stats-stan

pushd src/bayes-stats-stan
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook')"
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
mv _book/_main.pdf ../../docs/bayes-stats-stan.pdf
rm _book/*.md
mv _book ../../docs/bayes-stats-stan
rm -rf _book _main.rds stan-manual.css
popd
