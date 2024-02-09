import requests
import re
import time
import sys
import pathlib


DOCS_DIR = pathlib.Path(__file__).parent / 'docs'
LINK_FINDER = re.compile(r'version,\s+<a\s+href="(.*)">view\s+current')

links = set()

def walk_html():
    for version in DOCS_DIR.iterdir():
        if version.is_dir():
            yield from version.glob('**/*.html')

def find_links():
    for html in walk_html():
        with open(html, 'r') as f:
            for match in LINK_FINDER.finditer(f.read()):
                links.add(match.group(1))

def check_links():
    broken = 0
    for (i, link) in enumerate(links):
        if i % 50 == 0:
            # don't spam the server
            time.sleep(2)
        response = requests.head(link)
        if response.status_code != 200:
            broken += 1
            print(f'Broken link: {link}')
    return broken

if __name__ == '__main__':
    find_links()
    print(f"Checking {len(links)} links...")
    if check_links():
        sys.exit(1)
    else:
        print("Done.")
