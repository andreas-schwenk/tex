# tex - a tiny TeX engine
# (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
# License: GPL-3.0-or-later

# this file translates params.csv and glyphs.csv to lib/src/tab.dart

res = """/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

// !!! THIS FILE WAS AUTO-CREATED BY meta/run.py !!!
// !!! ANY CHANGES IN THIS FILE WILL BE OVERWRITTEN !!!

"""

f = open("meta/macros.csv")
lines = f.readlines()
f.close()
res += "const Map<String, String> macros = {\n"
for i, line in enumerate(lines):
    line = line.strip()
    if line.startswith("#") or len(line) == 0:
        continue
    tokens = line.split(";")
    if len(tokens) < 2:
        print(
            "ERROR:gen.py: macros.csv:"
            + str(i)
            + ": the following line is not well formatted:"
        )
        print(line)
        exit(-1)
    command = tokens[0].strip().replace("\\", "\\\\")
    replacement = tokens[1].strip().replace("\\", "\\\\")
    res += '  "' + command + '": "' + replacement + '",\n'
res += "};\n\n"

f = open("meta/params.csv")
lines = f.readlines()
f.close()
res += "const Map<String, int> numArgs = {\n"
for i, line in enumerate(lines):
    line = line.strip()
    if line.startswith("#") or len(line) == 0:
        continue
    tokens = line.split(";")
    if len(tokens) < 2:
        print(
            "ERROR:gen.py: params.csv:"
            + str(i)
            + ": the following line is not well formatted:"
        )
        print(line)
        exit(-1)
    command = tokens[0].strip().replace("\\", "\\\\")
    replacement = tokens[1].strip()
    res += '  "' + command + '": ' + replacement + ",\n"
res += "};\n\n"

f = open("meta/functions.csv")
lines = f.readlines()
f.close()
res += "const Set<String> functions = {\n"
for i, line in enumerate(lines):
    line = line.strip()
    if line.startswith("#") or len(line) == 0:
        continue
    tokens = line.split(";")
    if len(tokens) < 1:
        print(
            "ERROR:gen.py: functions.csv:"
            + str(i)
            + ": the following line is not well formatted:"
        )
        print(line)
        exit(-1)
    function = tokens[0].strip().replace("\\", "\\\\")
    res += '  "' + function + '",\n'
res += "};\n\n"

f = open("meta/glyphs.csv")
lines = f.readlines()
f.close()
res += "const table = {\n"
for line in lines:
    line = line.strip()
    if line.startswith("#") or len(line) == 0:
        continue
    tokens = line.split(";")
    if len(tokens) < 5:
        print(
            "ERROR:gen.py:glyphs.csv:"
            + str(i)
            + ": the following line is not well formatted:"
        )
        print(line)
        exit(-1)
    command = tokens[0].strip().replace("\\", "\\\\")
    mjx_id = tokens[1].strip()
    width = tokens[2].strip()
    height = tokens[3].strip()
    delta_x = tokens[4].strip()
    res += (
        '  "'
        + command
        + '": {"code": "'
        + mjx_id.replace("MJX-1-", "")
        + '", "w": '
        + width
        + ', "h": '
        + height
        + ', "d": '
        + delta_x
        + "},\n"
    )
res += "};\n"

f = open("lib/src/tab.dart", "w")
f.write(res)
f.close()
