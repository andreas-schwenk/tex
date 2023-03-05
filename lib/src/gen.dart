/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'help.dart';
import 'node.dart';

/// Generates SVG code for [node] with indentation [indent].
String gen(bool paintBox, TeXNode node, int indent) {
  if (node.isList) {
    var svg = indentString(
        '<g transform="translate(${node.x},${node.y}) scale(${node.scaling})">',
        indent);
    /*svg += _indent(
          '<rect x="0" y="0"'
          ' width="${node.width}" height="${node.height}" fill="none"'
          ' stroke="rgb(120,220,120)" stroke-width="10"></rect>',
          indent + 2);*/
    for (var i = 0; i < node.items.length; i++) {
      var item = node.items[i];
      svg += gen(paintBox, item, indent + 2);
    }
    svg += indentString('</g>', indent);
    return svg;
  } else {
    var svg = indentString(
        '<g transform="translate(${node.x + node.dx},${node.y})'
        ' scale(${node.scaling})"'
        ' data-token="${node.tk}">',
        indent);
    svg +=
        indentString('<use xlink:href="#${node.svgPathId}"></use>', indent + 2);
    if (paintBox) {
      svg += indentString(
          '<rect x="${-node.dx}" y="0"'
          ' width="${node.width}" height="${node.height}" fill="none"'
          ' stroke="rgb(220,120,120)" stroke-width="15"></rect>',
          indent + 2);
    }
    if (node.isFraction) {
      svg += indentString(
          '<rect x="0" y="250"'
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
    svg += indentString('</g>', indent);
    // args
    if (node.svgPathId.isEmpty && node.isFraction == false) {
      svg = '';
    }
    for (var i = 0; i < node.args.length; i++) {
      svg += gen(paintBox, node.args[i], indent);
    }
    return svg;
  }
}
