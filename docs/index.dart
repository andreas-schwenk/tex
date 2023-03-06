/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'dart:convert';
import 'dart:html';

import 'package:tex/tex.dart';
import 'package:tex/src/tab.dart' as tab;

final examples = ['y(x)=x^2', '\\frac 1 {x+1}', '\\sin x', '\\sin(x)'];

void main() {
  print("tex - a tiny TeX engine");
  print(
      "(c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>");
  print("License: GPL-3.0-or-later");

  setTextInput('tex-input',
      'f(x,y)=3x+y^{2^{8+1}}+z^{3+2}+\\alpha_{\\gamma}+\\beta+\\sin(x)+\\frac x {y+1}');
  querySelector('#runTex')?.onClick.listen((event) {
    typeset();
  });
  typeset();

  // inline equation examples
  var inlineExamples = ["x^2+y^2", "f(x)=\\frac 1 2 x"];
  for (var k = 0; k < inlineExamples.length; k++) {
    var tex = TeX();
    var imgData = tex.tex2svg(inlineExamples[k]);
    var outputBase64 = base64Encode(utf8.encode(imgData));
    var img = document.createElement('img') as ImageElement;
    img.src = "data:image/svg+xml;base64,$outputBase64";
    img.style.verticalAlign = "bottom";
    var span = querySelector('#example-inline-${k + 1}') as SpanElement;
    span.innerHtml = '';
    span.style.backgroundColor = '#EEEEEE';
    span.style.paddingLeft = "3px";
    span.style.paddingRight = "3px";
    span.style.display = "inline-block";
    span.style.verticalAlign = "top";
    span.append(img);
  }

  // examples
  var tex = TeX();
  var examplesTable = querySelector('#examples-table') as TableSectionElement;
  examplesTable.innerHtml = '';
  for (var example in examples) {
    var tr = document.createElement('tr') as TableRowElement;

    var cell1 = document.createElement('td') as TableCellElement;
    cell1.innerHtml = '<code>$example</code>';
    tr.append(cell1);

    var cell2 = document.createElement('td') as TableCellElement;
    var output = tex.tex2svg(example, false);
    if (output.isEmpty) {
      print(tex.error);
    }
    if (output.isEmpty) {
      cell2.innerHtml = '<code>Error: ${tex.error}</code>';
      tr.append(cell2);
    } else {
      var outputBase64 = base64Encode(utf8.encode(output));
      var img = document.createElement('img') as ImageElement;
      img.src = "data:image/svg+xml;base64,$outputBase64";
      cell2.append(img);
      tr.append(cell2);
    }

    var cell3 = document.createElement('td') as TableCellElement;
    output = tex.tex2svg(example, true);
    if (output.isEmpty) {
      print(tex.error);
    }
    if (output.isEmpty) {
      cell3.innerHtml = '<code>Error: ${tex.error}</code>';
      tr.append(cell3);
    } else {
      var outputBase64 = base64Encode(utf8.encode(output));
      var img = document.createElement('img') as ImageElement;
      img.src = "data:image/svg+xml;base64,$outputBase64";
      cell3.append(img);
      tr.append(cell3);
    }

    examplesTable.append(tr);
  }

  // glyph tests
  var glyphTable = querySelector('#glyph-table') as TableSectionElement;
  glyphTable.innerHtml = '';
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
      //img.style.height = "36px";
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

void typeset() {
  var src = (querySelector('#tex-input') as InputElement).value as String;
  document.getElementById('tex-rendering')?.innerHtml = '';
  var tex = TeX();
  print(src);
  tex.scalingFactor = 2.0;
  for (var i = 0; i < 2; i++) {
    var output = tex.tex2svg(src, i == 0 ? false : true);
    if (i == 0) print(output);
    if (output.isNotEmpty) {
      var outputBase64 = base64Encode(utf8.encode(output));
      var img = document.createElement('img') as ImageElement;
      img.src = "data:image/svg+xml;base64,$outputBase64";
      document.getElementById('tex-term')?.innerHtml = tex.lastParsed;
      document.getElementById('tex-rendering')?.append(img);
    } else {
      document.getElementById('tex-term')?.innerHtml = tex.error;
    }
  }
}

void setTextInput(String elementId, String value) {
  (document.getElementById(elementId) as InputElement).value = value;
}
