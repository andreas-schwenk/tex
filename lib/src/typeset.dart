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
  if (node.isList) {
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
  } else {
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
      node.isList = true;
      for (var i = 0; i < tk.length - 1; i++) {
        var n = TeXNode(false, []);
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
      if (arg.isList == false) {
        node.args[0] = arg = TeXNode(true, [arg]);
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
      if (numerator.isList == false) {
        node.args[0] = numerator = TeXNode(true, [numerator]);
      }
      if (denominator.isList == false) {
        node.args[1] = denominator = TeXNode(true, [denominator]);
      }
      typeset(numerator, 0, 0, 0.7071);
      typeset(denominator, 0, 0, 0.7071);
      var wn = numerator.width; // width numerator
      var wd = denominator.width; // width denominator
      node.width = max(wn, wd);
      numerator.x = ((node.width - numerator.width) * 0.7071 / 2.0).round();
      denominator.x = ((node.width - denominator.width) * 0.7071 / 2.0).round();
      x += (node.width * 0.7071).round();
      numerator.y += 400;
      denominator.y -= 400; // TODO: must depend on args[1].height
      node.height =
          ((numerator.y + numerator.height - denominator.y) * 0.7071).round();
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
      var height = (dy + sub.height * 0.7071).round();
      node.height = max(node.height, height);
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
