/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'config.dart';
import 'help.dart';
import 'node.dart';
import 'tab.dart';

/// Typesets node [node], starting from base coordinates [baseX] and [baseY]
/// with [scaling].
void typeset(TeXNode node, int baseX, int baseY, [scaling = 1.0]) {
  switch (node.type) {
    case TeXNodeType.list:
      {
        node.x = baseX;
        node.y = baseY;
        node.scaling = scaling;
        int x = 0;
        int y = 0;
        var lastWasSin = false;
        for (var i = 0; i < node.items.length; i++) {
          var item = node.items[i];
          if (lastWasSin && ["\\{", "[", "("].contains(item.tk) == false) {
            x += 300;
          }
          typeset(item, x, y, scaling);
          x += item.width;
          node.height = max(node.height, item.height);
          lastWasSin = item.tk == '\\sin'; // TODO: cos, ...
        }
        node.width = x;
        break;
      }
    case TeXNodeType.unary:
      {
        int x = node.x = baseX;
        int y = node.y = baseY;
        var tk = node.tk;
        if (table.containsKey(tk) && tk != '\\sqrt') {
          // -------- glyphs from tabular --------
          var entry = table[tk] as Map<Object, Object>;
          node.svgPathId = entry["code"] as String;
          x += entry["w"] as int;
          if (entry.containsKey("d")) {
            node.dx = entry["d"] as int;
          }
          node.height = standardFontHeight;
        } else if (tk == "\\mathbb" || tk == "\\mathcal" || tk == "\\text") {
          // -------- font --------
          setFont(node.args[0], tk);
          typeset(node.args[0], x - baseX, y, scaling);
          x += node.args[0].width;
          node.height = node.args[0].height;
        } else if (["\\sin", "\\cos", "\\exp", "\\tan"].contains(tk)) {
          // -------- functions --------
          // TODO: store list (sin, cos, ...) into config file under /meta/
          if (x > 0) x += 300;
          node.type = TeXNodeType.list;
          for (var i = 0; i < tk.length - 1; i++) {
            var n = TeXNode(TeXNodeType.unary, []);
            n.tk = '\\text{${tk[i + 1]}}';
            node.items.add(n);
          }
          typeset(node, x, y, scaling);
          x += node.width;
        } else if (tk == '\\sqrt') {
          // -------- sqrt --------
          var entry = table[tk] as Map<Object, Object>;
          node.svgPathId = entry["code"] as String;
          x += entry["w"] as int;
          var arg = node.args[0];
          if (arg.type == TeXNodeType.unary) {
            node.args[0] = arg = TeXNode(TeXNodeType.list, [arg]);
          }
          typeset(arg, x - baseX, y, scaling);
          arg.isSqrt = true;
          x += node.width + arg.width;
          node.height = max(arg.height + 50, 850);
        } else if (tk == '\\frac') {
          // -------- fractions --------
          node.isFraction = true;
          var numerator = node.args[0];
          var denominator = node.args[1];
          if (numerator.type == TeXNodeType.unary) {
            node.args[0] = numerator = TeXNode(TeXNodeType.list, [numerator]);
          }
          if (denominator.type == TeXNodeType.unary) {
            node.args[1] =
                denominator = TeXNode(TeXNodeType.list, [denominator]);
          }
          typeset(numerator, 0, 0, 0.7071);
          typeset(denominator, 0, 0, 0.7071);
          var wn = numerator.width; // width numerator
          var wd = denominator.width; // width denominator
          node.width = max(wn, wd);
          numerator.x = ((node.width - numerator.width) * 0.7071 / 2.0).round();
          denominator.x =
              ((node.width - denominator.width) * 0.7071 / 2.0).round();
          x += (node.width * 0.7071).round();
          numerator.y += 400;
          denominator.y -= 400; // TODO: must depend on args[1].height
          node.height =
              ((numerator.y + numerator.height - denominator.y) * 0.7071)
                  .round();
        } else {
          // -------- error --------
          throw Exception("unimplemented token '$tk'");
        }
        if (node.sub != null) {
          // -------- subscript --------
          var dy = -150;
          var sub = node.sub as TeXNode;
          typeset(sub, x - baseX, dy, 0.7071);
          x += (sub.width * 0.7071).round();
          //var height =  ;//(-dy + sub.height * 0.7071).round();
          node.height -= dy; //max(node.height, height);
        }
        if (node.sup != null) {
          // -------- superscript --------
          var dy = 350;
          var sup = node.sup as TeXNode;
          typeset(sup, x - baseX, dy, 0.7071);
          x += (sup.width * 0.7071).round();
          var height = (dy + sup.height * 0.7071).round();
          node.height = max(node.height, height);
        }
        node.width = x - baseX;
        break;
      }
    case TeXNodeType.env:
      {
        switch (node.tk) {
          case "pmatrix":
            {
              var horizontalPadding =
                  500; // TODO: depends on concrete matrix???
              var verticalPadding = 200;
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
                typeset(element, 0, 0);
              }
              List<int> colWidths = List.generate(cols, (index) => 0);
              List<int> rowHeights = List.generate(rows, (index) => 0);
              for (var i = 0; i < rows; i++) {
                for (var j = 0; j < cols; j++) {
                  var e = elements[i * cols + j];
                  if (e.width > colWidths[j]) {
                    colWidths[j] = e.width;
                  }
                  if (e.height > rowHeights[i]) {
                    rowHeights[i] = e.height;
                  }
                }
              }
              int totalWidth = sum(colWidths) + (cols - 1) * horizontalPadding;
              int totalHeight = sum(rowHeights) + (rows - 1) * verticalPadding;
              var x = 0;
              var y = 0;
              for (var i = rows - 1; i >= 0; i--) {
                for (var j = 0; j < cols; j++) {
                  var e = elements[i * cols + j];
                  e.x = x + ((colWidths[j] - e.width) / 2.0).round();
                  e.y = y;
                  x += colWidths[j] + horizontalPadding;
                }
                x = 0;
                y += rowHeights[i] + verticalPadding; // TODO!!
              }
              node.type = TeXNodeType.list;
              node.items = elements;
              node.width = totalWidth;
              node.height = totalHeight;
              node.x = baseX;
              node.y =
                  baseY - ((totalHeight - standardFontHeight) / 2.0).round();
              break;
            }
          default:
            throw Exception("unknown env $node.tk");
        }
        break;
      }
  }
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
