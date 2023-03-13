/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'lex.dart';
import 'node.dart';
import 'tab.dart';

/// Parses a TeX list. Braces "{", "}" are consumed, if [parseBraces] is true.
///
/// Formal grammar: texList = "{" { texNode } "}";
TeXNode parseTexList(Lex lex, bool parseBraces, bool forbidParsingSubSup) {
  if (parseBraces) lex.terminal('{');
  var list = TeXNode(TeXNodeType.list, []);
  while (lex.token != Lex.lexEnd && lex.token != '}') {
    list.items.add(parseTexNode(lex, false));
  }
  if (parseBraces) lex.terminal('}');
  postProcessList(list.items);
  if (forbidParsingSubSup == false) {
    parseSubSup(lex, list);
  }
  return list;
}

/// Parses a TeX node.
///
/// Formal grammar: texNode = "\" ID { "{" texList "}" } | ID | INT | ...;
TeXNode parseTexNode(Lex lex, bool forbidParsingSubSup) {
  if (lex.token == '{') {
    return parseTexList(lex, true, false);
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
      node = parseTexList(lex, false, false);
    }
    lex.next();
    if (forbidParsingSubSup == false) {
      parseSubSup(lex, node);
    }
    return node;
  }
}

// TODO: docs + grammar + grammer where called
void parseSubSup(Lex lex, TeXNode node) {
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
          ? parseTexList(lex, true, true)
          : TeXNode(TeXNodeType.list, [parseTexNode(lex, true)]);
    }
    if (del == '^') {
      node.sup = lex.token == '{'
          ? parseTexList(lex, true, true)
          : TeXNode(TeXNodeType.list, [parseTexNode(lex, true)]);
    }
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
    nodes.add(parseTexNode(lex, false));
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
  postProcessList(nodes);
  return TeXNode(TeXNodeType.environment, nodes, envID);
}

/// post-process: populate node.args (as lists)
void postProcessList(List<TeXNode> items) {
  for (var i = 0; i < items.length; i++) {
    if (items[i].type == TeXNodeType.unary &&
        numArgs.containsKey(items[i].tk)) {
      var item = items[i];
      var n = numArgs[item.tk] as int;
      for (var j = 0; j < n; j++) {
        if (i + 1 >= items.length) {
          throw Exception(
              'ERROR: ${item.tk} excepts ${n.toString()} arguments!');
        }
        var item2 = items.removeAt(i + 1);

        if (item2.type == TeXNodeType.unary) {
          item2 = TeXNode(TeXNodeType.list, [item2]);
        }

        item.args.add(item2);
      }
    }
  }
}
