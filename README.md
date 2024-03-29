<div style="text-align: center">
  <img src="https://raw.githubusercontent.com/andreas-schwenk/tex/main/docs/tex-logo.svg?v=2" style="max-width: 256px;"/>
</div>

`tex` is a tiny TeX engine that creates SVG images from TeX strings.
Currently, only the math environment (e.g. `$ f(x) = x^2 $`) is supported.
Compared to other TeX renderers, this package does NOT rely on JavaScript or any other dependencies.

You will find a playground at [https://andreas-schwenk.github.io/tex](https://andreas-schwenk.github.io/tex). Alternatively, open file `/docs/index.html` in your browser. A local web server is not required.

**Warning: this package is under development. Many more TeX macros will be supported soon**

## Features

- Rendering of SVG images from TeX sources
- All data is packed into code. There is no need to load anything at runtime.

## Getting started

Add the package into your package's `pubspec.yaml` file:

```yaml
dependencies:
  tex: ^1.0.2
```

Make sure to use the most recent version from [https://pub.dev/packages/tex](https://pub.dev/packages/tex).

## Usage

The following example creates an SVG image data string from a TeX string.

```dart
import 'package:tex/tex.dart';

void main() {
  // set the equation to render
  var src = "\\sum_{k=1}^n \\frac{1}{k(k+1)} = \\frac{n}{n+1}";
  // instantiate tex
  var tex = TeX();
  // set the RGB color (red color)
  tex.setColor(157, 59, 50); 
  // set the scaling factor
  tex.scalingFactor = 2.0;
  // create SVG data
  var svgImageData = tex.tex2svg(src, displayStyle: true);
  // check for errors
  if (tex.success()) {
    // prints "<svg ...";
    print(svgImageData);
  } else {
    // error handling
    print('Errors occurred: ${tex.error}');
  }
}
```

Output SVG:

<img src="https://raw.githubusercontent.com/andreas-schwenk/tex/main/img/example2.svg" style="height:48px; background-color: white;"/>

## Website integration

This example displays an equation as inline math in fluent text. The complete code can be found in directory `/examples/web`.

CSS:
```css
.equation {
  padding-left: 1px;
  padding-right: 1px;
  display: inline-block;
  vertical-align: middle;
}
```

HTML:
```html
<p>
  Einsteins famous equation is
  <span id="einstein" class="equation"></span>.
</p>
```

Dart:
```dart
import 'dart:html';
import 'dart:convert';

import 'package:tex/tex.dart';

void main() {
  setEquationToSpan("#einstein", "E=mc^2");
}

void setEquationToSpan(String spanId, String src) {
  // instantiate tex
  var tex = TeX();
  // set the scaling factor
  tex.scalingFactor = 1.0;
  // create SVG data from TeX data
  var svg = tex.tex2svg(src, displayStyle=false);
  // debug output
  print(svg);
  // successful?
  if (tex.success()) {
    // create an image element
    var svgBase64 = base64Encode(utf8.encode(svg));
    var img = document.createElement('img') as ImageElement;
    img.src = "data:image/svg+xml;base64,$svgBase64";
    img.style.verticalAlign = "bottom";
    // get the span element and add the image
    var span = querySelector(spanId) as SpanElement;
    span.innerHtml = '';
    span.append(img);
  }
}
```

## Flutter

The following code excerpt creates a Span Widget that displays inline math. We use the package `flutter_svg` to render SVG images.

```dart
import 'package:tex/tex.dart';
import 'package:flutter_svg/flutter_svg.dart';

...
// create a target widget element
Widget equationWidget;
// instantiate TeX
var tex = TeX();
// set the scaling factor
tex.scalingFactor = 1.1;
// create SVG data from TeX data
var svg = tex.tex2svg(texSrc);
if (tex.success() == false) {
  // in case of errors: generate a TextSpan
  // element containing an error description.
  equationWidget = TextSpan(
    text: tex.error,
    style: TextStyle(color: Colors.red),
  );
} else {
  // in case everything works: create a WidgetSpan
  // element containing an SVG image.
  var width = tex.width.toDouble()
  equationWidget = WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: SvgPicture.string(svg, width: width),
  );
}
...
```

## Additional information

File `meta/glyphs.csv` specifies the glyphs.

For building the fonts, [python3](https://www.python.org) and [node](https://nodejs.org/en/) must be installed. This is only required for developers of this package.

```bash
./build.sh
```

## License of MathJax

This package extracts SVG image data of glyphs from [MathJax](https://www.mathjax.org). All rights remain to the authors. MathJax is licensed under the Apache2 license. You will find a copy of Apache2 license in folder `/licenses/mathJax/` of this repository.

All extracted data from MathJax can be found in variable `svgData` of file `/lib/src/svg.dart`.
