/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// Tokenizer for TeX strings.
class Lex {
  // The end token.
  static const lexEnd = '%%%';

  /// The list of tokens.
  final List<String> _tokens = [];

  /// The current position.
  int _pos = 0;

  /// The number of tokens.
  int _len = 0;

  /// Sets a source code [src], performs tokenization and replaces tokens.
  set(String src) {
    _pos = 0;
    var n = src.length;
    for (var i = 0; i < n; i++) {
      var c = src[i];
      if (c == '\\' &&
          (i + 1) < n &&
          ('\\,'.contains(src[i + 1]) || '\\;'.contains(src[i + 1]))) {
        _tokens.add('\\${src[i + 1]}');
        i++;
      } else if (c == '\\') {
        var tk = '\\';
        var j = i + 1;
        for (; j < n; j++) {
          var ch = src[j];
          if ((ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
                  ch.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) ||
              (ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
                  ch.codeUnitAt(0) <= 'z'.codeUnitAt(0))) {
            tk += ch;
          } else if (j == i + 1 && (ch == '{' || ch == '}')) {
            tk += ch;
            j++;
            break;
          } else {
            break;
          }
        }
        i = j - 1;
        _tokens.add(tk);
      } else if (c == "'") {
        _tokens.add("^");
        _tokens.add("{");
        while (i < n && src[i] == "'") {
          _tokens.add("'");
          i++;
        }
        i--;
        _tokens.add("}");
      } else if (" \n\t".contains(c) == false) {
        _tokens.add(c);
      }
    }
    _tokens.add(lexEnd);
    _len = _tokens.length;
  }

  /// Gets the current position.
  int get pos {
    return _pos;
  }

  /// Moves the position pointer to the next token.
  next() {
    _pos++;
  }

  /// Expects that the current token equals [t] or throws an exception
  /// otherwise
  void terminal(String t) {
    if (token == t) {
      next();
    } else {
      throw Exception('ERROR: expected $t');
    }
  }

  /// Gets the current token.
  String get token {
    return _pos >= _len ? lexEnd : _tokens[_pos];
  }
}

/* /// lexer test
void main() {
  var lex = Lex();
  lex.set('abc\\{def\\}ghi');
  var bp = 1337;
}
*/
