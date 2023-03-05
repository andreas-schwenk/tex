/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// Logical parts of a TeX string.
class TeXNode {
  /// Is node a list.
  bool isList;

  /// Is node a fractions (e.g. "\\frac{x}{y}").
  bool isFraction = false;

  /// The children.
  List<TeXNode> items = [];

  /// The arguments (e.g. "x" and "y" are the args of "\\frac{x}{y}").
  List<TeXNode> args = [];

  /// The nodes token, i.e. text.
  String tk = '';

  /// The optional subscript node.
  TeXNode? sub;

  /// The optional superscript node.
  TeXNode? sup;

  /// The scaling.
  double scaling = 1.0;

  /// The x coordinate.
  int x = 0;

  /// The left padding.
  int dx = 0;

  /// The x coordinate.
  int y = 0;

  /// The width
  int width = 0;

  /// The height
  int height = 0;

  /// The ID of map "svgData" in file svg.dart.
  String svgPathId = '';

  TeXNode(this.isList, this.items);

  @override
  String toString() {
    if (isList) {
      var s = '{';
      for (var i = 0; i < items.length; i++) {
        if (i > 0) s += ' ';
        var item = items[i];
        s += item.toString();
      }
      s += '}';
      return s;
    } else {
      var s = tk;
      if (sub != null) {
        s += '_${sub.toString()}';
      }
      if (sup != null) {
        s += '^${sup.toString()}';
      }
      if (args.isNotEmpty) {
        for (var arg in args) {
          s += ' %arg ${arg.toString()}';
        }
      }
      return s;
    }
  }
}
