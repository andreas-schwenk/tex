/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'lex.dart';
import 'node.dart';
import 'tab.dart';

/// Parses a TeX string given by [src].
TeXNode parse(String src) {
  // tokenize input
  var lex = Lex();
  lex.set(src);
  // parse src
  var root = TeXNode(TeXNodeType.list, []);
  while (lex.token != Lex.lexEnd) {
    root.items.add(_parseTexNode(lex));
  }
  // in case our "list" has only one item, we do not need a list
  if (root.items.length == 1) {
    root = root.items[0];
  }
  // replace macros
  root = _processMacros(root);
  // set arguments
  root = _processArguments(root);
  // set sub/sup
  root = _processSubSup(root);
  return root;
}

/// Parses a TeX list.
///
/// Formal grammar:
///   texList = "{" { texNode } "}";
TeXNode _parseTexList(Lex lex) {
  lex.terminal('{');
  var list = TeXNode(TeXNodeType.list, []);
  while (lex.token != Lex.lexEnd && lex.token != '}') {
    list.items.add(_parseTexNode(lex));
  }
  lex.terminal('}');
  return list;
}

/// Parses a TeX node.
///
/// Formal grammar:
///   texNode = texList | texEnv | lr | TOKEN;
TeXNode _parseTexNode(Lex lex) {
  if (lex.token == '{') {
    return _parseTexList(lex);
  } else if (lex.token == '\\begin') {
    return _parseTexEnv(lex);
  } else if (lex.token == '\\left') {
    return _parseLeftRight(lex);
  } else {
    var node = TeXNode(TeXNodeType.unary, []);
    node.tk += lex.token;
    lex.next();
    return node;
  }
}

/// Parses a TeX environment.
///
/// Formal grammar:
///   env = "\begin" "{" {TOKEN} "}" { texNode } "\end" "{" {TOKEN} "}";
TeXNode _parseTexEnv(Lex lex) {
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
    nodes.add(_parseTexNode(lex));
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
  return TeXNode(TeXNodeType.environment, nodes, envID);
}

/// Parses left and right parentheses.
///
/// Formal grammar:
///   lr = "\left" PARENTHESIS { texNode } "\right" PARENTHESIS;
TeXNode _parseLeftRight(Lex lex) {
  const parentheses = ["(", "[", "\\{", ".", ")", "]", "\\}", "|"];
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
    nodes.add(_parseTexNode(lex));
  }
  lex.terminal('\\right');
  if (parentheses.contains(lex.token)) {
    right = lex.token;
    lex.next();
  } else {
    throw Exception('invalid token after \\right');
  }
  var node = TeXNode(TeXNodeType.environment, nodes, "left-right:$left:$right");
  return node;
}

/// Replaces macros.
TeXNode _processMacros(TeXNode node) {
  if (macros.containsKey(node.tk)) {
    var command = node.tk;
    var replacement = macros[command] as String;
    var lex = Lex();
    lex.set(replacement);
    node = TeXNode(TeXNodeType.list, []);
    while (lex.token != Lex.lexEnd) {
      node.items.add(_parseTexNode(lex));
    }
  }
  for (var i = 0; i < node.items.length; i++) {
    node.items[i] = _processMacros(node.items[i]);
  }
  // note: node.sub, node.sup and node.args must not be processed, since
  //       they are not set, when _processMacros is called.
  return node;
}

/// Sets arguments.
TeXNode _processArguments(TeXNode node) {
  for (var i = 0; i < node.items.length; i++) {
    node.items[i] = _processArguments(node.items[i]);
  }
  // note: node.sub, node.sup must not be processed, since
  //       they are not set, when _processMacros is called.
  for (var i = 0; i < node.items.length; i++) {
    if (node.items[i].type == TeXNodeType.unary &&
        numArgs.containsKey(node.items[i].tk)) {
      var item = node.items[i];
      var n = numArgs[item.tk] as int; // number of arguments
      // hack to convert "\\sqrt[n+m]{x+y}" to "\\nroot{n+m}{x+y}"
      if (item.tk == '\\sqrt' &&
          node.items.length >= i + 1 &&
          node.items[i + 1].tk == '[') {
        item.tk = '\\nroot';
        var arg1 = TeXNode(TeXNodeType.list, []);
        item.args.add(arg1);
        node.items.removeAt(i + 1);
        while (node.items.length >= i + 1 && node.items[i + 1].tk != ']') {
          arg1.items.add(node.items.removeAt(i + 1));
        }
        if (node.items[i + 1].tk == ']') {
          node.items.removeAt(i + 1);
        } else {
          throw Exception('ERROR: \\sqrt is not well formatted');
        }
      }
      // gather arguments
      for (var j = 0; j < n; j++) {
        if (i + 1 >= node.items.length) {
          throw Exception(
              'ERROR: ${item.tk} excepts ${n.toString()} arguments!');
        }
        var item2 = node.items.removeAt(i + 1);
        if (item2.type == TeXNodeType.unary) {
          item2 = TeXNode(TeXNodeType.list, [item2]);
        }
        item.args.add(item2);
      }
    }
  }
  return node;
}

/// Sets subscript ("_") and superscript ("^") to tex nodes.
TeXNode _processSubSup(TeXNode node) {
  for (var i = 0; i < node.items.length; i++) {
    node.items[i] = _processSubSup(node.items[i]);
  }
  for (var i = 0; i < node.args.length; i++) {
    node.args[i] = _processSubSup(node.args[i]);
  }
  for (var i = 0; i < node.items.length; i++) {
    if (i > 0 && node.items[i].tk == '^' && i + 1 < node.items.length) {
      if (node.items[i - 1].sup != null) {
        throw Exception('ERROR: use braces "{...}" when chaining "^"');
      }
      node.items[i - 1].sup = node.items[i + 1];
      node.items.removeAt(i); // remove "^"
      node.items.removeAt(i); // remove arg
      i--;
    } else if (i > 0 && node.items[i].tk == '_' && i + 1 < node.items.length) {
      if (node.items[i - 1].sub != null) {
        throw Exception('ERROR: use braces "{...}" when chaining "_"');
      }
      node.items[i - 1].sub = node.items[i + 1];
      node.items.removeAt(i); // remove "_"
      node.items.removeAt(i); // remove arg
      i--;
    }
  }
  return node;
}
