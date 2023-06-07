/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'dart:convert';
import 'dart:html';

// ignore: avoid_relative_lib_imports
import '../lib/tex.dart';
import 'examples.dart';

void main() {
  print("tex - a tiny TeX engine");
  print(
      "(c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>");
  print("License: GPL-3.0-or-later");

  setTextInput('tex-input', 'f(x,y)=x^2+y^2');
  querySelector('#runTex')?.onClick.listen((event) {
    typeset();
  });
  typeset();

  showExamples();
}

void showExamples() {
  var tex = TeX();
  var examplesTable = querySelector('#examples-table') as TableSectionElement;
  examplesTable.innerHtml = '';
  for (var example in examples) {
    var tr = document.createElement('tr') as TableRowElement;

    var cell1 = document.createElement('td') as TableCellElement;
    cell1.innerHtml = '<pre><code>$example</code></pre>';
    cell1.style.maxWidth = "250px";
    cell1.style.wordBreak = "break-all";
    tr.append(cell1);

    var cell2 = document.createElement('td') as TableCellElement;
    var output = tex.tex2svg(example);
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
    var span = document.createElement('span');
    span.style.verticalAlign = "middle";
    span.style.display = "inline-block";
    span.innerHtml = '\$\$$example\$\$';
    cell3.append(span);
    tr.append(cell3);

    examplesTable.append(tr);
  }
}

void typeset() {
  var src = (querySelector('#tex-input') as InputElement).value as String;
  document.getElementById('tex-rendering')?.innerHtml = '';
  document.getElementById('mathjax-rendering')?.innerHtml = '\$\$$src\$\$';
  var tex = TeX();
  print(src);
  tex.scalingFactor = 2.0;
  var output = tex.tex2svg(src);
  if (output.isNotEmpty) {
    var outputBase64 = base64Encode(utf8.encode(output));
    var img = document.createElement('img') as ImageElement;
    img.src = "data:image/svg+xml;base64,$outputBase64";
    img.style.verticalAlign = "bottom";
    document.getElementById('tex-term')?.innerHtml = tex.parsed;
    document.getElementById('tex-rendering')?.append(img);
  } else {
    document.getElementById('tex-term')?.innerHtml = tex.error;
  }
  // update mathjax
  window.postMessage('typesetMathjax', "*");
}

void setTextInput(String elementId, String value) {
  (document.getElementById(elementId) as InputElement).value = value;
}
