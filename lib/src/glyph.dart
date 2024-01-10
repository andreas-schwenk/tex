/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

/// Description of a glyph.
class Glyph {
  /// The x coordinate.
  double x = 0.0;

  /// The y coordinate.
  double y = 0.0;

  /// The width.
  double width = 0.0;

  /// The height.
  double height = 0.0;

  /// The horizontal scaling.
  double xScaling = 1.0;

  /// The vertical scaling
  double yScaling = 1.0;

  /// The nodes TeX-token name.
  String tk = '';

  /// The ID of map "svgData" in file svg.dart.
  String svgPathId = '';
}
