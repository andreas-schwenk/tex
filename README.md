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
  tex: ^0.1.1
```

Make sure to use the latest version!

## Usage

```dart
import 'package:tex/tex.dart';

void main() {
  var tex = TeX();
  var svgImageData = tex.tex2svg("f(x,y) = x^2 + y^2");
  if (svgImageData.isEmpty) {
    print('Errors occurred: ${tex.error}');
  } else {
    print(svgImageData);
  }
}
```

Output SVG:

<img src="https://raw.githubusercontent.com/andreas-schwenk/tex/main/img/example.svg" style="height:48px; background-color: white;">

## Additional information

File `meta/glyphs.csv` specifies the glyphs.

For building the fonts, [python3](https://www.python.org) and [node](https://nodejs.org/en/) must be installed. This is only required for developers of this package.

```bash
./build.sh
```

## License of MathJax

This package extracts SVG image data of glyphs from [MathJax](https://www.mathjax.org). All rights remain to the authors. MathJax is licensed under the Apache2 license. You will find a copy of Apache2 license in folder `licenses/mathJax/` of this repository.

All extracted data from MathJax can be found in variable `svgData` of file `/lib/src/svg.dart`.
