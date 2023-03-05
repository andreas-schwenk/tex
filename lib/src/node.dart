/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

class TeXNode {
  bool isList;
  bool isFraction = false;

  List<TeXNode> items = [];
  List<TeXNode> args = [];
  String tk = '';
  TeXNode? sub;
  TeXNode? sup;

  double scaling = 1.0;
  int x = 0;
  int dx = 0; // delta x (left padding)
  int y = 0;
  int width = 0;
  int height = 0;
  String svgPathId = '';

  TeXNode(this.isList, this.items);

  @override
  String toString() {
    if (isList) {
      var s = '{';
      for (var i = 0; i < items.length; i++) {
        if (i > 0) s += ' ';
        var item = items[i];
        s += item.toString();
      }
      s += '}';
      return s;
    } else {
      var s = tk;
      if (sub != null) {
        s += '_${sub.toString()}';
      }
      if (sup != null) {
        s += '^${sup.toString()}';
      }
      if (args.isNotEmpty) {
        for (var arg in args) {
          s += ' %arg ${arg.toString()}';
        }
      }
      return s;
    }
  }
}
