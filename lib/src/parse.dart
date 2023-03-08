/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'lex.dart';
import 'node.dart';
import 'tab.dart';

/// Parses a TeX list. Braces "{", "}" are consumed, if [parseBraces] is true.
///
/// Formal grammar: texList = "{" { texNode } "}";
TeXNode parseTexList(Lex lex, bool parseBraces) {
  if (parseBraces) {
    if (lex.token == '{') {
      lex.next();
    } else {
      throw Exception('ERROR: expected {');
    }
  }
  var list = TeXNode(true, []);
  while (lex.token != Lex.lexEnd && lex.token != '}') {
    list.items.add(parseTexNode(lex));
  }
  if (parseBraces) {
    if (lex.token == '}') {
      lex.next();
    } else {
      throw Exception('ERROR: expected }');
    }
  }
  // post-process: populate node.args
  for (var i = 0; i < list.items.length; i++) {
    if (list.items[i].isList == false &&
        numArgs.containsKey(list.items[i].tk)) {
      var item = list.items[i];
      var n = numArgs[item.tk] as int;
      for (var j = 0; j < n; j++) {
        if (i + 1 >= list.items.length) {
          throw Exception(
              'ERROR: ${item.tk} excepts ${n.toString()} arguments!');
        }
        var item2 = list.items.removeAt(i + 1);
        item.args.add(item2);
      }
      i += n - 1;
    }
  }
  return list;
}

/// Parses a TeX node.
///
/// Formal grammar: texNode = "\" ID { "{" texList "}" } | ID | INT | ...;
TeXNode parseTexNode(Lex lex) {
  if (lex.token == '{') {
    return parseTexList(lex, true);
  } else {
    var node = TeXNode(false, []);
    node.tk += lex.token;
    if (node.tk.startsWith("\\") == false && node.tk.length != 1) {
      throw Exception("unimplemented!");
    }
    if (node.tk.startsWith("\\") && macros.containsKey(node.tk)) {
      var command = node.tk;
      lex.next();
      var replacement = macros[command] as String;
      lex.insert(replacement);
      node = parseTexList(lex, false);
    }
    lex.next();
    while (lex.token == '^' || lex.token == '_') {
      var del = lex.token;
      lex.next();
      if (del == '^' && node.sup != null) {
        throw Exception('ERROR: use { } when chaining ^');
      } else if (del == '_' && node.sub != null) {
        throw Exception('ERROR: use { } when chaining _');
      }
      if (del == '_') {
        node.sub = lex.token == '{'
            ? parseTexList(lex, true)
            : TeXNode(true, [parseTexNode(lex)]);
      }
      if (del == '^') {
        node.sup = lex.token == '{'
            ? parseTexList(lex, true)
            : TeXNode(true, [parseTexNode(lex)]);
      }
    }
    return node;
  }
}
