/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'dart:convert';
import 'dart:html';

import 'package:tex/tex.dart';
import 'package:tex/src/tab.dart' as tab;

final examples = [
  'y(x)=x^2',
  '\\frac 1 {x+1}',
  '\\sin x',
  '\\sin(x)',
  "\\sqrt{x+1}",
  "\\begin{pmatrix}1&2\\\\3&4\\end{pmatrix}",
  "\\int_2^5 x \\, dx",
  "\\sum_{i=1}^5 i^2",
  "\\prod_{i=1}^5 i^2",
];

final customMacros = ['\\CC', '\\NN', '\\QQ', '\\RR', '\\ZZ'];

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
    for (var j = 0; j < 2; j++) {
      var tex = TeX();
      tex.scalingFactor = j == 0 ? 1.0 : 1.25;
      var imgData = tex.tex2svg(inlineExamples[k]);
      var outputBase64 = base64Encode(utf8.encode(imgData));
      var img = document.createElement('img') as ImageElement;
      img.src = "data:image/svg+xml;base64,$outputBase64";
      img.style.verticalAlign = "bottom";
      var spanId = j == 0
          ? '#example-inline-${k + 1}'
          : '#example-inline-large-${k + 1}';
      var span = querySelector(spanId) as SpanElement;
      span.innerHtml = '';
      //span.style.borderColor = '#EEEEEE';
      //span.style.borderStyle = 'solid';
      //span.style.borderWidth = '2px';
      span.style.paddingLeft = "3px";
      span.style.paddingRight = "3px";
      span.style.display = "inline-block";
      span.style.verticalAlign = "middle";
      span.append(img);
    }
  }

  // examples
  showExamples('examples-table', examples);
  showExamples('custom-macros-table', customMacros);

  // glyph tests
  showGlyphTests();
}

void typeset() {
  var src = (querySelector('#tex-input') as InputElement).value as String;
  document.getElementById('tex-rendering')?.innerHtml = '';
  document.getElementById('tex-rendering-with-boxes')?.innerHtml = '';
  var tex = TeX();
  print(src);
  tex.scalingFactor = 2.0;
  for (var i = 0; i < 2; i++) {
    var output = tex.tex2svg(src, i == 0 ? false : true);
    if (i == 0) {
      print(output);
    }
    if (output.isNotEmpty) {
      var outputBase64 = base64Encode(utf8.encode(output));
      var img = document.createElement('img') as ImageElement;
      img.src = "data:image/svg+xml;base64,$outputBase64";
      img.style.verticalAlign = "bottom";
      document.getElementById('tex-term')?.innerHtml = tex.parsed;
      if (i == 0) {
        document.getElementById('tex-rendering')?.append(img);
      } else {
        document.getElementById('tex-rendering-with-boxes')?.append(img);
      }
    } else {
      document.getElementById('tex-term')?.innerHtml = tex.error;
    }
  }
}

void setTextInput(String elementId, String value) {
  (document.getElementById(elementId) as InputElement).value = value;
}

void showExamples(String tableId, List<String> exampleList) {
  var tex = TeX();
  var examplesTable = querySelector('#$tableId') as TableSectionElement;
  examplesTable.innerHtml = '';
  for (var example in exampleList) {
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
      img.style.verticalAlign = "bottom";
      var span = document.createElement('span');
      span.style.verticalAlign = "middle";
      span.style.display = "inline-block";
      span.append(img);
      cell2.append(span);
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
      img.style.verticalAlign = "bottom";
      var span = document.createElement('span');
      span.style.verticalAlign = "middle";
      span.style.display = "inline-block";
      span.append(img);
      cell3.append(span);
      tr.append(cell3);
    }

    examplesTable.append(tr);
  }
}

void showGlyphTests() {
  var glyphTable = querySelector('#glyph-table') as TableSectionElement;
  glyphTable.innerHtml = '';
  for (var texSrc in tab.table.keys) {
    var rowData = tab.table[texSrc] as Map<String, Object>;

    if (texSrc == '\\sqrt') texSrc = '\\sqrt{}';

    var tex = TeX();
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
      img.src = "data:image/svg+xml;base64,$outputBase64";
      img.style.verticalAlign = "bottom";
      var span = document.createElement('span');
      span.style.verticalAlign = "middle";
      span.style.display = "inline-block";
      span.append(img);
      cell2.append(span);
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
