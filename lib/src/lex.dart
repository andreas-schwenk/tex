/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// Tokenizer for TeX strings.
class Lex {
  // The end token.
  static const lexEnd = '%%%';

  /// The list of tokens.
  List<String> _tokens = [];

  /// The current position.
  int _pos = 0;

  /// The number of tokens.
  int _len = 0;

  /// Sets a source code [src], performs tokenization and replaces tokens.
  set(String src) {
    _pos = 0;
    _tokens = _tokenize(src);
    _tokens.add(lexEnd);
    _len = _tokens.length;
  }

  /// Tokenizes a string [src], inserts it to the current position and returns
  /// the successes.
  bool insert(String src) {
    if (_pos >= _len) return false;
    var tokens = _tokenize(src);
    _tokens.insertAll(_pos, tokens);
    _len = _tokens.length;
    return true;
  }

  /// Tokenizes a string [src].
  List<String> _tokenize(String src) {
    List<String> tokens = [];
    var n = src.length;
    for (var i = 0; i < n; i++) {
      var c = src[i];
      if (c == '\\' && (i + 1) < n && '\\,'.contains(src[i + 1])) {
        tokens.add('\\${src[i + 1]}');
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
        tokens.add(tk);
      } else if (c == "'") {
        //TODO: multiple '
        tokens.add("^");
        tokens.add("{");
        while (i < n && src[i] == "'") {
          tokens.add("'");
          i++;
        }
        i--;
        tokens.add("}");
      } else if (" \n\t".contains(c) == false) {
        tokens.add(c);
      }
    }
    return tokens;
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

/* 
void main() {
  var lex = Lex();
  lex.set('abc\\{def\\}ghi');
  var bp = 1337;
}
*/
