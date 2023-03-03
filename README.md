<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

`dart:tex` is a tiny TeX engine that creates SVG images.

Website: [https://andreas-schwenk.github.io/tex](https://andreas-schwenk.github.io/tex)

## Features

- rendering of SVG images from TeX sources
- all data is packed to code; there is no need to load any data file at runtime
- only equations can be rendered

**Warning: this package is still under development**

## Getting started

## Usage

<!-- TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. -->

```dart
import 'dart:tex';

void main() {
  var tex = TeX();
  var svgImageData = tex.tex2svg("x^2 + y^2");
  if (svgImageData.isEmpty) {
    print('Errors occurred: ${tex.error}');
  }
  print(svgImageData);
}
```

## Additional information

For building the fonts, `Python` and `node` must be installed. This is only required for developers of this package.

## License of MathJax

This package extracts SVG image data of glyphs from [MathJax](https://www.mathjax.org). All rights remains at the authors. MathJax is licensed under the Apache2 license. You will find a copy of the license in folder `ext-licenses/` of this repository. You will find the mentioned data under `/lib/src/svg.dart` in variable `svgData`.

<!--TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
-->
