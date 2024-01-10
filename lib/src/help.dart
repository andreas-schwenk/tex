/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// Returns the minimum of two values [x] and [y].
double min(double x, double y) {
  return x < y ? x : y;
}

/// Returns the maximum of two values [x] and [y].
double max(double x, double y) {
  return x > y ? x : y;
}

/// Returns the sum of a list of values.
double sum(List<double> l) {
  var s = 0.0;
  for (var li in l) {
    s += li;
  }
  return s;
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

/// Encodes an XML string.
String xmlStringEncode(String s) {
  return s
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll('\'', '&apos;')
      .replaceAll('&', '&amp;');
}
