#!/usr/bin/env python
"""
Extract function signatures from html comments in markdown.
"""

import glob
import os
import os.path
import sys
import contextlib
import subprocess

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
        outfile_name = 'stan-functions-{}_{}.txt'.format(str(stan_major), str(stan_minor))
    else:
        try:
            bash_git_hash = ['git', 'rev-parse', 'HEAD']
            git_hash = subprocess.run(bash_git_hash, stdout=subprocess.PIPE, universal_newlines=True).stdout
            outfile_name = 'stan-functions-{}.txt'.format(str(git_hash).strip())
        except OSError:
            print('Stan version not found! Add 2 arguments <MAJOR> <MINOR> version numbers')
            sys.exit(1)

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
    
    with open(outfile_name, 'w') as outfile:
        outfile.write('# This file is semicolon delimited\n')
        outfile.write('StanFunction; Arguments; ReturnType\n')
        for sig in sorted(sigs):
            outfile.write(sig)
            outfile.write('\n')


if __name__ == '__main__':
    main()
