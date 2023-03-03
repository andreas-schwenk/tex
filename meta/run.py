# tex - a tiny TeX engine
# (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
# License: GPL-3.0-or-later

# this file translates params.csv and glyphs.csv to lib/src/tab.dart

res = '''/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

// !!! THIS FILE WAS AUTO-CREATED BY gen.py !!!
// !!! ANY CHANGES IN THIS FILE WILL BE OVERWRITTEN !!!

'''

f = open("meta/params.csv")
lines = f.readlines()
f.close()
res += 'const Map<String, int> numArgs = {\n'
for i, line in enumerate(lines):
    line = line.strip()
    if line.startswith('#') or len(line) == 0:
        continue
    tokens = line.split(';')
    if len(tokens) < 2:
        print("ERROR:gen.py: params.csv:" + str(i) +
              ": the following line is not well formatted:")
        print(line)
        exit(-1)
    tex = tokens[0].strip().replace('\\', '\\\\')
    num_params = tokens[1].strip()
    res += '  "' + tex + '": ' + num_params + ',\n'
res += '};\n\n'

f = open("meta/glyphs.csv")
lines = f.readlines()
f.close()
res += 'const table = {\n'
for line in lines:
    line = line.strip()
    if line.startswith('#') or len(line) == 0:
        continue
    tokens = line.split(';')
    if len(tokens) < 4:
        print("ERROR:gen.py:glyphs.csv:" + str(i) +
              ": the following line is not well formatted:")
        print(line)
        exit(-1)
    tex = tokens[0].strip().replace('\\', '\\\\')
    mjx_id = tokens[1].strip()
    width = tokens[2].strip()
    delta_x = tokens[3].strip()
    res += '  "' + tex + '": {"code": "' + mjx_id + \
        '", "w": ' + width + ', "d": ' + delta_x + '},\n'
res += '};\n\n'

f = open("lib/src/tab.dart", "w")
f.write(res)
f.close()
