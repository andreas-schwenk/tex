/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

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
    // TODO: is baseX|baseY here anywhere != 0?????
    int x = baseX;
    int y = baseY;
    var tk = node.tk;
    node.x = x;
    node.y = y;
    if (table.containsKey(tk)) {
      var entry = table[tk] as Map<Object, Object>;
      node.svgPathId = entry["code"] as String;
      x += entry["w"] as int;
      if (entry.containsKey("d")) {
        node.dx = entry["d"] as int;
      }
      node.height = 750;
    } else if (tk == "\\mathbb" || tk == "\\mathcal" || tk == "\\text") {
      setFont(node.args[0], tk);
      typeset(node.args[0], x, y, scaling);
      x += node.args[0].width;
      node.height = node.args[0].height;
    } else if (["\\sin", "\\cos", "\\exp", "\\tan"].contains(tk)) {
      // TODO: store list (sin, cos, ...) into config file unter /meta/
      if (x > 0) x += 300;
      node.isList = true;
      for (var i = 0; i < tk.length - 1; i++) {
        var n = TeXNode(false, []);
        n.tk = '\\text{${tk[i + 1]}}';
        node.items.add(n);
      }
      typeset(node, x, y, scaling);
      x += node.width;
    } else if (tk == '\\frac') {
      node.isFraction = true;
      if (node.args[0].isList == false) {
        node.args[0] = TeXNode(true, [node.args[0]]);
      }
      if (node.args[1].isList == false) {
        node.args[1] = TeXNode(true, [node.args[1]]);
      }
      typeset(node.args[0], 0, 0, 0.7071);
      typeset(node.args[1], 0, 0, 0.7071);
      var wn = node.args[0].width; // width numerator
      var wd = node.args[1].width; // width denominator
      node.width = max(wn, wd);
      //node.height = TODO!!
      node.args[0].y += 350;
      node.args[1].y -= 300; // TODO: must depend on args[1].height
      node.args[0].x =
          x + ((node.width - node.args[0].width) * 0.7071 / 2.0).round();
      node.args[1].x =
          x + ((node.width - node.args[1].width) * 0.7071 / 2.0).round();
      x += (node.width * 0.7071).round();
    } else {
      throw Exception("unimplemented token '$tk'");
    }
    if (node.sub != null) {
      var dy = -250;
      var sub = node.sub as TeXNode;
      typeset(sub, x - baseX, dy, 0.7071);
      x += (sub.width * 0.7071).round();
      var height = (dy + sub.height * 0.7071).round(); // TODO!!
      node.height = max(node.height, height);
    }
    if (node.sup != null) {
      var dy = 500;
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
