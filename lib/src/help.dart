/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

int min(int x, int y) {
  return x < y ? x : y;
}

int max(int x, int y) {
  return x > y ? x : y;
}

String indentString(String text, int numSpaces) {
  var lines = text.split("\n");
  var s = '';
  for (var line in lines) {
    for (var i = 0; i < numSpaces; i++) {
      s += ' ';
    }
    s += '$line\n';
  }
  return s;
}
