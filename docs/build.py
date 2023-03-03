# tex - a tiny TeX engine
# (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
# License: GPL-3.0-or-later

# This script updates the Script version numbers in file "index.html"
# to force browsers to load the most recent version.

import time

# get unit time
unix_time = int(time.time())

# read index.html
f = open("index.html", "r")
lines = f.readlines()
f.close()

# replace version number(s)
for i, line in enumerate(lines):
    if '?version=' in line:
        tokens = line.split('?')
        lines[i] = tokens[0] + '?version=' + str(unix_time) + '"></script>\n'

# write index.html
f = open("index.html", "w")
f.write("".join(lines))
f.close()
