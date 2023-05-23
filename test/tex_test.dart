/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

//import 'dart:io';
//import 'package:test/test.dart';
import 'package:tex/tex.dart';

void main() {
  var tex = TeX();
  var displayStyle = false;
  var src =
      //"xx\\begin{pmatrix} a xxxxxx & \\alpha \\\\ c+1 & d^2 \\end{pmatrix}yy";
      //"sssss\\begin{pmatrix}aaa&b^{3^{3^{44}}}\\\\c&d_3\\\\1&2\\end{pmatrix}xx^33";
      //"sgn(x)=\\begin{cases} -1 & x<0\\\\ 1 & x>0\\\\ 0 & \\text{else} \\end{cases}";
      //"\\begin{matrix}[lc]\n  1 & 2 \\\\\n  3 & 4 \\\\\n\\end{matrix}";
      //"\\mathbb{N}^2";
      //"\\lim_{x\\to\\infty}\\frac1x";
      //"{x \\in \\NN}";
      //"-x";
      //"\\frac{x}{x}";
      //"\\sin x"; // TODO: "\\sin(x)"
      "\\sum";
  //"\\lim_{x \\to \\infty} x";
  //"f(x)=x+{x}^2";
  //"\\frac12";
  //"\\sqrt{\\frac12} \\sqrt x";
  //"\\frac12 \\frac12";

  //var src = "abc\\NN def";
  //"\\sqrt 3"; //"\\frac x {y+1}"; //"\\frac x{ \\sum_1^{{6}} w } \\cdot 5";
  //"x^2  + {4*5}";
  var output = '';
  output = tex.tex2svg(src, debugMode: true, displayStyle: displayStyle);
  if (output.isEmpty) {
    print("ERROR: tex2svg failed: ${tex.error}");
  }
  print(output);
  //File('lib/tex/test/svg/test.svg').writeAsStringSync(output);

  // TODO
  /*group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });*/
}
