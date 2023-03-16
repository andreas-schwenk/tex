/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'lex.dart';
import 'node.dart';
import 'tab.dart';

/// Parses a TeX list. Braces "{", "}" are consumed, if [parseBraces] is true.
///
/// Formal grammar: texList = "{" { texNode } "}" [ texSubSup ];
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
/// Formal grammar: texNode = ("\" ID { "{" texList "}" } | ID | INT | ...) [ texSubSup ];
TeXNode parseTexNode(Lex lex, bool forbidParsingSubSup) {
  if (lex.token == '{') {
    return parseTexList(lex, true, forbidParsingSubSup);
  } else {
    var node = TeXNode(TeXNodeType.unary, []);
    node.tk += lex.token;
    if (node.tk.startsWith("\\") == false && node.tk.length != 1) {
      throw Exception("unimplemented!");
    }
    if (node.tk == '\\begin') {
      return parseTexEnv(lex);
    } else if (node.tk == '\\left') {
      return parseLeftRight(lex);
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

/// Parses subscript and superscript tex nodes.
///
/// Formal grammar: texSubSup = { "^" texNode | "_" texNode };
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
      node.sub = parseTexNode(lex, true);
    }
    if (del == '^') {
      node.sup = parseTexNode(lex, true);
    }
  }
}

/// Parses a TeX environment.
///
/// Formal grammar: env = "\begin" "{" {ID} "}" { texNode } "\end" "{" {ID} "}" [ texSubSup ];
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
  var node = TeXNode(TeXNodeType.environment, nodes, envID);
  parseSubSup(lex, node);
  return node;
}

/// Parses left and right parentheses.
///
/// Formal grammar: lr = "\left" PARENTHESIS { texNode } "\right" PARENTHESIS [ texSubSup ];
TeXNode parseLeftRight(Lex lex) {
  const parentheses = ["(", "[", "\\{", ".", ")", "]", "\\}"];
  var left = '';
  var right = '';
  lex.terminal('\\left');
  if (parentheses.contains(lex.token)) {
    left = lex.token;
    lex.next();
  } else {
    throw Exception('invalid token after \\left');
  }
  List<TeXNode> nodes = [];
  while (lex.token != Lex.lexEnd && lex.token != '\\right') {
    nodes.add(parseTexNode(lex, false));
  }
  lex.terminal('\\right');
  if (parentheses.contains(lex.token)) {
    right = lex.token;
    lex.next();
  } else {
    throw Exception('invalid token after \\right');
  }
  postProcessList(nodes);
  var node = TeXNode(TeXNodeType.environment, nodes, "left-right:$left:$right");
  parseSubSup(lex, node);
  return node;
}

/// post-process: populate node.args (as lists)
void postProcessList(List<TeXNode> items) {
  for (var i = 0; i < items.length; i++) {
    if (items[i].type == TeXNodeType.unary &&
        numArgs.containsKey(items[i].tk)) {
      var item = items[i];
      var n = numArgs[item.tk] as int;
      TeXNode? sub;
      TeXNode? sup;
      for (var j = 0; j < n; j++) {
        if (i + 1 >= items.length) {
          throw Exception(
              'ERROR: ${item.tk} excepts ${n.toString()} arguments!');
        }
        var item2 = items.removeAt(i + 1);
        if (item2.sub != null) {
          // TODO: error, if this is not the last arg
          sub = item2.sub;
          item2.sub = null;
        }
        if (item2.sup != null) {
          // TODO: error, if this is not the last arg
          sup = item2.sup;
          item2.sup = null;
        }
        if (item2.type == TeXNodeType.unary) {
          item2 = TeXNode(TeXNodeType.list, [item2]);
        }
        item.args.add(item2);
      }
      // move inner sub and/or sup to outer
      item.sub = sub;
      item.sup = sup;
    }
  }
}
