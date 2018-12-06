#!/usr/bin/env python

"""
build and tag specified document(s)
in specified format(s)
with specified MAJOR, MINOR version
"""

import os
import os.path
import shutil
import subprocess
import sys
import contextlib

@contextlib.contextmanager
def pushd(new_dir):
    previous_dir = os.getcwd()
    os.chdir(new_dir)
    yield
    os.chdir(previous_dir)

def shexec(command):
    print(command)
    returncode = subprocess.call(command, shell=True)
    if returncode != 0:
        raise FailedCommand(returncode, command)
    return returncode

def make_docs(docspath, version, document, format="all"):
    path = os.getcwd()
    srcpath = os.path.join(path, "src", document)
    with pushd(srcpath):
        if (format == "all" or format == "html"):
            command = "Rscript -e \"bookdown::render_book(\'index.Rmd\', output_format=\'bookdown::gitbook\')\""
            shexec(command)
        if (format == "all" or format == "pdf"):
            command = "Rscript -e \"bookdown::render_book(\'index.Rmd\', output_format=\'bookdown::pdf_book\')\""
            shexec(command)
            srcpdf = os.path.join(srcpath, "_book", "_main.pdf")
            pdfname = ''.join([document,'-',version,".pdf"])
            pdfpath = os.path.join(docspath, pdfname)
            shutil.move(srcpdf, pdfpath)
        shexec("rm _main.rds _book/*.md")
        if (format == "all" or format == "html"):
            htmlpath = os.path.join(docspath, document)
            command = ' '.join(["mv _book", htmlpath])
            shexec(command)
        else:
            shexec("rm -r _book")

def main():
    if (len(sys.argv) > 2):
        stan_major = long(sys.argv[1])
        stan_minor = long(sys.argv[2])
    else:
        print "Expecting arguments MAJOR MINOR version numbers"
        sys.exit(1)

    stan_version = '_'.join([str(stan_major), str(stan_minor)])
    path = os.getcwd()
    docspath = os.path.join(path, "docs", stan_version)
    print "The versioned docs dir is %s" % docspath
    if (not(os.path.exists(docspath))):
        try:  
            os.makedirs(docspath);
        except OSError:  
            print "Creation of the directory %s failed" % docspath
        else:  
            print "Successfully created the directory %s " % docspath

    docset = ("functions-reference", "reference-manual", "bayes-stats-stan")
    if (len(sys.argv) > 3):
        if (sys.argv[3] != "all"):
            if (sys.argv[3] not in docset):
                print "Expecting one of %s" % ' '.join(docset)
                sys.exit(1)
            docset = (sys.argv[3],)

    formats = ("html", "pdf")
    if (len(sys.argv) > 4):
        if (sys.argv[4] != "all"):
            if (sys.argv[4] not in formats):
                print "Expecting one of %s" % ' '.join(formats)
                sys.exit(1)
            formats = (sys.argv[4],)

    if (len(sys.argv) > 5):
        print "Unused arguments:  %s" % ' '.join(sys.argv[5: ])

    for doc in docset:
        print doc
        for form in formats:
            print form
            make_docs(docspath, stan_version, doc, form)
        
if __name__ == "__main__":
    main()
