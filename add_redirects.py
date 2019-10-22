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

def main():
    if (len(sys.argv) > 3):
        stan_major = int(sys.argv[1])
        stan_minor = int(sys.argv[2])
    else:
        print("Expecting 3 arguments <MAJOR> <MINOR> version numbers, <docset name>")
        sys.exit(1)
    stan_version = '_'.join([str(stan_major), str(stan_minor)])
    base_dir = (sys.argv[3])

    version_dir = "/".join(["docs", stan_version, base_dir])
    no_version_dir = "/".join(["docs", base_dir])

    files = [x.split("/")[-1] for x in glob.glob(version_dir + "/*.html")]
    for file in files:
        # create redirect file in no_version_dir
        # WSL # filename = "/".join([no_version_dir, file.replace("functions-reference\\","").replace("reference-manual\\","").replace("stan-users-guide\\","")])
        filename = "/".join([no_version_dir, file])
        print(filename)
        # WSL # r_to = "/".join([stan_site,version_dir, file.replace("functions-reference\\","").replace("reference-manual\\","").replace("stan-users-guide\\","")])
        r_to = "/".join([stan_site,version_dir, file])
        print(r_to)
        r_contents = contents.replace("REDIRECTTO",r_to)
        with open(filename, "w") as f:
            f.write(r_contents)


if __name__ == "__main__":
    main()