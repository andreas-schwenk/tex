/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'rendered_node.dart';

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

  /// The list rendered glyphs.
  List<RenderedTeXNode> renderedNodes = [];

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

  // TODO: doc
  void calcGeometry() {
    minX = double.infinity;
    minY = double.infinity;
    var maxX = -double.infinity;
    var maxY = -double.infinity;
    width = 0.0;
    height = 0.0;
    for (var n in renderedNodes) {
      if (n.x < minX) minX = n.x;
      if (n.y < minY) minY = n.y;
      if (n.x + n.width > maxX) maxX = n.x + n.width;
      if (n.y + n.height > maxY) maxY = n.y + n.height;
    }
    width = maxX - minX;
    height = maxY - minY;
  }

  // Translates all rendered nodes.
  void translate(double x, double y) {
    minX += x;
    minY += y;
    for (var n in renderedNodes) {
      n.x += x;
      n.y += y;
    }
  }

  // Scales all rendered nodes.
  void scale(double xFactor, double yFactor) {
    minX *= xFactor;
    minY *= yFactor;
    width *= xFactor;
    height *= yFactor;
    postfixSpacing *= xFactor;
    for (var n in renderedNodes) {
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
    for (var n in renderedNodes) {
      if (n.svgPathId.isNotEmpty) {
        usedLetters.add(n.svgPathId);
      }
    }
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
              s += ' %arg ${arg.toString()}';
            }
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
