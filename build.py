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
    returncode = subprocess.check_output(command, shell=True)
    return 0

def safe_rm(fname):
    if os.path.exists(fname):
        os.remove(fname)

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
            shutil.rmtree(htmlpath, ignore_errors=True)
            command = ' '.join(["mv _book", htmlpath])
            shexec(command)
        else:
            [safe_rm(f) for f in ("stan-manual.css", "_main.rds")]
            shutil.rmtree("_book", ignore_errors=True)

def make_index_page(docset, formats):
    # TODO: generate index.md based on current and new docs
    # command = "Rscript -e \"bookdown::render_book(\'index.md\', output_format=\'bookdown::html_page\')\""
    return

def make_stan_functions(sfpath):
    path = os.getcwd()
    rmdpath = os.path.join(path, "src", "functions-reference/")
    command = "grep --no-filename 'hyperpage' " + rmdpath + "*.Rmd > " + sfpath
    shexec(command)
    f = open(sfpath, "r+")
    text = f.read()
    text = text.replace('\\index{{\\tt \\bfseries ', '')
    text = text.replace('}!{\\tt ', '')
    text = text.replace('}|hyperpage}', '')
    text = text.replace('\\_', '_')
    text = text.replace(':', ';')
    text = text.replace('  (', ';(')
    text = text.replace(' (', ';(')
    text = text.replace('\\textbar\\', ',')
    text = text.replace(' }!sampling statement|hyperpage}', ';~; real')
    text = text.replace('~|~/|', '')
    text = text.replace('operator_compound_add', 'operator+=')
    text = text.replace('operator_compound_subtract', 'operator-=')
    text = text.replace('operator_compound_multiply', 'operator*=')
    text = text.replace('operator_compound_divide', 'operator/=')
    text = text.replace('operator_compound_elt_multiply', 'operator.*=')
    text = text.replace('operator_compound_elt_divide', 'operator./=')
    text = text.replace('operator_subtract', 'operator-')
    text = text.replace('operator_add', 'operator+')
    text = text.replace('operator_multiply', 'operator*')
    text = text.replace('operator_divide', 'operator\\')
    text = text.replace('operator_elt_divide', 'operator.\\')
    text = text.replace('operator_elt_multiply', 'operator.*')
    text = text.replace('operator_left_div', 'operator\\')
    text = text.replace('operator_logical_and', 'operator&&')
    text = text.replace('operator_logical_or', 'operator||')
    text = text.replace('operator_logical_greater_than_equal', 'operator>=')
    text = text.replace('operator_logical_less_than_equal', 'operator<=')
    text = text.replace('operator_logical_greater_than', 'operator>')
    text = text.replace('operator_logical_less_than', 'operator<')
    text = text.replace('operator_logical_not_equal', 'operator!=')
    text = text.replace('operator_logical_equal', 'operator==')
    text = text.replace('operator_mod', 'operator%')
    text = text.replace('operator_negation', 'operator!')
    text = text.replace('operator_pow', 'operator^')
    text = text.replace('operator_transpose', "operator'")
    f.write(text)
    f.close()
    command = "sort " + sfpath + " | uniq > " + sfpath + ".bak"
    shexec(command)
    command = "echo '# This file is semicolon delimited\nStanFunction;Arguments;ReturnType' > " + sfpath
    shexec(command)
    command = "grep --invert-match 'bfseries' " + sfpath + ".bak >> " + sfpath
    shexec(command)
    command = "rm " + sfpath + ".bak"
    shexec(command)
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

    make_stan_functions(docspath + "/stan-functions.txt")


if __name__ == "__main__":
    main()
