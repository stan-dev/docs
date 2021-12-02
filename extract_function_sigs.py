#!/usr/bin/env python
"""
Extract function signatures from html comments in markdown.
"""

import glob
import os
import os.path
import sys
import contextlib
from lxml import html
import requests
import re

@contextlib.contextmanager
def pushd(new_dir):
    previous_dir = os.getcwd()
    os.chdir(new_dir)
    yield
    os.chdir(previous_dir)


def main():
    if len(sys.argv) > 2:
        stan_major = int(sys.argv[1])
        stan_minor = int(sys.argv[2])
    else:
        page = requests.get('https://mc-stan.org/docs/functions-reference/index.html')
        if page.status_code == 404:
            print('Stan version not found! Add 2 arguments <MAJOR> <MINOR> version numbers')
            sys.exit(1)
            
        tree = html.fromstring(page.content)  
        stan_url = tree.xpath('/html/body/a/@href')
        x = re.findall(r'[0-9]+', stan_url[0])
        stan_major = int(x[0])
        stan_minor = int(x[1])

    sigs = set()
    ref_dir = os.path.join('src', 'functions-reference')
    with pushd(ref_dir):
        for file in glob.glob('*.Rmd'):
            print(file)
            with open(file) as rmd_file:
                lines = rmd_file.readlines()
                for line in lines:
                    if line.startswith('<!-- '):
                        line = line.lstrip('<!- ')
                        parts = [x.strip(' ~') for x in line.split(';')]
                        if len(parts) == 3:
                            parts[1] = parts[1]
                            sigs.add('{}; ~; {}'.format(parts[1], parts[0]))
                        elif len(parts) == 4:
                            sigs.add('{}; {}; {}'.format(parts[1], parts[2], parts[0]))
                        else:
                            print('not a function sig: {}'.format(line))

    outfile_name = 'stan-functions-{}_{}.txt'.format(str(stan_major), str(stan_minor))
    with open(outfile_name, 'w') as outfile:
        outfile.write('# This file is semicolon delimited\n')
        outfile.write('StanFunction; Arguments; ReturnType\n')
        for sig in sorted(sigs):
            outfile.write(sig)
            outfile.write('\n')


if __name__ == '__main__':
    main()
