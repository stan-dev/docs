import glob
import os
import os.path
import sys

"""
Create or update redirect files in unversioned dir 
that redirect to latest version page.
"""


contents = '''<!DOCTYPE html>
<html lang="en-US">
<head>
  <title>Redirecting&hellip;</title>
  <meta http-equiv="refresh" content="0; url=REDIRECTTO">
  <meta name="robots" content="noindex">
</head>
<body>
  <h1>Redirecting&hellip;</h1>
  <a href="REDIRECTTO">Click here if you are not redirected.</a>
</body>
</html>
'''

stan_site = "https://mc-stan.org"
stan_version = "2_18"
base_dir = "bayes-stats-stan"

def main():
    version_dir = "/".join(["docs", stan_version, base_dir])
    no_version_dir = "/".join(["docs", base_dir])

    files = [x.split("/")[-1] for x in glob.glob(version_dir + "/*.html")]
    for file in files:
        # create redirect file in no_version_dir
        filename = "/".join([no_version_dir, file])
        print filename
        r_to = "/".join([stan_site,version_dir, file])
        print r_to
        r_contents = contents.replace("REDIRECTTO",r_to)
        with open(filename, "w") as f:
            f.write(r_contents)


if __name__ == "__main__":
    main()
