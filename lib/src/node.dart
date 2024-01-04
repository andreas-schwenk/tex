/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'package:tex/src/tab.dart';

import 'glyph.dart';

/// The type of the node
enum TeXNodeType {
  /// A single token.
  unary,

  /// A list of tokens.
  list,

  /// An environment, described by \begin{..} ... \end{..} in (La)TeX.
  environment
}

/// Logical parts of a TeX string.
class TeXNode {
  /// The node type;
  TeXNodeType type;

  /// The nodes token, i.e. text.
  String tk = '';

  /// The children.
  List<TeXNode> items = [];

  /// The arguments (e.g. "x" and "y" are the args of "\\frac{x}{y}").
  List<TeXNode> args = [];

  /// The optional subscript node.
  TeXNode? sub;

  /// The optional superscript node.
  TeXNode? sup;

  /// The list of rendered glyphs.
  List<Glyph> glyphs = [];

  /// The x minimum positions of all rendered glyphs.
  double minX = 0.0;

  /// The y minimum positions of all rendered glyphs.
  double minY = 0.0;

  /// The total width of all rendered glyphs.
  double width = 0.0;

  /// The spacing after the node.
  double postfixSpacing = 0.0;

  /// The total height of all rendered glyphs.
  double height = 0.0;

  /// Constructor.
  TeXNode(this.type, this.items, [this.tk = '']);

  /// Calculates the geometry.
  void calcGeometry() {
    var count = glyphs.length;
    minX = count == 0 ? 0 : double.infinity;
    minY = count == 0 ? 0 : double.infinity;
    var maxX = count == 0 ? 0 : -double.infinity;
    var maxY = count == 0 ? 0 : -double.infinity;
    width = 0.0;
    height = 0.0;
    for (var n in glyphs) {
      if (n.x < minX) minX = n.x;
      if (n.y < minY) minY = n.y;
      if (n.x + n.width > maxX) maxX = n.x + n.width;
      if (n.y + n.height > maxY) maxY = n.y + n.height;
    }
    width = maxX - minX;
    height = maxY - minY;
  }

  /// Translates all rendered nodes.
  void translate(double x, double y) {
    minX += x;
    minY += y;
    for (var n in glyphs) {
      n.x += x;
      n.y += y;
    }
  }

  /// Scales all rendered nodes.
  void scale(double xFactor, double yFactor) {
    minX *= xFactor;
    minY *= yFactor;
    width *= xFactor;
    height *= yFactor;
    postfixSpacing *= xFactor;
    for (var n in glyphs) {
      n.xScaling *= xFactor;
      n.yScaling *= yFactor;
      n.x *= xFactor;
      n.y *= yFactor;
      n.width *= xFactor;
      n.height *= yFactor;
    }
  }

  /// Gets a set of all actually used glyphs for a [node].
  void getActuallyUsedGlyphs(Set<String> usedLetters) {
    for (var n in glyphs) {
      if (n.svgPathId.isNotEmpty && n.svgPathId.startsWith("!") == false) {
        usedLetters.add(n.svgPathId);
      }
    }
  }

  bool containsSubNode(String tk) {
    if (this.tk == tk) return true;
    for (var item in items) {
      if (item.containsSubNode(tk)) return true;
    }
    return false;
  }

  bool isFunction() {
    if (type != TeXNodeType.unary) return false;
    return functions.contains(tk);
  }

  bool isTextLike() {
    if (type != TeXNodeType.unary) return false;
    if (functions.contains(tk)) return true;
    if ((tk.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
            tk.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) ||
        (tk.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
            tk.codeUnitAt(0) <= 'z'.codeUnitAt(0))) {
      return true;
    }
    return false;
  }

  /// Stringifies TeX node.
  @override
  String toString() {
    var s = '';
    switch (type) {
      case TeXNodeType.unary:
        {
          s = tk;
          if (args.isNotEmpty) {
            for (var arg in args) {
              s += ' {%arg ${arg.toString()}} ';
            }
            s = '{$s}';
          }
          break;
        }
      case TeXNodeType.list:
      case TeXNodeType.environment:
        {
          s = type == TeXNodeType.environment ? '\\begin{$tk}' : '{';
          for (var i = 0; i < items.length; i++) {
            if (i > 0) s += ' ';
            var item = items[i];
            s += item.toString();
          }
          s += type == TeXNodeType.environment ? '\\end{$tk}' : '}';
          break;
        }
    }
    if (sub != null) {
      s += '_${sub.toString()}';
    }
    if (sup != null) {
      s += '^${sup.toString()}';
    }
    return s;
  }
}
