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
  if (parseBraces) lex.terminal('{');
  var list = TeXNode(TeXNodeType.list, []);
  while (lex.token != Lex.lexEnd && lex.token != '}') {
    list.items.add(parseTexNode(lex));
  }
  if (parseBraces) lex.terminal('}');
  // post-process: populate node.args
  for (var i = 0; i < list.items.length; i++) {
    if (list.items[i].type == TeXNodeType.unary &&
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
    var node = TeXNode(TeXNodeType.unary, []);
    node.tk += lex.token;
    if (node.tk.startsWith("\\") == false && node.tk.length != 1) {
      throw Exception("unimplemented!");
    }
    if (node.tk == '\\begin') {
      return parseTexEnv(lex);
    } else if (node.tk.startsWith("\\") && macros.containsKey(node.tk)) {
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
            : TeXNode(TeXNodeType.list, [parseTexNode(lex)]);
      }
      if (del == '^') {
        node.sup = lex.token == '{'
            ? parseTexList(lex, true)
            : TeXNode(TeXNodeType.list, [parseTexNode(lex)]);
      }
    }
    return node;
  }
}

/// Parses a TeX environment.
///
/// Formal grammar: env = "\begin" "{" {ID} "}" { texNode } "\end" "{" {ID} "}";
TeXNode parseTexEnv(Lex lex) {
  lex.terminal('\\begin');
  lex.terminal('{');
  var envID = '';
  while (lex.token != Lex.lexEnd && lex.token != '}') {
    envID += lex.token;
    lex.next();
  }
  lex.terminal('}');
  List<TeXNode> nodes = [];
  while (lex.token != Lex.lexEnd && lex.token != '\\end') {
    nodes.add(parseTexNode(lex));
  }
  lex.terminal('\\end');
  lex.terminal('{');
  var envID2 = '';
  while (lex.token != Lex.lexEnd && lex.token != '}') {
    envID2 += lex.token;
    lex.next();
  }
  lex.terminal('}');
  if (envID != envID2) {
    throw Exception('unexpected \\end{$envID2}');
  }
  // TODO: set env name!
  return TeXNode(TeXNodeType.env, nodes, envID);
}
