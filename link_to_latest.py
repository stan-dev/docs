#!/usr/bin/python

# update all html pages in a document
# bookdown-generated HTML page content is in <section> element
# for each file, insert link to latest at beginning of page section

import glob
import os
import re
import sys
import contextlib

summary_template = '<li style="font-size:110%; font-weight:400; font-family: Verdana, Helvetica, sans; line-height:1.4; margin: 0.5em 0 0 1em">TITLE</li>'

redirect_template = '''
<div>
This is an old version, <a href="https://mc-stan.org/docs/DIRNAME/FILENAME">view current version</a>.
</div>
'''

redirect_href = '<a href="https://mc-stan.org/docs/DIRNAME/index.html" style="color:#4183C4">'

@contextlib.contextmanager
def pushd(new_dir):
    previous_dir = os.getcwd()
    os.chdir(new_dir)
    yield
    os.chdir(previous_dir)

def main():

    dir = sys.argv[1]
    title = sys.argv[2]
    dirname = os.path.split(dir)[-1]

    print('title: {}'.format(title))
    summary = summary_template.replace("TITLE",title)

    print('dir: {}'.format(dirname))
    with pushd(dir):
        files = [x for x in glob.glob("*.html")]
        for file in files:
            print(file)
            redirect_name = redirect_href.replace("DIRNAME",dirname)
            redirect_msg = redirect_template.replace("DIRNAME",dirname)
            redirect_msg = redirect_msg.replace("FILENAME",file)
            with open(file) as infile:
                with open('tmpfile', 'w') as outfile:
                    for line in infile:
                        if line.strip() == summary:
                            parts = line.strip().split('>')
                            outfile.write(parts[0])
                            outfile.write('>')
                            outfile.write(redirect_name)
                            subparts = parts[1].split('<')
                            outfile.write(subparts[0])
                            outfile.write('</a><')
                            outfile.write(subparts[1])
                            outfile.write('>\n')
                        else:
                            outfile.write(line)
                        
                        if '<section class="normal" id="section-">' in line.strip():
                            outfile.write(redirect_msg)
                            outfile.write('')
            os.replace('tmpfile',file)

if __name__ == '__main__':  
    main()
