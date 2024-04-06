"""
Generates a alphabetical index of all the functions in the documentation.
Points to links created by the html-index.lua pandoc filter.
"""

import hashlib
import pathlib
from collections import defaultdict

import extract_function_sigs

HERE = pathlib.Path(__file__).parent

HEADER = """---
pagetitle: Alphabetical Index
---

<!-- This file is generated by gen_index.py. Do not edit it directly. -->

# Alphabetical Index
"""


def make_index_mapping(sigs):
    index = defaultdict(lambda: [])

    for name, args, returntype, file in sigs:
        sig = f"<!-- {returntype}; {name}"
        if args.strip() == "~":
            sig += " ~; "
            index_entry = "sampling statement"
        else:
            sig += f"; {args}; "
            index_entry = f"`{args} : {returntype}`"

        sig += "-->"

        sha = hashlib.sha1(sig.encode("utf-8")).hexdigest()
        link = f"{file}#index-entry-{sha}"
        index[name].append((link, index_entry))

    return index


def write_index_page(index):
    with open(HERE / "src" / "functions-reference" / "functions_index.qmd", "w") as f:
        f.write(HEADER)
        letter = "."
        for name, links in sorted(index.items(), key=lambda x: x[0].lower()):
            start = name[0].lower()
            if start != letter:
                letter = start
                f.write(f"\n## {start.upper()}\n")

            escaped_name = name.replace("\\", "\\\\").replace("*", "\\*")
            f.write(f"**{escaped_name}**:\n\n")
            for link, entry in sorted(links):
                f.write(f" - [{entry}]({link})\n")
            f.write("\n\n")


if __name__ == "__main__":
    sigs = extract_function_sigs.get_sigs()
    index = make_index_mapping(sigs)
    write_index_page(index)
