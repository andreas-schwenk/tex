/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'help.dart';
import 'node.dart';

/// Generates SVG code for [node] with indentation [indent].
String gen(bool paintBox, TeXNode node, int indent, int colorRed,
    int colorGreen, int colorBlue) {
  String svg = '';
  for (var n in node.renderedNodes) {
    if (n.svgPathId == '!fraction' || n.svgPathId == '!overline') {
      // TODO: put height into constants.dart
      svg += indentString(
          '<rect x="${n.x}" y="${n.y}"'
          ' width="${n.width}" height="20" fill="none"'
          ' stroke="rgb($colorRed,$colorGreen,$colorBlue)" stroke-width="20" data-token="\\frac">'
          '</rect>',
          indent + 2);
    } else if (n.svgPathId.isNotEmpty) {
      svg += indentString(
          '<g fill="rgb($colorRed,$colorGreen,$colorBlue)" transform="translate('
          '${n.x},${n.y}'
          ') scale(${n.xScaling.toStringAsFixed(4)}'
          ',${n.yScaling.toStringAsFixed(4)})"'
          ' data-token="${xmlStringEncode(n.tk)}">',
          indent);
      svg +=
          indentString('<use xlink:href="#${n.svgPathId}"></use>', indent + 2);
      svg += indentString('</g>', indent);
    }
    if (paintBox) {
      svg += indentString(
          '<rect x="${n.x}" y="${n.y}"'
          ' width="${n.width}" height="${n.height}" fill="none"'
          ' stroke="rgb(200,200,200)" stroke-width="20" data-token="\\frac">'
          '</rect>',
          indent + 2);
    }
  }
  return svg;
}
