/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

import 'svg.dart';
import 'lex.dart';
import 'node.dart';
import 'tab.dart';

class TeX {
  final Lex _lex = Lex();
  Set<String> _usedLetters = {};

  String _lastParsed = '';
  String _error = '';

  bool _paintBox = false;

  String get lastParsed {
    return _lastParsed;
  }

  String get error {
    return _error;
  }

  String tex2svg(String src, [paintBox = false]) {
    _usedLetters = {};
    _paintBox = paintBox;
    _lex.set(src);
    try {
      var root = _parseTexList(false);
      _lastParsed = root.toString();
      print(_lastParsed); // TODO: remove this

      _layout(root, 0, 0);
      var commands = _generate(root, 4);

      final int belowHeight = 275; // TODO
      int minX = 0;
      int minY = -root.height;
      int width = root.width;
      int height = root.height + belowHeight;
      var defs = '';
      for (var id in _usedLetters) {
        var d = svgData[id];
        defs += '    <path id="${id}" d="${d}"></path>\n';
      }

      String boundingBoxes = '';
      if (paintBox) {
        boundingBoxes =
            '    <rect x="0" y="${-belowHeight}" width="$width" height="$height" fill="none" stroke="rgb(200,200,200)" stroke-width="50"></rect>\n' +
                '    <rect x="0" y="0" width="$width" height="${height - belowHeight}" fill="none" stroke="rgb(200,200,200)" stroke-width="25"></rect>\n';
      }

      commands =
          '  <g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)">\n$boundingBoxes$commands  </g>';
      var svg =
          '<svg style="" xmlns="http://www.w3.org/2000/svg" role="img" focusable="false" viewBox="$minX $minY $width $height" xmlns:xlink="http://www.w3.org/1999/xlink">\n  <defs>\n$defs  </defs>\n$commands\n</svg>\n';
      return svg;
    } catch (e) {
      _error = e.toString();
      return "";
    }
  }

  String _indent(String text, int numSpaces) {
    var lines = text.split("\n");
    var s = '';
    for (var line in lines) {
      for (var i = 0; i < numSpaces; i++) {
        s += ' ';
      }
      s += '$line\n';
    }
    return s;
  }

  String _generate(TeXNode node, indent) {
    if (node.isList) {
      var svg = _indent('<g transform="scale(${node.scaling})">', indent);
      for (var i = 0; i < node.items.length; i++) {
        var item = node.items[i];
        svg += _generate(item, indent + 2);
      }
      svg += _indent('</g>', indent);
      return svg;
    } else {
      var x = node.x;
      var y = node.y;
      var dx = node.dx;
      var scaling = node.scaling;
      var svg = _indent(
          '<g transform="translate(${x + dx},$y) scale($scaling)">', indent);
      svg += _indent('<use xlink:href="#${node.svgPathId}"></use>', indent + 2);
      if (_paintBox) {
        svg += _indent(
            '<rect x="${-dx}" y="0" width="${node.width}" height="${node.height}" fill="none" stroke="rgb(220,120,120)" stroke-width="15"></rect>',
            indent + 2);
      }
      if (node.sub != null) {
        var sub = node.sub as TeXNode;
        svg += _generate(sub, indent + 2);
      }
      if (node.sup != null) {
        var sup = node.sup as TeXNode;
        svg += _generate(sup, indent + 2);
      }
      svg += _indent('</g>', indent);
      return svg;
    }
  }

  void _layout(TeXNode node, int baseX, int baseY, [scaling = 1.0]) {
    if (node.isList) {
      int x = baseX;
      int y = baseY;
      node.x = x;
      node.y = y;
      node.scaling = scaling;
      for (var i = 0; i < node.items.length; i++) {
        var item = node.items[i];
        _layout(item, x, y, scaling);
        x += item.width;
        node.height = node.height > item.height ? node.height : item.height;
      }
      node.width = x - baseX;
    } else {
      int x = baseX;
      int y = baseY;
      var tk = node.tk;
      node.x = x;
      node.y = y;
      if (table.containsKey(tk)) {
        var entry = table[tk] as Map<Object, Object>;
        node.svgPathId = _createSvgPathId(entry["code"] as String, -1);
        x += entry["w"] as int;
        if (entry.containsKey("d")) {
          node.dx = entry["d"] as int;
        }
        node.height = 750;
      } else if (tk == "\\mathbb") {
        // TODO: flatter-function that replaces lists with one node by that node
        var bp = 1337;
      } else {
        throw Exception("unimplemented token '$tk'");
      }
      if (node.sub != null) {
        var sub = node.sub as TeXNode;
        _layout(sub, 875, -250, 0.7071);
        x += (sub.width * 0.7071).round();
        // TODO: 0.7071 may be "recursive"
        // TODO: sign of 600????
        //node.height =
        //    max<int>(node.height, (600 + sub.height * 0.7071).round());
      }
      if (node.sup != null) {
        var sup = node.sup as TeXNode;
        _layout(sup, 750, 600, 0.7071);
        x += (sup.width * 0.7071).round();
        // TODO: 0.7071 may be "recursive"
        var height = (600 + sup.height * 0.7071).round();
        node.height = node.height > height ? node.height : height;
      }
      node.width = x - baseX;
    }
  }

  // integrate this method directly at caller site
  String _createSvgPathId(String prefix, int num) {
    var id = prefix;
    if (num >= 0) id += num.toRadixString(16).toUpperCase();
    _usedLetters.add(id);
    return id;
  }

  //G texList = { texNode };
  TeXNode _parseTexList(bool parseBraces) {
    if (parseBraces) {
      if (_lex.token == '{') {
        _lex.next();
      } else {
        throw Exception('ERROR: expected {');
      }
    }
    var list = TeXNode(true, []);
    while (_lex.token != Lex.lexEnd && _lex.token != '}') {
      list.items.add(_parseTexNode());
    }
    if (parseBraces) {
      if (_lex.token == '}') {
        _lex.next();
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

  //G texNode = "\" ID { "{" texList "}" } | ID | INT | ...;
  TeXNode _parseTexNode() {
    if (_lex.token == '{') {
      return _parseTexList(true);
    } else {
      var node = TeXNode(false, []);
      node.tk += _lex.token;
      if (node.tk.startsWith("\\") == false && node.tk.length != 1) {
        throw Exception("unimplemented!");
      }
      _lex.next();
      while (_lex.token == '^' || _lex.token == '_') {
        var del = _lex.token;
        _lex.next();
        if (del == '^' && node.sup != null) {
          throw Exception('ERROR: use { } when chaining ^');
        } else if (del == '_' && node.sub != null) {
          throw Exception('ERROR: use { } when chaining _');
        }
        if (del == '_') {
          node.sub = _lex.token == '{'
              ? _parseTexList(true)
              : TeXNode(true, [_parseTexNode()]);
        }
        if (del == '^') {
          node.sup = _lex.token == '{'
              ? _parseTexList(true)
              : TeXNode(true, [_parseTexNode()]);
        }
      }
      return node;
    }
  }
}
