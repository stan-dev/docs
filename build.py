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

all_docs = ("functions-reference", "reference-manual", "stan-users-guide")
all_formats = ("html", "pdf")

@contextlib.contextmanager
def pushd(new_dir):
    previous_dir = os.getcwd()
    os.chdir(new_dir)
    yield
    os.chdir(previous_dir)

def shexec(command):
    returncode = subprocess.call(command, shell=True)
    if returncode != 0:
        raise FailedCommand(returncode, command)
    return returncode

def safe_rm(fname):
    if os.path.exists(fname):
        os.remove(fname)

def safe_rmdir(fname):
    [safe_rm(f) for f in glob.glob(os.path.join(fname,"*"))]
    [safe_rm(f) for f in glob.glob(os.path.join(fname,".*"))]
    if os.path.exists(fname):
        os.rmdir(fname)

def make_docs(docspath, version, document, formats):
    path = os.getcwd()
    srcpath = os.path.join(path, "src", document)
    with pushd(srcpath):
        if ("pdf" in formats):
            command = "Rscript -e \"bookdown::render_book(\'index.Rmd\', output_format=\'bookdown::pdf_book\')\""
            shexec(command)
            srcpdf = os.path.join(srcpath, "_book", "_main.pdf")
            pdfname = ''.join([document,'-',version,".pdf"])
            pdfpath = os.path.join(docspath, pdfname)
            shutil.move(srcpdf, pdfpath)
        if ("html" in formats):
            command = "Rscript -e \"bookdown::render_book(\'index.Rmd\', output_format=\'bookdown::gitbook\')\""
            shexec(command)
            [safe_rm(f) for f in ("stan-manual.css", "_main.rds")]
            [safe_rm(f) for f in glob.glob(os.path.join("_book","*.md"))]
            htmlpath = os.path.join(docspath, document)
            safe_rmdir(htmlpath)
            command = ' '.join(["mv _book", htmlpath])
            shexec(command)
        else:
            [safe_rm(f) for f in ("stan-manual.css", "_main.rds")]
            safe_rmdir("_book")

def make_index_page(docset, formats):
    # TODO: generate index.md based on current and new docs
    # command = "Rscript -e \"bookdown::render_book(\'index.md\', output_format=\'bookdown::html_page\')\""
    return

def main():
    global all_docs
    global all_formats
    if (len(sys.argv) > 2):
        stan_major = long(sys.argv[1])
        stan_minor = long(sys.argv[2])
    else:
        print "Expecting arguments MAJOR MINOR version numbers"
        sys.exit(1)

    stan_version = '_'.join([str(stan_major), str(stan_minor)])
    path = os.getcwd()
    docspath = os.path.join(path, "docs", stan_version)
    if (not(os.path.exists(docspath))):
        try:  
            os.makedirs(docspath);
        except OSError:  
            print "Creation of the directory %s failed" % docspath
        else:  
            print "Successfully created the directory %s " % docspath

    docset = all_docs
    if (len(sys.argv) > 3):
        if (sys.argv[3] != "all"):
            if (sys.argv[3] not in docset):
                print "Expecting one of %s" % ' '.join(docset)
                sys.exit(1)
            docset = (sys.argv[3],)

    formats = all_formats
    if (len(sys.argv) > 4):
        if (sys.argv[4] != "all"):
            if (sys.argv[4] not in formats):
                print "Expecting one of %s" % ' '.join(formats)
                sys.exit(1)
            formats = (sys.argv[4],)

    if (len(sys.argv) > 5):
        print "Unused arguments:  %s" % ' '.join(sys.argv[5: ])

    make_index_page(docset, formats)
    for doc in docset:
        make_docs(docspath, stan_version, doc, formats)


if __name__ == "__main__":
    main()
