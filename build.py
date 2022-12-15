#!/usr/bin/env python
"""
build docs for specified MAJOR, MINOR version
and specified document (optional), format (optional)
when document and format not specified, builds all documents in all formats.

arg 1: MAJOR version number
arg 2: MINOR version number
optional arg 3: specified document or "all"
optional arg 4: specified format or "all"
"""

import glob
import os
import os.path
import shutil
import subprocess
import sys
import contextlib

all_docs = ("functions-reference", "reference-manual", "stan-users-guide", "cmdstan-guide")
all_formats = ("html", "pdf")

@contextlib.contextmanager
def pushd(new_dir):
    previous_dir = os.getcwd()
    os.chdir(new_dir)
    yield
    os.chdir(previous_dir)

def shexec(command):
    ret = subprocess.run(command, shell=True, check=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    if ret.returncode != 0:
        print('Command {} failed'.format(command))
        print(ret.stderr)
        raise Exception(ret.returncode)

def check_bookdown_at_least_0_23():
    command = ["Rscript", "-e", "utils::packageVersion(\"bookdown\") > 0.22"]
    check = subprocess.run(command, capture_output=True, text=True)
    if not 'TRUE' in check.stdout:
        print("R Package bookdown version must be at least 0.23, see README for build tools requirements")
        sys.exit(1)

def safe_rm(fname):
    if os.path.exists(fname):
        os.remove(fname)

def make_docs(docspath, version, document, formats):
    path = os.getcwd()
    srcpath = os.path.join(path, "src", document)
    with pushd(srcpath):
        if ("pdf" in formats):
            print('render {} as pdf'.format(document))
            command = "Rscript -e \"bookdown::render_book(\'index.Rmd\', output_format=\'bookdown::pdf_book\')\""
            shexec(command)
            srcpdf = os.path.join(srcpath, "_book", "_main.pdf")
            pdfname = ''.join([document,'-',version,".pdf"])
            pdfpath = os.path.join(docspath, pdfname)
            shutil.move(srcpdf, pdfpath)
            print('output file: {}'.format(pdfpath))
        if ("html" in formats):
            print('render {} as html'.format(document))
            command = "Rscript -e \"bookdown::render_book(\'index.Rmd\', output_format=\'bookdown::gitbook\')\""
            shexec(command)
            [safe_rm(f) for f in ("stan-manual.css", "_main.rds")]
            [safe_rm(f) for f in glob.glob(os.path.join("_book","*.md"))]
            htmlpath = os.path.join(docspath, document)
            shutil.rmtree(htmlpath, ignore_errors=True)
            command = ' '.join(["mv _book", htmlpath])
            shexec(command)
            print('output dir: {}'.format(htmlpath))
        else:
            [safe_rm(f) for f in ("stan-manual.css", "_main.rds")]
            shutil.rmtree("_book", ignore_errors=True)

def main():
    if sys.version_info < (3, 7):
        print('requires Python 3.7 or higher, found {}'.format(sys.version))
        sys.exit(1)
    check_bookdown_at_least_0_23()
    global all_docs
    global all_formats
    if (len(sys.argv) > 2):
        stan_major = int(sys.argv[1])
        stan_minor = int(sys.argv[2])
    else:
        print("Expecting arguments MAJOR MINOR version numbers")
        sys.exit(1)

    stan_version = '_'.join([str(stan_major), str(stan_minor)])
    path = os.getcwd()
    docspath = os.path.join(path, "docs", stan_version)
    if (not(os.path.exists(docspath))):
        try:
            os.makedirs(docspath)
        except OSError:
            print("Creation of the directory %s failed" % docspath)
        else:
            print("Successfully created the directory %s " % docspath)

    docset = all_docs
    if (len(sys.argv) > 3):
        if (sys.argv[3] != "all"):
            if (sys.argv[3] not in docset):
                print("Expecting one of %s" % ' '.join(docset))
                sys.exit(1)
            docset = (sys.argv[3],)

    formats = all_formats
    if (len(sys.argv) > 4):
        if (sys.argv[4] != "all"):
            if (sys.argv[4] not in formats):
                print("Expecting one of %s" % ' '.join(formats))
                sys.exit(1)
            formats = (sys.argv[4],)

    if (len(sys.argv) > 5):
        print("Unused arguments:  %s" % ' '.join(sys.argv[5: ]))

    # set environmental variable used in the index.Rmd files
    os.environ['STAN_DOCS_VERSION'] = '.'.join([str(stan_major), str(stan_minor)])

    for doc in docset:
        make_docs(docspath, stan_version, doc, formats)


if __name__ == "__main__":
    main()
