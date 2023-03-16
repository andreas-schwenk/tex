## 0.4.0

- added \left and \right
- initial support for display style vs inline math mode
- added glyph for \pm
- added website that compares Dart-TeX with MathJax
- sub and sup for matrixes are now vertically aligned correctly
- improved glyph dimensions
- fixing of minor bugs

## 0.3.1

- the height attribute is now exported in the SVG data
- added examples
- website updates

## 0.3.0

- added glyphs for \angle, \blacksquare, \Box, \boxtimes, \cdots, \complement, \cong, \ddots, \div, \equiv, \Im, \langle, \lnot, \nabla, \neg, \neq, \perp, \rangle, \Re, \setminus, \simeq, \square, \triangle, \varnothing, \vdots, \wp
- improved \lim
- fixed parsing and typesetting bugs
- fixed SVG output, s.t. that no longer an exception in flutter_svg is thrown for \overline and \sqrt

## 0.2.0

- color can be set as RGB value
- added glyphs for ', \oint, \otimes, \oplus, \subset, \supset, \subseteq, \supseteq, \sim, \approx, \partial
- added \matrix, \bmatrix, \Bmatrix, \vmatrix
- matrix columns now be aligned to left, center or right
- added \cases
- added \overline
- added standard functions \arccos, \arcsin, \arctan, \arg, \cos, \cosh, \cot, \coth, \csc, \deg, \det, \dim, \exp, \gcd, \hom, \inf, \ker, \lg, \lim, \liminf, \limsup, \ln, \log, \max, \min, \mod, \Pr, \sec, \sin, \sinh, \sup, \tan, \tanh
- improved glyph dimensions

## 0.1.1

- integrals via \int
- (initial) support for sums and products via \sum and \prod
- spacing via \, and ~

## 0.1.0

- initial support for matrices
- restructured and simplified code
- bug fixes

## 0.0.7

- support for macros (yet w/o parameters)
- added glyphs: decimal point, braces, emptyset
- extended example page

## 0.0.6

- bug fixes

## 0.0.5

- inline text rendering is now correctly vertical aligned
- basic support for \sqrt
- SVG output is not any more hierarchically; all glyphs have global coordinates
- increased code readability
- added code comments

## 0.0.4

- image width encoded into SVG data
- API offers scaling factor
- better support for fractions
- inline equation examples on demo page (alignment is still WIP)

## 0.0.3

- code documentation

## 0.0.2

- added rudimentary support for fractions
- added \sin, \cos, ...
- minor fixes

## 0.0.1

- Initial version.
