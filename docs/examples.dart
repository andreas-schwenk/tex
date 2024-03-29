/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

final examples = [
  'abcdefg',
  '\\text{abcdefg}',
  'f(x)=x^2',
  '\\frac 1 {x+1}',
  '\\frac{z_1}{z_2}',
  '\\sin x',
  'r \\sin(x) + \\cos x',
  "\\sqrt{x+1}",
  "\\sqrt[n+1]{x}",
  "\\overline{abc}",
  "\\dot{x}",
  "\\ddot{a}",
  "\\hat{x}y\\hat{X}",
  "\\tilde{x}",
  '\\mathbb{N}^2',
  '\\lim_{x\\to\\infty}\\frac1x',
  "\\begin{matrix}\n  1 & 2 \\\\\n  3 & 4 \\\\\n\\end{matrix}",
  "\\begin{pmatrix}\n  1 & 2 \\\\\n  3 & 4 \\\\\n\\end{pmatrix}^T",
  "\\begin{bmatrix}\n  \\frac12 & 2 \\\\\n  3 & 4 \\\\\n\\end{bmatrix}",
  "\\begin{Bmatrix}\n  1 & 2 \\\\\n  3 & 4 \\\\\n\\end{Bmatrix}",
  "\\begin{vmatrix}\n  1+\\alpha & 2 \\\\\n  3 & 4 \\\\\n\\end{vmatrix}",
  "\\begin{vmatrix}[lc]\n  1+\\alpha & 2 \\\\\n  3 & 4 \\\\\n\\end{vmatrix}",
  "sgn(x)=\\begin{cases}\n  -1 & x<0 \\\\\n  1 & x>0 \\\\\n  0 & \\text{otherwise}\n\\end{cases}",
  "\\int_2^5 x \\, dx",
  "\\sum_{i=1}^5 i^2",
  "\\prod_{i=1}^5 i^2",
  "\\{1, 2, \\dots, 5\\}",
  "\\left( \\frac1x \\right)^2",
  "\\left| \\frac1x \\right|",
  "1, \\frac12, \\frac{1}{\\frac23}, \\frac{1}{\\frac{2}{\\frac34}},\\frac21, \\frac{\\frac23}{1}, \\frac{x+\\frac{2}{\\frac43}}{1},\\frac{x+2}1",
  "\\left\\{ \\frac{\\frac12}{ \\left( \\frac34 \\right) } \\right\\},\\left( \\frac12 \\right),\\left[ \\frac12 \\right],\\left[ 1 \\right],\\left( 1 \\right),\\left( . \\right)"
];
