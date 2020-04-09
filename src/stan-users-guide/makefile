html : 
	Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::gitbook')"

pdf : 
	Rscript -e "bookdown::render_book('index.Rmd', output_format='bookdown::pdf_book')"


clean:
	rm -r _book _bookdown_files _main.Rmd
