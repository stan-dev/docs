#!/usr/bin/env python
"""
Use quarto to render pdfs for specified MAJOR, MINOR version
for all (default) or specified document (optional).

Quarto builds in subdirectory of `src`, and then
resulting pdf is moved to directory named `docs/MAJOR_MINOR`
Document pdf has subtitle "Version MAJOR dot MINOR".
Directory and filenames have version string "MAJOR underscore MINOR".

arg 1: MAJOR version number
arg 2: MINOR version number
optional arg 3: specified document or "all"
"""

import glob
import os
import os.path
import shutil
import subprocess
import sys
import contextlib

all_docs = ("functions-reference", "reference-manual", "stan-users-guide", "cmdstan-guide")

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

def safe_rm(fname):
    if os.path.exists(fname):
        os.remove(fname)

def make_docs(docspath, version, document):
    path = os.getcwd()
    srcpath = os.path.join(path, "src", document)
    with pushd(srcpath):
        pdfname = ''.join([document,'-',version,".pdf"])
        print('render {} as {}'.format(document, pdfname))
        command = ' '.join(['quarto render',
                                '--output-dir _pdf',
                                '--output', pdfname]) 
        print(command)
        shexec(command)
        outpath = os.path.join(srcpath, '_pdf', pdfname)
        safe_rm(os.path.join(docspath, pdfname))
        shutil.move(outpath, docspath)

def main():
    if sys.version_info < (3, 7):
        print('requires Python 3.7 or higher, found {}'.format(sys.version))
        sys.exit(1)
    global all_docs
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
            print("Failed to create directory %s" % docspath)
        else:
            print("Created directory %s " % docspath)

    docset = all_docs
    if (len(sys.argv) > 3):
        if (sys.argv[3] != "all"):
            if (sys.argv[3] not in docset):
                print("Expecting one of %s" % ' '.join(docset))
                sys.exit(1)
            docset = (sys.argv[3],)

    if (len(sys.argv) > 4):
        print("Unused arguments:  %s" % ' '.join(sys.argv[4: ]))

    # set environmental variable used in the index.Rmd files
    os.environ['STAN_DOCS_VERSION'] = '.'.join([str(stan_major), str(stan_minor)])

    for doc in docset:
        make_docs(docspath, stan_version, doc)


if __name__ == "__main__":
    main()
