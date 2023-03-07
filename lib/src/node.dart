/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// Logical parts of a TeX string.
class TeXNode {
  /// Whether the object represents a list. Otherwise, it represents a node.
  bool isList;

  /// Whether the node is a fractions (e.g. "\\frac{x}{y}").
  bool isFraction = false;

  /// Whether the node is a root.
  bool isSqrt = false;

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

  /// The relative scaling.
  double scaling = 1.0;

  /// The relative x coordinate.
  int x = 0;

  /// The relative left padding.
  int dx = 0;

  /// The relative y coordinate.
  int y = 0;

  /// The relative width.
  int width = 0;

  /// The relative height.
  int height = 0;

  /// The global x coordinate
  double globalX = 0;

  /// The global left padding.
  double globalDx = 0;

  /// The global y coordinate
  double globalY = 0;

  /// The global scaling.
  double globalScaling = 1.0;

  /// The global width.
  double globalWidth = 0;

  /// The global height.
  double globalHeight = 0;

  /// The ID of map "svgData" in file svg.dart.
  String svgPathId = '';

  /// Constructor.
  TeXNode(this.isList, this.items);

  /// Gets a set of all actually used glyphs for a [node].
  void getActuallyUsedGlyphs(Set<String> usedLetters) {
    if (svgPathId.isNotEmpty) {
      usedLetters.add(svgPathId);
    }
    for (var item in items) {
      item.getActuallyUsedGlyphs(usedLetters);
    }
    for (var arg in args) {
      arg.getActuallyUsedGlyphs(usedLetters);
    }
    if (sub != null) {
      sub?.getActuallyUsedGlyphs(usedLetters);
    }
    if (sup != null) {
      sup?.getActuallyUsedGlyphs(usedLetters);
    }
  }

  /// Calculates global coordinate values
  void calculateGlobalCoordinates() {
    globalX = 0;
    globalY = 0;
    globalWidth = width.toDouble();
    globalHeight = height.toDouble();
    globalDx = dx.toDouble();
    for (var item in items) {
      item.calculateGlobalCoordinates();
    }
    if (sub != null) sub?.calculateGlobalCoordinates();
    if (sup != null) sup?.calculateGlobalCoordinates();
    for (var arg in args) {
      arg.calculateGlobalCoordinates();
    }
    scale(scaling);
    translate((x).toDouble(), y.toDouble());
  }

  /// Calculates the global minimum y coordinate value.
  double getGlobalMinY() {
    double min = globalY;
    for (var item in items) {
      double m = item.getGlobalMinY();
      if (m < min) min = m;
    }
    if (sub != null) {
      var s = sub as TeXNode;
      double m = s.getGlobalMinY();
      if (m < min) min = m;
    }
    if (sup != null) {
      var s = sup as TeXNode;
      double m = s.getGlobalMinY();
      if (m < min) min = m;
    }
    for (var arg in args) {
      double m = arg.getGlobalMinY();
      if (m < min) min = m;
    }
    return min;
  }

  /// Calculates the global maximum y coordinate value.
  double getGlobalMaxY() {
    double max = globalY + globalHeight;
    for (var item in items) {
      double m = item.getGlobalMaxY();
      if (m > max) max = m;
    }
    if (sub != null) {
      var s = sub as TeXNode;
      double m = s.getGlobalMaxY();
      if (m > max) max = m;
    }
    if (sup != null) {
      var s = sup as TeXNode;
      double m = s.getGlobalMaxY();
      if (m > max) max = m;
    }
    for (var arg in args) {
      double m = arg.getGlobalMaxY();
      if (m > max) max = m;
    }
    return max;
  }

  /// Recursively scales a node by a [factor].
  void scale(double factor) {
    globalX *= factor;
    globalY *= factor;
    globalScaling *= factor;
    globalWidth *= factor;
    globalHeight *= factor;
    globalDx *= factor;
    for (var item in items) {
      item.scale(factor);
    }
    if (sub != null) sub?.scale(factor);
    if (sup != null) sup?.scale(factor);
    for (var arg in args) {
      arg.scale(factor);
    }
  }

  /// Recursively translates a node by [x] and [y].
  void translate(double x, double y) {
    globalX += x;
    globalY += y;
    for (var item in items) {
      item.translate(x, y);
    }
    if (sub != null) sub?.translate(x, y);
    if (sup != null) sup?.translate(x, y);
    for (var arg in args) {
      arg.translate(x, y);
    }
  }

  /// Stringifies TeX node.
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
