/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// TODO: doc
enum TeXNodeType { unary, list, env }

/// Logical parts of a TeX string.
class TeXNode {
  /// The node type;
  TeXNodeType type;

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

  /// The global left padding. Only valid for type unary.
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
  TeXNode(this.type, this.items, [this.tk = '']);

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

  /*void addToXRecursively(int value) {
    //x += value;
    for (var item in items) {
      item.addToXRecursively(value);
    }
    for (var arg in args) {
      arg.addToXRecursively(value);
    }
    if (sub != null) {
      sub?.addToXRecursively(value);
    }
    if (sup != null) {
      sup?.addToXRecursively(value);
    }
  }*/

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
    scaleGlobalCoordinates(scaling);
    translateGlobalCoordinates(x.toDouble(), y.toDouble());
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
    //double max = globalY + globalHeight;
    double max = getGlobalMinY() + globalHeight;
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
  void scaleGlobalCoordinates(double factor) {
    globalX *= factor;
    globalY *= factor;
    globalScaling *= factor;
    globalWidth *= factor;
    globalHeight *= factor;
    globalDx *= factor;
    for (var item in items) {
      item.scaleGlobalCoordinates(factor);
    }
    if (sub != null) sub?.scaleGlobalCoordinates(factor);
    if (sup != null) sup?.scaleGlobalCoordinates(factor);
    for (var arg in args) {
      arg.scaleGlobalCoordinates(factor);
    }
  }

  /// Recursively translates a node by [x] and [y].
  void translateGlobalCoordinates(double x, double y) {
    globalX += x;
    globalY += y;
    for (var item in items) {
      item.translateGlobalCoordinates(x, y);
    }
    if (sub != null) sub?.translateGlobalCoordinates(x, y);
    if (sup != null) sup?.translateGlobalCoordinates(x, y);
    for (var arg in args) {
      arg.translateGlobalCoordinates(x, y);
    }
  }

  /// Stringifies TeX node.
  @override
  String toString() {
    switch (type) {
      case TeXNodeType.unary:
        {
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
      case TeXNodeType.list:
      case TeXNodeType.env:
        {
          var s = type == TeXNodeType.env ? '\\begin{$tk}' : '{';
          for (var i = 0; i < items.length; i++) {
            if (i > 0) s += ' ';
            var item = items[i];
            s += item.toString();
          }
          s += type == TeXNodeType.env ? '\\end{$tk}' : '}';
          return s;
        }
    }
  }
}
