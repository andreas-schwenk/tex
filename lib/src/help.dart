/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// Returns the minimum of two values integral [x] and [y].
int min(int x, int y) {
  return x < y ? x : y;
}

/// Returns the maximum of two values integral [x] and [y].
int max(int x, int y) {
  return x > y ? x : y;
}

/// Indents a single or multiline string [text] by [numSpaces] spaces.
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
