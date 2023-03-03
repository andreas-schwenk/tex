/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'dart:convert';
import 'dart:html';

import 'package:tex/tex.dart';
import 'package:tex/src/tab.dart' as tab;

void main() {
  print("tex - a tiny TeX engine");
  print(
      "(c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>");
  print("License: GPL-3.0-or-later");

  setTextInput(
      'tex-input', 'f(x,y)=3x+y^{2^{8+1}}+z^{3+2}+\\alpha_{\\gamma}+\\beta+X');
  querySelector('#runTex')?.onClick.listen((event) {
    typeset(false);
  });
  querySelector('#runTexWithBorder')?.onClick.listen((event) {
    typeset(true);
  });
  typeset(true);

  // glyph tests
  var glyphTable = querySelector('#glyph-table') as TableSectionElement;
  glyphTable.innerHtml = '';
  var tex = TeX();
  for (var texSrc in tab.table.keys) {
    var rowData = tab.table[texSrc] as Map<String, Object>;
    var output = tex.tex2svg(texSrc, true);
    if (output.isEmpty) {
      print(tex.error);
    }
    var tr = document.createElement('tr') as TableRowElement;

    var cell1 = document.createElement('td') as TableCellElement;
    cell1.innerHtml = '<code>$texSrc</code>';
    tr.append(cell1);

    var cell2 = document.createElement('td') as TableCellElement;
    if (output.isEmpty) {
      cell2.innerHtml = '<code>Error: ${tex.error}</code>';
      tr.append(cell2);
    } else {
      var outputBase64 = base64Encode(utf8.encode(output));
      var img = document.createElement('img') as ImageElement;
      img.style.height = "36px";
      img.src = "data:image/svg+xml;base64,$outputBase64";
      cell2.append(img);
      tr.append(cell2);
    }

    var cell3 = document.createElement('td') as TableCellElement;
    cell3.innerHtml = (rowData["w"] as int).toString();
    tr.append(cell3);

    var cell4 = document.createElement('td') as TableCellElement;
    cell4.innerHtml = (rowData["d"] as int).toString();
    tr.append(cell4);

    glyphTable.append(tr);
  }
}

void typeset(bool paintBox) {
  var src = (querySelector('#tex-input') as InputElement).value as String;
  var tex = TeX();
  print(src);
  var output = tex.tex2svg(src, paintBox);
  print(output);
  if (output.isNotEmpty) {
    var outputBase64 = base64Encode(utf8.encode(output));
    var img = document.createElement('img') as ImageElement;
    img.style.height = "72px";
    img.src = "data:image/svg+xml;base64,$outputBase64";
    //print(img);
    document.getElementById('tex-term')?.innerHtml = tex.lastParsed;
    document.getElementById('tex-rendering')?.innerHtml = '';
    document.getElementById('tex-rendering')?.append(img);
  } else {
    document.getElementById('tex-term')?.innerHtml = tex.error;
  }
}

void setTextInput(String elementId, String value) {
  (document.getElementById(elementId) as InputElement).value = value;
}
