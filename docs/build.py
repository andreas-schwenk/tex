# tex - a tiny TeX engine
# (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
# License: GPL-3.0-or-later

import time

# --------
# Update the version number attribute(s) in given files,
# to force browsers to load the most recent version.
# --------

# get unix time
unix_time = int(time.time())

# for all files
for file in ["index.html", "compare.html"]:

    # read file
    f = open(file, "r")
    lines = f.readlines()
    f.close()

    # replace version number(s)
    for i, line in enumerate(lines):
        if '?version=' in line:
            tokens = line.split('?')
            lines[i] = tokens[0] + '?version=' + str(unix_time) + '"></script>\n'

    # write file
    f = open(file, "w")
    f.write("".join(lines))
    f.close()

# --------
# Convert the changelog for the website.
# --------

# read file
f = open("../CHANGELOG.md", "r")
lines = f.readlines()
f.close()

# create HTML
output = ''
for line in lines:
    line = line[:-1]
    if line.startswith('##'):
        if len(output) > 0:
            output += '</ul>\n'
        output += '<h3>' + line[3:] + '</h3>\n<ul>\n'
    elif line.startswith('-'):
        output += '  <li>' + line[1:].strip() + '</li>\n'
output += '</ul>\n'

# write file
f = open("changelog.txt", "w")
f.write(output)
f.close()
