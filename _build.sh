#!/bin/sh

STAN_MAJOR=$1
STAN_MINOR=$2
VERSION_STRING=${STAN_MAJOR}.${STAN_MINOR}
echo ${VERSION_STRING}
mkdir -p docs/${VERSION_STRING}

pushd src/functions-reference
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook')"
Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
mv _book/_main.pdf ../../docs/stan-functions-reference-${VERSION_STRING}.pdf
rm _book/*.md
mv _book ../../docs/${VERSION_STRING}/functions-reference
rm -rf _book
# bookdown cleanup: *.rds stan-manual.css

popd

# pushd src/reference-manual
# OUTPUT_DIR=../../docs/${VERSION_STRING}/reference-manual"
# echo ${OUTPUT_DIR}
# mkdir -p ${OUTPUT_DIR}
# Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook', output_dir=${OUTPUT_DIR}, clean=TRUE)"
# Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"
# mv _book/_main.pdf ../../docs/stan-reference-manual-${VERSION_STRING}.pdf
# rm -rf _book
# popd
