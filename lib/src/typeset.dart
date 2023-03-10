/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'config.dart';
import 'help.dart';
import 'node.dart';
import 'rendered_node.dart';
import 'tab.dart';

/// Typesets node [node].
void typeset(TeXNode node) {
  switch (node.type) {
    case TeXNodeType.list:
      {
        double x = 0;
        double y = 0;
        for (var i = 0; i < node.items.length; i++) {
          var item = node.items[i];
          typeset(item);
          item.translate(x, y);
          node.renderedNodes.addAll(item.renderedNodes);
          x += item.width + item.postfixSpacing;
        }
        break;
      }
    case TeXNodeType.unary:
      {
        var tk = node.tk;
        if (table.containsKey(tk) && tk != '\\sqrt') {
          // -------- glyphs from tabular --------
          var entry = table[tk] as Map<Object, Object>;
          var rtn = RenderedTeXNode();
          rtn.tk = node.tk;
          rtn.svgPathId = entry["code"] as String;
          if (entry.containsKey("d")) {
            rtn.x = (entry["d"] as int).toDouble(); // delta x
          }
          rtn.width = (entry["w"] as int).toDouble();
          rtn.height = standardFontHeight;
          node.renderedNodes.add(rtn);
          node.calcGeometry();
        } else if (["\\sin", "\\cos", "\\exp", "\\tan"].contains(tk)) {
          // -------- functions --------
          // TODO: store list (sin, cos, ...) into config file under /meta/
          node.type = TeXNodeType.list;
          for (var i = 0; i < tk.length - 1; i++) {
            var n = TeXNode(TeXNodeType.unary, []);
            n.tk = '\\text{${tk[i + 1]}}';
            node.items.add(n);
          }
          typeset(node);
          node.calcGeometry();

          // TODO
        } else if (tk == "\\mathbb" || tk == "\\mathcal" || tk == "\\text") {
          // -------- font --------
          setFont(node.args[0], tk);
          typeset(node.args[0]);
          node.renderedNodes.addAll(node.args[0].renderedNodes);
          node.calcGeometry();
        } else if (tk == "\\frac") {
          var numerator = node.args[0];
          var denominator = node.args[1];
          typeset(numerator);
          typeset(denominator);
          numerator.scale(0.7071, 0.7071);
          numerator.translate(
              0, 600 - numerator.minY); // TODO: add constant to config.dart
          denominator.scale(0.7071, 0.7071);
          denominator.translate(
              0, 150 - denominator.height); // TODO: add constant to config.dart
          node.renderedNodes.addAll(numerator.renderedNodes);
          node.renderedNodes.addAll(denominator.renderedNodes);
          node.calcGeometry();
          numerator.translate((node.width - numerator.width) / 2.0, 0);
          denominator.translate((node.width - denominator.width) / 2.0, 0);
          node.calcGeometry();
          var rtn = RenderedTeXNode();
          rtn.svgPathId = '!fraction';
          rtn.width = node.width;
          rtn.y = 240; // TODO: add constant to config.dart
          node.renderedNodes.add(rtn);
          node.postfixSpacing = 200; // TODO: add constant to config.dart
        } else if (tk == "\\sqrt") {
          // root
          var root = RenderedTeXNode();
          var entry = table[tk] as Map<Object, Object>;
          root.svgPathId = entry["code"] as String;
          root.width = (entry["w"] as int).toDouble();
          node.renderedNodes.add(root);
          // arg
          var arg = node.args[0];
          typeset(arg);
          arg.translate(root.width, 0);
          node.renderedNodes.addAll(arg.renderedNodes);
          // overline
          var overline = RenderedTeXNode();
          overline.svgPathId = '!sqrt';
          overline.width = arg.width;
          overline.x = root.width;
          overline.y =
              arg.minY + arg.height + 200; // TODO: add constant to config.dart
          node.renderedNodes.add(overline);
          // scale root
          root.yScaling =
              overline.y / 780.0; // TODO: add constant to config.dart
          node.calcGeometry();
        } else {
          // -------- error --------
          throw Exception("unknown token '$tk'");
        }
        break;
      }
    case TeXNodeType.environment:
      {
        switch (node.tk) {
          case "pmatrix":
            {
              // matrix
              double horizontalPadding =
                  500.0; // TODO: depends on concrete matrix???
              double verticalPadding = 200.0;
              List<TeXNode> elements = [];
              int rows = -1;
              int cols = -1;
              int i = 0;
              int j = 0;
              TeXNode element = TeXNode(TeXNodeType.list, []);
              for (var item in node.items) {
                if (item.tk == "&") {
                  elements.add(element);
                  element = TeXNode(TeXNodeType.list, []);
                  j++;
                } else if (item.tk == "\\\\") {
                  elements.add(element);
                  element = TeXNode(TeXNodeType.list, []);
                  if (cols < 0) {
                    cols = j + 1;
                  } else if (cols != j + 1) {
                    throw Exception(
                        "matrix has inconsistent number of columns");
                  }
                  j = 0;
                  i++;
                } else {
                  element.items.add(item);
                }
              }
              elements.add(element);
              rows = i + 1;
              for (var element in elements) {
                typeset(element);
                node.renderedNodes.addAll(element.renderedNodes);
              }
              List<double> colWidths = List.generate(cols, (index) => 0.0);
              List<double> rowHeights = List.generate(rows, (index) => 0.0);
              for (var i = 0; i < rows; i++) {
                for (var j = 0; j < cols; j++) {
                  var e = elements[i * cols + j];
                  if (e.width > colWidths[j]) {
                    colWidths[j] = e.width;
                  }
                  if (e.height > rowHeights[i]) {
                    // TODO: not calculated correctly!!
                    rowHeights[i] = e.height;
                  }
                }
              }
              double totalWidth =
                  sum(colWidths) + (cols - 1).toDouble() * horizontalPadding;
              double totalHeight =
                  sum(rowHeights) + (rows - 1) * verticalPadding;
              var x = 0.0;
              var y = 0.0;
              for (var i = rows - 1; i >= 0; i--) {
                for (var j = 0; j < cols; j++) {
                  var e = elements[i * cols + j];
                  e.translate(x + ((colWidths[j] - e.width) / 2.0).round(), y);
                  x += colWidths[j] + horizontalPadding;
                }
                x = 0;
                y += rowHeights[i] + verticalPadding; // TODO!!
              }

              // "("
              var leftParenthesis = RenderedTeXNode();
              var entry = table["("] as Map<Object, Object>;
              leftParenthesis.svgPathId = entry["code"] as String;
              leftParenthesis.width = (entry["w"] as int).toDouble();
              leftParenthesis.yScaling = totalHeight / 900;
              leftParenthesis.y -= 120 * leftParenthesis.yScaling;
              // ")""
              var rightParenthesis = RenderedTeXNode();
              entry = table[")"] as Map<Object, Object>;
              rightParenthesis.svgPathId = entry["code"] as String;
              rightParenthesis.width = (entry["w"] as int).toDouble();
              rightParenthesis.yScaling = totalHeight / 900; // TODO
              rightParenthesis.x = leftParenthesis.width + totalWidth;
              rightParenthesis.y -= 120 * rightParenthesis.yScaling; // TODO
              // translate matrix
              node.translate(leftParenthesis.width,
                  (standardFontHeight - totalHeight) / 2.0);
              // add parentheses at the end to prevent simultaneous
              // transformation with matrix.
              node.renderedNodes.add(leftParenthesis);
              node.renderedNodes.add(rightParenthesis);
              node.calcGeometry();
              node.postfixSpacing = 150; // TODO
              break;
            }
          default:
            throw Exception("unknown environment $node.tk");
        }
      }
  }
  if (node.sup != null) {
    var dy = 350.0; // TODO: move to config.dart
    var sup = node.sup as TeXNode;
    typeset(sup);
    sup.scale(0.7071, 0.7071);
    sup.translate(node.width, dy);
    node.renderedNodes.addAll(sup.renderedNodes);
  }
  if (node.sub != null) {
    var dy = -150.0; // TODO: move to config.dart
    var sub = node.sub as TeXNode;
    typeset(sub);
    sub.scale(0.7071, 0.7071);
    sub.translate(node.width, dy);
    node.renderedNodes.addAll(sub.renderedNodes);
  }
  node.calcGeometry();
}

/// Replaces all TeX nodes tokens starting from node [node] recursively by font
/// [font].
///
/// Example: node token "A" is replaced by "\mathbb{A}", in case font is
/// "\mathbb".
void setFont(TeXNode node, String font) {
  if (node.tk.isNotEmpty) node.tk = '$font{${node.tk}}';
  for (var arg in node.args) {
    setFont(arg, font);
  }
  for (var item in node.items) {
    setFont(item, font);
  }
}
