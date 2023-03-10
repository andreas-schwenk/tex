/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

//import 'dart:io';
//import 'package:test/test.dart';
import 'package:tex/tex.dart';

void main() {
  var tex = TeX();
  var src =
      //"xx\\begin{pmatrix} a xxxxxx & \\alpha \\\\ c+1 & d^2 \\end{pmatrix}yy";
      "sssss\\begin{pmatrix}aaa&b^{3^{3^{44}}}\\\\c&d_3\\\\1&2\\end{pmatrix}xx^33";

  //var src = "abc\\NN def";
  //"\\sqrt 3"; //"\\frac x {y+1}"; //"\\frac x{ \\sum_1^{{6}} w } \\cdot 5";
  //"x^2  + {4*5}";
  var output = '';
  var paintBox = true;
  output = tex.tex2svg(src, paintBox);
  if (output.isEmpty) {
    print("ERROR: tex2svg failed: ${tex.error}");
    assert(false);
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
