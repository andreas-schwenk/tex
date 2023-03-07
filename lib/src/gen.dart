/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'help.dart';
import 'node.dart';

/// Generates SVG code for [node] with indentation [indent].
String gen(bool paintBox, TeXNode node, int indent) {
  if (node.isList) {
    var svg = '';
    for (var i = 0; i < node.items.length; i++) {
      var item = node.items[i];
      svg += gen(paintBox, item, indent + 2);
    }
    if (node.isSqrt) {
      svg += indentString(
          '<rect x="${node.globalX}" y="${node.globalY + node.globalHeight}"'
          ' width="${node.width}" height="20" fill="none"'
          ' stroke="rgb(0,0,0)" stroke-width="20" data-token="\\sqrt">'
          '</rect>',
          indent + 2);
    }
    return svg;
  } else {
    var svg = indentString(
        '<g transform="translate('
        '${(node.globalX + node.globalDx).round()},${node.globalY.round()}'
        ') scale(${node.globalScaling.toStringAsFixed(4)})"'
        ' data-token="${xmlStringEncode(node.tk)}">',
        indent);
    svg +=
        indentString('<use xlink:href="#${node.svgPathId}"></use>', indent + 2);
    svg += indentString('</g>', indent);

    if (node.isFraction) {
      svg += indentString(
          '<rect x="${node.globalX}" y="${node.globalY + 250}"'
          ' width="${node.width}" height="20" fill="none"'
          ' stroke="rgb(0,0,0)" stroke-width="20" data-token="\\frac">'
          '</rect>',
          indent + 2);
    }
    if (node.sub != null) {
      svg += gen(paintBox, node.sub as TeXNode, indent + 2);
    }
    if (node.sup != null) {
      svg += gen(paintBox, node.sup as TeXNode, indent + 2);
    }
    for (var i = 0; i < node.args.length; i++) {
      svg += gen(paintBox, node.args[i], indent + 2);
    }
    return svg;
  }
}

String genBoundingBoxes(TeXNode node) {
  String res =
      '<rect x="${node.globalX}" y="${-(node.globalY + node.globalHeight)}"'
      ' width="${node.globalWidth}" height="${node.globalHeight}"'
      ' fill="none" stroke="rgb(200,200,200)" stroke-width="20">'
      '</rect>\n';
  for (var item in node.items) {
    res += genBoundingBoxes(item);
  }
  if (node.sub != null) {
    res += genBoundingBoxes(node.sub as TeXNode);
  }
  if (node.sup != null) {
    res += genBoundingBoxes(node.sup as TeXNode);
  }
  for (var arg in node.args) {
    res += genBoundingBoxes(arg);
  }
  return res;
}
