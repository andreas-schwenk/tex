/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

class Lex {
  static const lexEnd = '%%%';

  List<String> _tokens = [];

  int _pos = 0; // current position
  int _len = 0; // number of tokens

  set(String src) {
    _tokens = [];
    _pos = 0;
    var n = src.length;
    for (var i = 0; i < n; i++) {
      var c = src[i];
      if (c == '\\') {
        var tk = '\\';
        var j = i + 1;
        for (; j < n; j++) {
          var ch = src[j];
          if ((ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
                  ch.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) ||
              (ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
                  ch.codeUnitAt(0) <= 'z'.codeUnitAt(0))) {
            tk += ch;
          } else {
            break;
          }
        }
        i = j - 1;
        _tokens.add(tk);
      } else if (" \n\t".contains(c) == false) {
        _tokens.add(c);
      }
    }
    _tokens.add(lexEnd);
    _len = _tokens.length;
  }

  next() {
    _pos++;
  }

  String get token {
    return _pos >= _len ? lexEnd : _tokens[_pos];
  }
}

/*void main() {
  var src = "f(x,y)=3x+y^{2^{8+1}}+z^{3+2}+\\alpha_{\\gamma}+\\beta+X+abc";
  var lex = new Lex(src);
}*/

