This directory implements the extraction from SVG glyph data from MathJax.
- File `font.js` does the extraction; based on the characters defined in `/meta/glyphs.csv` of the repository. It writes file `/lib/src/svg.dart`.
- File `char.js` can be used for tests. Run e.g. `node font/char.js "\emptyset"` to output the MathJax glyph identifier of the TeX `\emptyset` character (for the example: `MJX-1-TEX-N-2205`).
