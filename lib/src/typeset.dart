/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'config.dart';
import 'help.dart';
import 'node.dart';
import 'glyph.dart';
import 'tab.dart';

// TODO: this should NOT be global
bool globalDisplayStyle = false;

/// Typesets node [node]. The fraction depth is defined by [fracDepth].
void typeset(TeXNode node, int fracDepth) {
  var skipSubAndSup = false;
  switch (node.type) {
    case TeXNodeType.list:
      {
        double x = 0;
        double y = 0;
        var isLastItemTextLike = false;
        var isLastItemFunction = false;
        for (var i = 0; i < node.items.length; i++) {
          var item = node.items[i];
          // the next two calls must be done BEFORE typesetting
          var isTextLike = item.isTextLike();
          var isFunction = item.isFunction();
          if (isFunction && isLastItemTextLike ||
              isTextLike && isLastItemFunction) {
            x += 150.0;
          }
          typeset(item, fracDepth);
          item.translate(x, y);
          node.glyphs.addAll(item.glyphs);
          x += item.width + item.postfixSpacing;
          isLastItemTextLike = isTextLike;
          isLastItemFunction = isFunction;
        }
        node.calcGeometry();
        break;
      }
    case TeXNodeType.unary:
      {
        var tk = node.tk;
        if (tk == '\\;' || tk == '\\,' || tk == '~') {
          // ================ spacing ================
          node.postfixSpacing = tk == '\\,' ? 150 : 300;
          return;
        } else if (functions.contains(tk)) {
          // ================ functions ================
          node.type = TeXNodeType.list;
          for (var i = 0; i < tk.length - 1; i++) {
            var n = TeXNode(TeXNodeType.unary, []);
            n.tk = '\\text{${tk[i + 1]}}';
            node.items.add(n);
          }
          typeset(node, fracDepth);
          node.calcGeometry();
          skipSubAndSup = true;
          //node.postfixSpacing = 150;
        } else if (tk == "\\mathbb" || tk == "\\mathcal" || tk == "\\text") {
          // ================ font ================
          setFont(node.args[0], tk);
          typeset(node.args[0], fracDepth);
          node.calcGeometry();
          node.glyphs.addAll(node.args[0].glyphs);
          node.calcGeometry();
        } else if (tk == "\\frac") {
          // ================ fraction ================
          var numerator = node.args[0];
          var denominator = node.args[1];
          typeset(numerator, fracDepth + 1);
          typeset(denominator, fracDepth + 1);
          var scale =
              !globalDisplayStyle || globalDisplayStyle && fracDepth > 0;
          var numeratorDeltaY = !globalDisplayStyle ||
                  fracDepth > 0 ||
                  numerator.containsSubNode("\\frac")
              ? 350
              : 750;
          if (scale) numerator.scale(0.7071, 0.7071);
          numerator.translate(0, numeratorDeltaY - numerator.minY);
          if (scale) denominator.scale(0.7071, 0.7071);
          var denominatorDeltaY = !globalDisplayStyle ||
                  fracDepth > 0 ||
                  denominator.containsSubNode("\\frac")
              ? 200
              : 0;
          denominator.translate(
              0, denominatorDeltaY - denominator.height - denominator.minY);
          node.glyphs.addAll(numerator.glyphs);
          node.glyphs.addAll(denominator.glyphs);
          node.calcGeometry();
          numerator.translate((node.width - numerator.width) / 2.0, 0);
          denominator.translate((node.width - denominator.width) / 2.0, 0);
          node.calcGeometry();
          var glyph = Glyph();
          glyph.svgPathId = '!fraction';
          glyph.width = node.width;
          glyph.y = 240;
          node.glyphs.add(glyph);
          node.postfixSpacing = 200;
        } else if (tk == "\\sqrt" || tk == "\\nroot") {
          // ================ sqrt ================
          // (note: \\nroot{X}Y is a pseudo command for \\sqrt[X]Y)
          // root
          var root = Glyph();
          var entry = table["\\sqrt"] as Map<Object, Object>;
          root.svgPathId = entry["code"] as String;
          root.width = (entry["w"] as int).toDouble();
          node.glyphs.add(root);
          // args
          var minX = 0.0;
          var nth = tk == "\\nroot" ? node.args[0] : null;
          if (nth != null) {
            typeset(nth, fracDepth);
            nth.scale(0.7071, 0.7071);
            nth.calcGeometry();
            nth.translate(-nth.width + 450, 450);
            node.glyphs.addAll(nth.glyphs);
            minX = nth.minX;
          }
          // arg
          var arg = node.args[nth == null ? 0 : 1];
          typeset(arg, fracDepth);
          arg.translate(root.width, 0);
          node.glyphs.addAll(arg.glyphs);
          // overline
          var overline = Glyph();
          overline.svgPathId = '!overline';
          overline.width = arg.width;
          overline.x = root.width;
          overline.y = arg.minY + arg.height + 200;
          node.glyphs.add(overline);
          // scale root
          root.yScaling = overline.y / 780.0;
          node.calcGeometry();
          if (minX < 0) {
            // if minimum x position of any glyph is less zero, then translate
            // everything to the right
            node.translate(-minX, 0);
            node.calcGeometry();
          }
        } else if (tk == "\\overline") {
          // ================ overline ================
          // arg
          var arg = node.args[0];
          typeset(arg, fracDepth);
          arg.translate(0, 0);
          node.glyphs.addAll(arg.glyphs);
          // overline
          var overline = Glyph();
          overline.svgPathId = '!overline';
          overline.width = arg.width;
          overline.x = 0;
          overline.y = arg.minY + arg.height + 200;
          node.glyphs.add(overline);
          node.calcGeometry();
        } else if (tk == "\\dot" ||
            tk == "\\ddot" ||
            tk == "\\hat" ||
            tk == "\\tilde") {
          // ================ dot, ddot, hat, tilde ================
          // arg
          var arg = node.args[0];
          typeset(arg, fracDepth);
          arg.translate(0, 0);
          node.glyphs.addAll(arg.glyphs);
          // dot, ddot, hat, tilde
          var accent = Glyph();
          var entry = table[tk] as Map<Object, Object>;
          accent.svgPathId = entry["code"] as String;
          accent.width = (entry["w"] as int).toDouble();
          accent.height = (entry["h"] as int).toDouble();
          accent.x = (arg.width - accent.width) / 2;
          accent.y = arg.minY + arg.height - 400;
          if (tk == "\\tilde") {
            accent.y += 300;
          }
          node.glyphs.add(accent);
          node.calcGeometry();
        } else if (tk == '\\int' || tk == '\\oint') {
          // ================ integral ================
          if (globalDisplayStyle == false) {
            tk += '-INLINE';
          }
          // int
          var entry = table[tk] as Map<Object, Object>;
          var intGlyph = Glyph();
          intGlyph.tk = node.tk;
          intGlyph.svgPathId = entry["code"] as String;
          intGlyph.width = (entry["w"] as int).toDouble();
          intGlyph.height = 1400;
          node.glyphs.add(intGlyph);
          // TODO: set node.min + node.height; this is necessary, when sub/sup are not given!
          // sub
          if (node.sub != null) {
            var sub = node.sub as TeXNode;
            typeset(sub, fracDepth);
            sub.scale(0.7071, 0.7071);
            if (globalDisplayStyle) {
              sub.translate(550, -900);
            } else {
              sub.translate(500, -350);
              node.postfixSpacing = 125.0;
            }
            sub.calcGeometry();
            node.glyphs.addAll(sub.glyphs);
          }
          // sup
          if (node.sup != null) {
            var sup = node.sup as TeXNode;
            typeset(sup, fracDepth);
            sup.scale(0.7071, 0.7071);
            if (globalDisplayStyle) {
              sup.translate(1000, 1100);
            } else {
              sup.translate(750, 600);
              node.postfixSpacing = 125.0;
            }
            sup.calcGeometry();
            node.glyphs.addAll(sup.glyphs);
          }
          node.calcGeometry();
          skipSubAndSup = true;
        } else if (tk == '\\sum' || tk == '\\prod' || tk == '\\lim') {
          // ================ sum, product, limes ================
          if (globalDisplayStyle == false && tk != '\\lim') {
            tk += '-INLINE';
          }
          // main
          var limStr = 'lim';
          double mainGlyphWidth = 0.0;
          for (var i = 0; i < 3; i++) {
            var glyph = tk == '\\lim' ? '\\text{${limStr[i]}}' : tk;
            var entry = table[glyph] as Map<Object, Object>;
            var mainGlyph = Glyph();
            mainGlyph.tk = node.tk;
            mainGlyph.x = mainGlyphWidth;
            mainGlyph.svgPathId = entry["code"] as String;
            mainGlyph.width = (entry["w"] as int).toDouble();
            mainGlyph.height = 1000;
            node.glyphs.add(mainGlyph);
            mainGlyphWidth += mainGlyph.width;
            if (tk != '\\lim') break;
          }
          var minX = 0.0;
          // sub
          if (node.sub != null) {
            var sub = node.sub as TeXNode;
            typeset(sub, fracDepth);
            sub.scale(0.7071, 0.7071);
            sub.calcGeometry();
            if (globalDisplayStyle) {
              sub.translate(
                  (mainGlyphWidth - sub.width) / 2.0,
                  tk == '\\lim'
                      ? -600
                      : -1150); // TODO: y must depend on sub dimensions
            } else {
              sub.translate(mainGlyphWidth, -300);
              node.postfixSpacing = 125.0;
            }
            node.glyphs.addAll(sub.glyphs);
            if (sub.minX < minX) minX = sub.minX;
          }
          // sup
          if (node.sup != null) {
            var sup = node.sup as TeXNode;
            typeset(sup, fracDepth);
            sup.scale(0.7071, 0.7071);
            sup.calcGeometry();
            if (globalDisplayStyle) {
              sup.translate((mainGlyphWidth - sup.width) / 2.0,
                  1200); // TODO: y must depend on sup dimensions
            } else {
              sup.translate(mainGlyphWidth, 500);
              node.postfixSpacing = 125.0;
            }
            node.glyphs.addAll(sup.glyphs);
            if (sup.minX < minX) minX = sup.minX;
          }
          node.calcGeometry();
          if (minX < 0) {
            // if minimum x position of any glyph is less zero, then translate
            // everything to the right
            node.translate(-minX, 0);
            node.calcGeometry();
          }
          skipSubAndSup = true;
          if (tk == '\\lim') {
            node.postfixSpacing = 250;
          }
        } else if (table.containsKey(tk)) {
          // ================ glyphs from tabular ================
          var entry = table[tk] as Map<Object, Object>;
          var glyph = Glyph();
          glyph.tk = node.tk;
          glyph.svgPathId = entry["code"] as String;
          if (entry.containsKey("d")) {
            glyph.x = (entry["d"] as int).toDouble(); // delta x
          }
          glyph.width = (entry["w"] as int).toDouble();
          glyph.height = (entry["h"] as int).toDouble(); //standardFontHeight;
          node.glyphs.add(glyph);
          node.calcGeometry();
        } else {
          // ================ error ================
          throw Exception("Unknown token '$tk'.");
        }
        break;
      }
    case TeXNodeType.environment:
      {
        var tokens = node.tk.split(':');
        var envType = tokens[0];
        switch (envType) {
          case "left-right":
            {
              // TODO: generate and use scaled versions of (),[],{},|.
              // content
              var content = TeXNode(TeXNodeType.list, node.items);
              typeset(content, fracDepth);
              node.glyphs.addAll(content.glyphs);
              node.calcGeometry();
              var height = node.height < 950 ? 950 : node.height;
              var yScalingFac = 950.0;
              var yOffsetFac = 0.26;
              // left parenthesis
              var leftParenthesis = Glyph();
              var leftChar = tokens[1];
              var hasLeftParenthesis = leftChar != '.';
              if (hasLeftParenthesis) {
                var entry = table[leftChar] as Map<Object, Object>;
                leftParenthesis.svgPathId = entry["code"] as String;
                leftParenthesis.width = (entry["w"] as int).toDouble();
                leftParenthesis.yScaling = height / yScalingFac;
                leftParenthesis.y -= (height - yScalingFac) * yOffsetFac;
              }
              // right parenthesis
              var rightParenthesis = Glyph();
              var rightChar = tokens[2];
              var hasRightParenthesis = rightChar != '.';
              if (hasRightParenthesis) {
                var entry = table[rightChar] as Map<Object, Object>;
                rightParenthesis.svgPathId = entry["code"] as String;
                rightParenthesis.width = (entry["w"] as int).toDouble();
                rightParenthesis.yScaling = height / yScalingFac;
                rightParenthesis.y -= (height - yScalingFac) * yOffsetFac;
              }
              // recalculate geometry
              node.translate(leftParenthesis.width, 0);
              rightParenthesis.x = leftParenthesis.width + content.width;
              if (hasLeftParenthesis) {
                node.glyphs.add(leftParenthesis);
              }
              if (hasRightParenthesis) {
                node.glyphs.add(rightParenthesis);
              }
              node.calcGeometry();
              break;
            }
          case "matrix":
          case "pmatrix":
          case "bmatrix":
          case "Bmatrix":
          case "vmatrix":
          case "cases":
            {
              // matrix
              double horizontalPadding = 1150.0;
              double verticalPadding = 650.0;
              // parse
              var itemPos = 0;
              // (a) parse alignment
              //   each char in variable "alignment" represents the alignment
              //   for a column, with "l" := left, "c" := center, "r" := right
              String alignment = "";
              if (itemPos < node.items.length &&
                  node.items[itemPos].tk == '[') {
                itemPos++;
                while (itemPos < node.items.length &&
                    node.items[itemPos].tk != ']') {
                  var a = node.items[itemPos].tk;
                  if ("lcr".contains(a) == false) {
                    throw Exception("Unknown alignment '$a'.");
                  }
                  alignment += a;
                  itemPos++;
                }
                itemPos++; // skip ']'
              }
              // (b) parse matrix
              List<TeXNode> elements = [];
              int rows = -1;
              int cols = -1;
              int j = 0;
              TeXNode element = TeXNode(TeXNodeType.list, []);
              while (itemPos < node.items.length) {
                var item = node.items[itemPos++];
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
                        "Matrix has inconsistent number of columns.");
                  }
                  j = 0;
                } else {
                  element.items.add(item);
                }
              }
              if (element.items.isNotEmpty) {
                elements.add(element);
              }
              if ((elements.length % cols) != 0) {
                throw Exception("Matrix is inconsistent.");
              }
              rows = (elements.length / cols).round();
              for (var element in elements) {
                typeset(element, fracDepth + (globalDisplayStyle ? 1 : 0));
                node.glyphs.addAll(element.glyphs);
              }
              // fill alignment that was not set explicitly
              for (var i = alignment.length; i < cols; i++) {
                alignment += envType == "cases" ? "l" : "c";
              }
              // calculate column and row dimensions
              List<double> colWidths = List.generate(cols, (index) => 0.0);
              List<double> rowHeights = List.generate(rows, (index) => 0.0);
              List<double> rowMinYs = List.generate(rows, (index) => 0.0);
              for (var i = 0; i < rows; i++) {
                for (var j = 0; j < cols; j++) {
                  var e = elements[i * cols + j];
                  if (e.width > colWidths[j]) colWidths[j] = e.width;
                  if (e.height > rowHeights[i]) rowHeights[i] = e.height;
                  var min = e.minY;
                  if (e.containsSubNode("\\frac")) min += 250.0;
                  if (min < rowMinYs[i]) rowMinYs[i] = min;
                }
              }
              double totalWidth =
                  sum(colWidths) + (cols - 1) * horizontalPadding;
              double totalHeight =
                  sum(rowHeights) + (rows - 1) * verticalPadding;
              // translate elements and apply alignment
              var paddingLeftRight = 75.0;
              var x = paddingLeftRight;
              var y = totalHeight;
              for (var i = 0; i < rows; i++) {
                y -= rowHeights[i] + rowMinYs[i];
                for (var j = 0; j < cols; j++) {
                  var e = elements[i * cols + j];
                  e.translate(x, y);
                  switch (alignment[j]) {
                    case "c":
                      e.translate((colWidths[j] - e.width) / 2.0, 0);
                      break;
                    // TODO: case "r":
                  }
                  x += colWidths[j] + horizontalPadding;
                }
                x = paddingLeftRight;
                y += rowMinYs[i] - verticalPadding;
              }
              // parentheses
              var leftParenthesis = Glyph();
              var rightParenthesis = Glyph();
              var leftChar = '';
              var rightChar = '';
              switch (envType) {
                case "pmatrix":
                  leftChar = "(";
                  rightChar = ")";
                  break;
                case "bmatrix":
                  leftChar = "[";
                  rightChar = "]";
                  break;
                case "Bmatrix":
                  leftChar = "\\{";
                  rightChar = "\\}";
                  break;
                case "vmatrix":
                  leftChar = "|";
                  rightChar = "|";
                  break;
                case "cases":
                  leftChar = "\\{";
                  break;
              }
              var yScalingFac = 950.0;
              var yOffsetFac = 0.26;
              if (leftChar.isNotEmpty) {
                // left parenthesis
                var entry = table[leftChar] as Map<Object, Object>;
                leftParenthesis.svgPathId = entry["code"] as String;
                leftParenthesis.width = (entry["w"] as int).toDouble();
                leftParenthesis.yScaling = totalHeight / yScalingFac;
                //leftParenthesis.y -= 120 * leftParenthesis.yScaling;
                leftParenthesis.y -= (totalHeight - yScalingFac) * yOffsetFac;
              }
              if (rightChar.isNotEmpty) {
                // right parenthesis
                var entry = table[rightChar] as Map<Object, Object>;
                rightParenthesis.svgPathId = entry["code"] as String;
                rightParenthesis.width = (entry["w"] as int).toDouble();
                rightParenthesis.yScaling = totalHeight / yScalingFac;
                rightParenthesis.x =
                    2.0 * paddingLeftRight + leftParenthesis.width + totalWidth;
                rightParenthesis.y -= (totalHeight - yScalingFac) * yOffsetFac;
              }
              // translate matrix
              node.translate(leftChar.isEmpty ? 0 : leftParenthesis.width,
                  (standardFontHeight - totalHeight) / 2.0);
              // add parentheses at the end to prevent simultaneous
              // transformation with matrix.
              if (leftChar.isNotEmpty) {
                node.glyphs.add(leftParenthesis);
              }
              if (rightChar.isNotEmpty) {
                node.glyphs.add(rightParenthesis);
              }
              node.calcGeometry();
              node.postfixSpacing = 150;
              break;
            }
          default:
            throw Exception("Unknown environment $envType.");
        }
      }
  }
  if (!skipSubAndSup && node.sup != null) {
    var dy = 0.0;
    if (node.tk.contains("matrix") || node.tk.startsWith("left-right")) {
      dy = node.minY + node.height - 375;
    } else {
      dy = node.minY + 375;
    }
    var sup = node.sup as TeXNode;
    typeset(sup, fracDepth + 1);
    sup.scale(0.7071, 0.7071);
    sup.translate(node.width, dy);
    node.glyphs.addAll(sup.glyphs);
  }
  if (!skipSubAndSup && node.sub != null) {
    var dy = node.minY - 150;
    var sub = node.sub as TeXNode;
    typeset(sub, fracDepth + 1);
    sub.scale(0.7071, 0.7071);
    sub.translate(node.width, dy);
    node.glyphs.addAll(sub.glyphs);
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
