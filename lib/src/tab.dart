/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

// !!! THIS FILE WAS AUTO-CREATED BY meta/run.py !!!
// !!! ANY CHANGES IN THIS FILE WILL BE OVERWRITTEN !!!

const Map<String, String> macros = {
  "\\CC": "\\mathbb{C}",
  "\\NN": "\\mathbb{N}",
  "\\QQ": "\\mathbb{Q}",
  "\\RR": "\\mathbb{R}",
  "\\ZZ": "\\mathbb{Z}",
};

const Map<String, int> numArgs = {
  "\\dot": 1,
  "\\ddot": 1,
  "\\frac": 2,
  "\\hat": 1,
  "\\mathbb": 1,
  "\\mathcal": 1,
  "\\overline": 1,
  "\\sqrt": 1,
  "\\text": 1,
  "\\tilde": 1,
};

const Set<String> functions = {
  "\\arccos",
  "\\arcsin",
  "\\arctan",
  "\\arg",
  "\\cos",
  "\\cosh",
  "\\cot",
  "\\coth",
  "\\csc",
  "\\deg",
  "\\det",
  "\\dim",
  "\\exp",
  "\\gcd",
  "\\hom",
  "\\inf",
  "\\ker",
  "\\lg",
  "\\liminf",
  "\\limsup",
  "\\ln",
  "\\log",
  "\\max",
  "\\min",
  "\\mod",
  "\\Pr",
  "\\sec",
  "\\sin",
  "\\sinh",
  "\\sup",
  "\\tan",
  "\\tanh",
};

const table = {
  "\\dot": {"code": "TEX-N-2D9", "w": 500, "h": 750, "d": 0},
  "\\ddot": {"code": "TEX-N-A8", "w": 500, "h": 750, "d": 0},
  "\\hat": {"code": "TEX-N-5E", "w": 500, "h": 750, "d": 0},
  "\\sqrt": {"code": "TEX-N-221A", "w": 860, "h": 750, "d": 100},
  "\\tilde": {"code": "TEX-N-7E", "w": 550, "h": 350, "d": 0},
  "A": {"code": "TEX-I-1D434", "w": 800, "h": 750, "d": 0},
  "B": {"code": "TEX-I-1D435", "w": 800, "h": 750, "d": 0},
  "C": {"code": "TEX-I-1D436", "w": 800, "h": 750, "d": 0},
  "D": {"code": "TEX-I-1D437", "w": 800, "h": 750, "d": 0},
  "E": {"code": "TEX-I-1D438", "w": 800, "h": 750, "d": 0},
  "F": {"code": "TEX-I-1D439", "w": 800, "h": 750, "d": 0},
  "G": {"code": "TEX-I-1D43A", "w": 800, "h": 750, "d": 0},
  "H": {"code": "TEX-I-1D43B", "w": 800, "h": 750, "d": 0},
  "I": {"code": "TEX-I-1D43C", "w": 550, "h": 750, "d": 0},
  "J": {"code": "TEX-I-1D43D", "w": 650, "h": 750, "d": 0},
  "K": {"code": "TEX-I-1D43E", "w": 800, "h": 750, "d": 0},
  "L": {"code": "TEX-I-1D43F", "w": 800, "h": 750, "d": 0},
  "M": {"code": "TEX-I-1D440", "w": 950, "h": 750, "d": 0},
  "N": {"code": "TEX-I-1D441", "w": 800, "h": 750, "d": 0},
  "O": {"code": "TEX-I-1D442", "w": 800, "h": 750, "d": 0},
  "P": {"code": "TEX-I-1D443", "w": 800, "h": 750, "d": 0},
  "Q": {"code": "TEX-I-1D444", "w": 800, "h": 750, "d": 0},
  "R": {"code": "TEX-I-1D445", "w": 800, "h": 750, "d": 0},
  "S": {"code": "TEX-I-1D446", "w": 800, "h": 750, "d": 0},
  "T": {"code": "TEX-I-1D447", "w": 800, "h": 750, "d": 0},
  "U": {"code": "TEX-I-1D448", "w": 800, "h": 750, "d": 0},
  "V": {"code": "TEX-I-1D449", "w": 800, "h": 750, "d": 0},
  "W": {"code": "TEX-I-1D44A", "w": 900, "h": 750, "d": 0},
  "X": {"code": "TEX-I-1D44B", "w": 850, "h": 750, "d": 0},
  "Y": {"code": "TEX-I-1D44C", "w": 750, "h": 750, "d": 0},
  "Z": {"code": "TEX-I-1D44D", "w": 800, "h": 750, "d": 0},
  "a": {"code": "TEX-I-1D44E", "w": 550, "h": 500, "d": 0},
  "b": {"code": "TEX-I-1D44F", "w": 450, "h": 750, "d": 0},
  "c": {"code": "TEX-I-1D450", "w": 500, "h": 500, "d": 0},
  "d": {"code": "TEX-I-1D451", "w": 550, "h": 750, "d": 0},
  "e": {"code": "TEX-I-1D452", "w": 450, "h": 500, "d": 0},
  "f": {"code": "TEX-I-1D453", "w": 550, "h": 750, "d": 0},
  "g": {"code": "TEX-I-1D454", "w": 550, "h": 500, "d": 0},
  "h": {"code": "TEX-I-210E", "w": 550, "h": 750, "d": 0},
  "i": {"code": "TEX-I-1D456", "w": 350, "h": 750, "d": 0},
  "j": {"code": "TEX-I-1D457", "w": 400, "h": 750, "d": 0},
  "k": {"code": "TEX-I-1D458", "w": 550, "h": 750, "d": 0},
  "l": {"code": "TEX-I-1D459", "w": 350, "h": 750, "d": 0},
  "m": {"code": "TEX-I-1D45A", "w": 850, "h": 500, "d": 0},
  "n": {"code": "TEX-I-1D45B", "w": 600, "h": 500, "d": 0},
  "o": {"code": "TEX-I-1D45C", "w": 550, "h": 500, "d": 0},
  "p": {"code": "TEX-I-1D45D", "w": 550, "h": 500, "d": 0},
  "q": {"code": "TEX-I-1D45E", "w": 550, "h": 500, "d": 0},
  "r": {"code": "TEX-I-1D45F", "w": 450, "h": 500, "d": 0},
  "s": {"code": "TEX-I-1D460", "w": 475, "h": 500, "d": 0},
  "t": {"code": "TEX-I-1D461", "w": 400, "h": 750, "d": 0},
  "u": {"code": "TEX-I-1D462", "w": 600, "h": 500, "d": 0},
  "v": {"code": "TEX-I-1D463", "w": 500, "h": 500, "d": 0},
  "w": {"code": "TEX-I-1D464", "w": 750, "h": 500, "d": 0},
  "x": {"code": "TEX-I-1D465", "w": 550, "h": 500, "d": 0},
  "y": {"code": "TEX-I-1D466", "w": 500, "h": 500, "d": 0},
  "z": {"code": "TEX-I-1D467", "w": 500, "h": 500, "d": 0},
  "0": {"code": "TEX-N-30", "w": 500, "h": 750, "d": 0},
  "1": {"code": "TEX-N-31", "w": 500, "h": 750, "d": 0},
  "2": {"code": "TEX-N-32", "w": 500, "h": 750, "d": 0},
  "3": {"code": "TEX-N-33", "w": 500, "h": 750, "d": 0},
  "4": {"code": "TEX-N-34", "w": 500, "h": 750, "d": 0},
  "5": {"code": "TEX-N-35", "w": 500, "h": 750, "d": 0},
  "6": {"code": "TEX-N-36", "w": 500, "h": 750, "d": 0},
  "7": {"code": "TEX-N-37", "w": 500, "h": 750, "d": 0},
  "8": {"code": "TEX-N-38", "w": 500, "h": 750, "d": 0},
  "9": {"code": "TEX-N-39", "w": 500, "h": 750, "d": 0},
  "-": {"code": "TEX-N-2212", "w": 1200, "h": 750, "d": 200},
  ".": {"code": "TEX-N-2E", "w": 250, "h": 250, "d": 0},
  ",": {"code": "TEX-N-2C", "w": 350, "h": 250, "d": 0},
  ":": {"code": "TEX-N-3A", "w": 350, "h": 650, "d": 0},
  "!": {"code": "TEX-N-21", "w": 350, "h": 750, "d": 0},
  "'": {"code": "TEX-V-2032", "w": 350, "h": 750, "d": 0},
  "(": {"code": "TEX-N-28", "w": 350, "h": 800, "d": 0},
  ")": {"code": "TEX-N-29", "w": 300, "h": 800, "d": 0},
  "[": {"code": "TEX-N-5B", "w": 300, "h": 750, "d": 0},
  "]": {"code": "TEX-N-5D", "w": 300, "h": 750, "d": 0},
  "\\{": {"code": "TEX-N-7B", "w": 475, "h": 750, "d": 0},
  "\\}": {"code": "TEX-N-7D", "w": 475, "h": 750, "d": 0},
  "*": {"code": "TEX-N-2217", "w": 700, "h": 550, "d": 100},
  "\\cdot": {"code": "TEX-N-22C5", "w": 500, "h": 600, "d": 100},
  "/": {"code": "TEX-N-2F", "w": 700, "h": 850, "d": 150},
  "+": {"code": "TEX-N-2B", "w": 1200, "h": 750, "d": 200},
  "<": {"code": "TEX-N-3C", "w": 1200, "h": 650, "d": 200},
  "=": {"code": "TEX-N-3D", "w": 1200, "h": 650, "d": 200},
  ">": {"code": "TEX-N-3E", "w": 1200, "h": 650, "d": 200},
  "|": {"code": "TEX-N-7C", "w": 300, "h": 850, "d": 50},
  "?": {"code": "TEX-N-3F", "w": 450, "h": 750, "d": 0},
  "\\alpha": {"code": "TEX-I-1D6FC", "w": 650, "h": 550, "d": 0},
  "\\beta": {"code": "TEX-I-1D6FD", "w": 650, "h": 750, "d": 0},
  "\\gamma": {"code": "TEX-I-1D6FE", "w": 650, "h": 550, "d": 0},
  "\\Gamma": {"code": "TEX-N-393", "w": 700, "h": 750, "d": 0},
  "\\delta": {"code": "TEX-I-1D6FF", "w": 650, "h": 750, "d": 0},
  "\\Delta": {"code": "TEX-N-394", "w": 800, "h": 750, "d": 0},
  "\\epsilon": {"code": "TEX-I-1D716", "w": 550, "h": 550, "d": 0},
  "\\varepsilon": {"code": "TEX-I-1D700", "w": 550, "h": 550, "d": 0},
  "\\zeta": {"code": "TEX-I-1D701", "w": 650, "h": 750, "d": 0},
  "\\eta": {"code": "TEX-I-1D702", "w": 650, "h": 550, "d": 0},
  "\\theta": {"code": "TEX-I-1D703", "w": 650, "h": 750, "d": 0},
  "\\vartheta": {"code": "TEX-I-1D717", "w": 650, "h": 750, "d": 0},
  "\\Theta": {"code": "TEX-N-398", "w": 700, "h": 750, "d": 0},
  "\\iota": {"code": "TEX-I-1D704", "w": 450, "h": 550, "d": 0},
  "\\kappa": {"code": "TEX-I-1D705", "w": 650, "h": 550, "d": 0},
  "\\lambda": {"code": "TEX-I-1D706", "w": 650, "h": 750, "d": 0},
  "\\Lambda": {"code": "TEX-N-39B", "w": 650, "h": 750, "d": 0},
  "\\mu": {"code": "TEX-I-1D707", "w": 650, "h": 550, "d": 0},
  "\\nu": {"code": "TEX-I-1D708", "w": 650, "h": 550, "d": 0},
  "\\xi": {"code": "TEX-I-1D709", "w": 650, "h": 750, "d": 0},
  "\\Xi": {"code": "TEX-N-39E", "w": 650, "h": 750, "d": 0},
  "\\pi": {"code": "TEX-I-1D70B", "w": 650, "h": 550, "d": 0},
  "\\Pi": {"code": "TEX-N-3A0", "w": 750, "h": 750, "d": 0},
  "\\rho": {"code": "TEX-I-1D70C", "w": 650, "h": 550, "d": 0},
  "\\varrho": {"code": "TEX-I-1D71A", "w": 650, "h": 550, "d": 0},
  "\\varsigma": {"code": "TEX-I-1D70D", "w": 650, "h": 550, "d": 0},
  "\\sigma": {"code": "TEX-I-1D70E", "w": 650, "h": 550, "d": 0},
  "\\Sigma": {"code": "TEX-N-3A3", "w": 650, "h": 750, "d": 0},
  "\\tau": {"code": "TEX-I-1D70F", "w": 750, "h": 550, "d": 0},
  "\\upsilon": {"code": "TEX-I-1D710", "w": 650, "h": 550, "d": 0},
  "\\Upsilon": {"code": "TEX-N-3A5", "w": 750, "h": 750, "d": 0},
  "\\phi": {"code": "TEX-I-1D719", "w": 650, "h": 750, "d": 0},
  "\\varphi": {"code": "TEX-I-1D711", "w": 650, "h": 550, "d": 0},
  "\\Phi": {"code": "TEX-N-3A6", "w": 750, "h": 750, "d": 0},
  "\\chi": {"code": "TEX-I-1D712", "w": 650, "h": 550, "d": 0},
  "\\psi": {"code": "TEX-I-1D713", "w": 650, "h": 750, "d": 0},
  "\\Psi": {"code": "TEX-N-3A8", "w": 750, "h": 750, "d": 0},
  "\\omega": {"code": "TEX-I-1D714", "w": 650, "h": 550, "d": 0},
  "\\Omega": {"code": "TEX-N-3A9", "w": 750, "h": 750, "d": 0},
  "\\angle": {"code": "TEX-N-2220", "w": 700, "h": 750, "d": 0},
  "\\approx": {"code": "TEX-N-2248", "w": 1200, "h": 750, "d": 200},
  "\\blacksquare": {"code": "TEX-I-25FC", "w": 750, "h": 750, "d": 0},
  "\\Box": {"code": "TEX-I-25FB", "w": 800, "h": 750, "d": 0},
  "\\boxtimes": {"code": "TEX-N-22A0", "w": 750, "h": 750, "d": 0},
  "\\cap": {"code": "TEX-N-2229", "w": 950, "h": 750, "d": 250},
  "\\cdots": {"code": "TEX-N-22EF", "w": 1250, "h": 750, "d": 0},
  "\\circ": {"code": "TEX-N-2218", "w": 600, "h": 750, "d": 50},
  "\\complement": {"code": "TEX-I-2201", "w": 500, "h": 750, "d": 0},
  "\\cong": {"code": "TEX-N-2245", "w": 750, "h": 750, "d": 0},
  "\\cup": {"code": "TEX-N-222A", "w": 950, "h": 750, "d": 250},
  "\\ddots": {"code": "TEX-N-22F1", "w": 1250, "h": 850, "d": 0},
  "\\div": {"code": "TEX-N-F7", "w": 775, "h": 700, "d": 0},
  "\\dots": {"code": "TEX-N-2026", "w": 1250, "h": 350, "d": 0},
  "\\downarrow": {"code": "TEX-N-2193", "w": 950, "h": 750, "d": 200},
  "\\Downarrow": {"code": "TEX-N-21D3", "w": 950, "h": 750, "d": 200},
  "\\emptyset": {"code": "TEX-N-2205", "w": 500, "h": 750, "d": 0},
  "\\equiv": {"code": "TEX-N-2261", "w": 850, "h": 650, "d": 0},
  "\\exists": {"code": "TEX-N-2203", "w": 750, "h": 750, "d": 50},
  "\\forall": {"code": "TEX-N-2200", "w": 750, "h": 750, "d": 50},
  "\\geq": {"code": "TEX-N-2265", "w": 950, "h": 750, "d": 100},
  "\\Im": {"code": "TEX-N-2111", "w": 575, "h": 750, "d": 0},
  "\\in": {"code": "TEX-N-2208", "w": 950, "h": 750, "d": 100},
  "\\infty": {"code": "TEX-N-221E", "w": 1000, "h": 550, "d": 0},
  "\\int": {"code": "TEX-LO-222B", "w": 1000, "h": 750, "d": 0},
  "\\int-INLINE": {"code": "TEX-SO-222B", "w": 1000, "h": 750, "d": 0},
  "\\land": {"code": "TEX-N-2227", "w": 950, "h": 750, "d": 100},
  "\\langle": {"code": "TEX-N-27E8", "w": 350, "h": 750, "d": 0},
  "\\leftarrow": {"code": "TEX-N-2190", "w": 1400, "h": 750, "d": 200},
  "\\Leftarrow": {"code": "TEX-N-21D0", "w": 1400, "h": 750, "d": 200},
  "\\leftharpoondown": {"code": "TEX-N-21BD", "w": 1400, "h": 750, "d": 200},
  "\\leftharpoonup": {"code": "TEX-N-21BC", "w": 1400, "h": 750, "d": 200},
  "\\leftrightarrow": {"code": "TEX-N-2194", "w": 1400, "h": 750, "d": 200},
  "\\Leftrightarrow": {"code": "TEX-N-21D4", "w": 1400, "h": 750, "d": 200},
  "\\Longleftrightarrow": {"code": "TEX-N-27FA", "w": 1900, "h": 750, "d": 200},
  "\\leq": {"code": "TEX-N-2264", "w": 950, "h": 750, "d": 100},
  "\\lfloor": {"code": "TEX-N-230A", "w": 500, "h": 750, "d": 50},
  "\\rfloor": {"code": "TEX-N-230B", "w": 500, "h": 750, "d": 50},
  "\\lnot": {"code": "TEX-N-AC", "w": 700, "h": 750, "d": 0},
  "\\longmapsto": {"code": "TEX-N-27FC", "w": 2000, "h": 750, "d": 200},
  "\\lor": {"code": "TEX-N-2228", "w": 950, "h": 750, "d": 100},
  "\\mapsto": {"code": "TEX-N-21A6", "w": 1100, "h": 750, "d": 100},
  "\\mp": {"code": "TEX-N-2213", "w": 1200, "h": 750, "d": 200},
  "\\nabla": {"code": "TEX-N-2207", "w": 800, "h": 750, "d": 0},
  "\\nearrow": {"code": "TEX-N-2197", "w": 1400, "h": 750, "d": 200},
  "\\neg": {"code": "TEX-N-AC", "w": 700, "h": 750, "d": 0},
  "\\neq": {"code": "TEX-N-2260", "w": 800, "h": 750, "d": 0},
  "\\notin": {"code": "TEX-N-2209", "w": 950, "h": 750, "d": 100},
  "\\nwarrow": {"code": "TEX-N-2196", "w": 1400, "h": 750, "d": 200},
  "\\oint": {"code": "TEX-LO-222E", "w": 1000, "h": 750, "d": 0},
  "\\oint-INLINE": {"code": "TEX-SO-222E", "w": 1000, "h": 750, "d": 0},
  "\\oplus": {"code": "TEX-N-2295", "w": 750, "h": 750, "d": 0},
  "\\otimes": {"code": "TEX-N-2297", "w": 750, "h": 750, "d": 0},
  "\\partial": {"code": "TEX-I-1D715", "w": 575, "h": 750, "d": 0},
  "\\perp": {"code": "TEX-N-22A5", "w": 750, "h": 750, "d": 0},
  "\\pm": {"code": "TEX-N-B1", "w": 1200, "h": 750, "d": 200},
  "\\prod": {"code": "TEX-LO-220F", "w": 1400, "h": 750, "d": 0},
  "\\prod-INLINE": {"code": "TEX-SO-220F", "w": 1000, "h": 750, "d": 0},
  "\\rangle": {"code": "TEX-N-27E9", "w": 350, "h": 750, "d": 0},
  "\\Re": {"code": "TEX-N-211C", "w": 875, "h": 750, "d": 0},
  "\\rightarrow": {"code": "TEX-N-2192", "w": 1400, "h": 750, "d": 200},
  "\\Rightarrow": {"code": "TEX-N-21D2", "w": 1400, "h": 750, "d": 200},
  "\\rightharpoondown": {"code": "TEX-N-21C1", "w": 1400, "h": 750, "d": 200},
  "\\rightharpoonup": {"code": "TEX-N-21C0", "w": 1400, "h": 750, "d": 200},
  "\\rightleftharpoons": {"code": "TEX-V-21CC", "w": 1400, "h": 750, "d": 200},
  "\\searrow": {"code": "TEX-N-2198", "w": 1400, "h": 750, "d": 200},
  "\\setminus": {"code": "TEX-N-2216", "w": 800, "h": 750, "d": 200},
  "\\sim": {"code": "TEX-N-223C", "w": 800, "h": 750, "d": 0},
  "\\simeq": {"code": "TEX-N-2243", "w": 1000, "h": 750, "d": 0},
  "\\square": {"code": "TEX-I-25FB", "w": 750, "h": 750, "d": 0},
  "\\subset": {"code": "TEX-N-2282", "w": 750, "h": 750, "d": 0},
  "\\subseteq": {"code": "TEX-N-2286", "w": 750, "h": 750, "d": 0},
  "\\sum": {"code": "TEX-LO-2211", "w": 1500, "h": 750, "d": 0},
  "\\sum-INLINE": {"code": "TEX-SO-2211", "w": 1100, "h": 650, "d": 0},
  "\\supset": {"code": "TEX-N-2283", "w": 750, "h": 750, "d": 0},
  "\\supseteq": {"code": "TEX-N-2287", "w": 750, "h": 750, "d": 0},
  "\\swarrow": {"code": "TEX-N-2199", "w": 1400, "h": 750, "d": 200},
  "\\times": {"code": "TEX-N-D7", "w": 950, "h": 750, "d": 100},
  "\\to": {"code": "TEX-N-2192", "w": 1200, "h": 750, "d": 100},
  "\\triangle": {"code": "TEX-N-25B3", "w": 850, "h": 750, "d": 0},
  "\\uparrow": {"code": "TEX-N-2191", "w": 900, "h": 750, "d": 200},
  "\\Uparrow": {"code": "TEX-N-21D1", "w": 1000, "h": 750, "d": 200},
  "\\Updownarrow": {"code": "TEX-N-21D5", "w": 1000, "h": 750, "d": 200},
  "\\varnothing": {"code": "TEX-V-2205", "w": 750, "h": 750, "d": 0},
  "\\vdots": {"code": "TEX-N-22EE", "w": 250, "h": 750, "d": 0},
  "\\wedge": {"code": "TEX-N-2227", "w": 1000, "h": 750, "d": 200},
  "\\wp": {"code": "TEX-N-2118", "w": 675, "h": 750, "d": 0},
  "\\text{A}": {"code": "TEX-N-41", "w": 750, "h": 750, "d": 0},
  "\\text{B}": {"code": "TEX-N-42", "w": 700, "h": 750, "d": 0},
  "\\text{C}": {"code": "TEX-N-43", "w": 750, "h": 750, "d": 0},
  "\\text{D}": {"code": "TEX-N-44", "w": 750, "h": 750, "d": 0},
  "\\text{E}": {"code": "TEX-N-45", "w": 750, "h": 750, "d": 0},
  "\\text{F}": {"code": "TEX-N-46", "w": 700, "h": 750, "d": 0},
  "\\text{G}": {"code": "TEX-N-47", "w": 750, "h": 750, "d": 0},
  "\\text{H}": {"code": "TEX-N-48", "w": 750, "h": 750, "d": 0},
  "\\text{I}": {"code": "TEX-N-49", "w": 350, "h": 750, "d": 0},
  "\\text{J}": {"code": "TEX-N-4A", "w": 450, "h": 750, "d": 0},
  "\\text{K}": {"code": "TEX-N-4B", "w": 750, "h": 750, "d": 0},
  "\\text{L}": {"code": "TEX-N-4C", "w": 650, "h": 750, "d": 0},
  "\\text{M}": {"code": "TEX-N-4D", "w": 850, "h": 750, "d": 0},
  "\\text{N}": {"code": "TEX-N-4E", "w": 750, "h": 750, "d": 0},
  "\\text{O}": {"code": "TEX-N-4F", "w": 750, "h": 750, "d": 0},
  "\\text{P}": {"code": "TEX-N-50", "w": 700, "h": 750, "d": 0},
  "\\text{Q}": {"code": "TEX-N-51", "w": 750, "h": 750, "d": 0},
  "\\text{R}": {"code": "TEX-N-52", "w": 750, "h": 750, "d": 0},
  "\\text{S}": {"code": "TEX-N-53", "w": 500, "h": 750, "d": 0},
  "\\text{T}": {"code": "TEX-N-54", "w": 750, "h": 750, "d": 0},
  "\\text{U}": {"code": "TEX-N-55", "w": 750, "h": 750, "d": 0},
  "\\text{V}": {"code": "TEX-N-56", "w": 750, "h": 750, "d": 0},
  "\\text{W}": {"code": "TEX-N-57", "w": 1000, "h": 750, "d": 0},
  "\\text{X}": {"code": "TEX-N-58", "w": 750, "h": 750, "d": 0},
  "\\text{Y}": {"code": "TEX-N-59", "w": 750, "h": 750, "d": 0},
  "\\text{Z}": {"code": "TEX-N-5A", "w": 650, "h": 750, "d": 0},
  "\\text{a}": {"code": "TEX-N-61", "w": 550, "h": 500, "d": 0},
  "\\text{b}": {"code": "TEX-N-62", "w": 550, "h": 750, "d": 0},
  "\\text{c}": {"code": "TEX-N-63", "w": 500, "h": 500, "d": 0},
  "\\text{d}": {"code": "TEX-N-64", "w": 550, "h": 750, "d": 0},
  "\\text{e}": {"code": "TEX-N-65", "w": 500, "h": 500, "d": 0},
  "\\text{f}": {"code": "TEX-N-66", "w": 350, "h": 750, "d": 0},
  "\\text{g}": {"code": "TEX-N-67", "w": 550, "h": 500, "d": 0},
  "\\text{h}": {"code": "TEX-N-68", "w": 550, "h": 750, "d": 0},
  "\\text{i}": {"code": "TEX-N-69", "w": 250, "h": 750, "d": 0},
  "\\text{j}": {"code": "TEX-N-6A", "w": 300, "h": 750, "d": 0},
  "\\text{k}": {"code": "TEX-N-6B", "w": 550, "h": 750, "d": 0},
  "\\text{l}": {"code": "TEX-N-6C", "w": 350, "h": 750, "d": 0},
  "\\text{m}": {"code": "TEX-N-6D", "w": 800, "h": 500, "d": 0},
  "\\text{n}": {"code": "TEX-N-6E", "w": 550, "h": 500, "d": 0},
  "\\text{o}": {"code": "TEX-N-6F", "w": 500, "h": 500, "d": 0},
  "\\text{p}": {"code": "TEX-N-70", "w": 550, "h": 500, "d": 0},
  "\\text{q}": {"code": "TEX-N-71", "w": 550, "h": 500, "d": 0},
  "\\text{r}": {"code": "TEX-N-72", "w": 450, "h": 500, "d": 0},
  "\\text{s}": {"code": "TEX-N-73", "w": 375, "h": 500, "d": 0},
  "\\text{t}": {"code": "TEX-N-74", "w": 400, "h": 750, "d": 0},
  "\\text{u}": {"code": "TEX-N-75", "w": 550, "h": 500, "d": 0},
  "\\text{v}": {"code": "TEX-N-76", "w": 550, "h": 500, "d": 0},
  "\\text{w}": {"code": "TEX-N-77", "w": 750, "h": 500, "d": 0},
  "\\text{x}": {"code": "TEX-N-78", "w": 550, "h": 500, "d": 0},
  "\\text{y}": {"code": "TEX-N-79", "w": 550, "h": 500, "d": 0},
  "\\text{z}": {"code": "TEX-N-7A", "w": 450, "h": 500, "d": 0},
  "\\mathbb{A}": {"code": "TEX-D-1D538", "w": 750, "h": 750, "d": 0},
  "\\mathbb{B}": {"code": "TEX-D-1D539", "w": 700, "h": 750, "d": 0},
  "\\mathbb{C}": {"code": "TEX-D-2102", "w": 750, "h": 750, "d": 0},
  "\\mathbb{D}": {"code": "TEX-D-1D53B", "w": 750, "h": 750, "d": 0},
  "\\mathbb{E}": {"code": "TEX-D-1D53C", "w": 750, "h": 750, "d": 0},
  "\\mathbb{F}": {"code": "TEX-D-1D53D", "w": 700, "h": 750, "d": 0},
  "\\mathbb{G}": {"code": "TEX-D-1D53E", "w": 750, "h": 750, "d": 0},
  "\\mathbb{H}": {"code": "TEX-D-210D", "w": 750, "h": 750, "d": 0},
  "\\mathbb{I}": {"code": "TEX-D-1D540", "w": 400, "h": 750, "d": 0},
  "\\mathbb{J}": {"code": "TEX-D-1D541", "w": 450, "h": 750, "d": 0},
  "\\mathbb{K}": {"code": "TEX-D-1D542", "w": 750, "h": 750, "d": 0},
  "\\mathbb{L}": {"code": "TEX-D-1D543", "w": 750, "h": 750, "d": 0},
  "\\mathbb{M}": {"code": "TEX-D-1D544", "w": 1000, "h": 750, "d": 0},
  "\\mathbb{N}": {"code": "TEX-D-2115", "w": 750, "h": 750, "d": 0},
  "\\mathbb{O}": {"code": "TEX-D-1D546", "w": 750, "h": 750, "d": 0},
  "\\mathbb{P}": {"code": "TEX-D-2119", "w": 700, "h": 750, "d": 0},
  "\\mathbb{Q}": {"code": "TEX-D-211A", "w": 800, "h": 750, "d": 0},
  "\\mathbb{R}": {"code": "TEX-D-211D", "w": 750, "h": 750, "d": 0},
  "\\mathbb{S}": {"code": "TEX-D-1D54A", "w": 600, "h": 750, "d": 0},
  "\\mathbb{T}": {"code": "TEX-D-1D54B", "w": 750, "h": 750, "d": 0},
  "\\mathbb{U}": {"code": "TEX-D-1D54C", "w": 750, "h": 750, "d": 0},
  "\\mathbb{V}": {"code": "TEX-D-1D54D", "w": 750, "h": 750, "d": 0},
  "\\mathbb{W}": {"code": "TEX-D-1D54E", "w": 1000, "h": 750, "d": 0},
  "\\mathbb{X}": {"code": "TEX-D-1D54F", "w": 750, "h": 750, "d": 0},
  "\\mathbb{Y}": {"code": "TEX-D-1D550", "w": 750, "h": 750, "d": 0},
  "\\mathbb{Z}": {"code": "TEX-D-2124", "w": 750, "h": 750, "d": 0},
  "\\mathcal{A}": {"code": "TEX-C-41", "w": 900, "h": 750, "d": 0},
  "\\mathcal{B}": {"code": "TEX-C-42", "w": 750, "h": 750, "d": 0},
  "\\mathcal{C}": {"code": "TEX-C-43", "w": 550, "h": 750, "d": 0},
  "\\mathcal{D}": {"code": "TEX-C-44", "w": 850, "h": 750, "d": 0},
  "\\mathcal{E}": {"code": "TEX-C-45", "w": 600, "h": 750, "d": 0},
  "\\mathcal{F}": {"code": "TEX-C-46", "w": 900, "h": 750, "d": 0},
  "\\mathcal{G}": {"code": "TEX-C-47", "w": 700, "h": 750, "d": 0},
  "\\mathcal{H}": {"code": "TEX-C-48", "w": 900, "h": 750, "d": 0},
  "\\mathcal{I}": {"code": "TEX-C-49", "w": 750, "h": 750, "d": 0},
  "\\mathcal{J}": {"code": "TEX-C-4A", "w": 900, "h": 750, "d": 0},
  "\\mathcal{K}": {"code": "TEX-C-4B", "w": 850, "h": 750, "d": 0},
  "\\mathcal{L}": {"code": "TEX-C-4C", "w": 800, "h": 750, "d": 0},
  "\\mathcal{M}": {"code": "TEX-C-4D", "w": 1200, "h": 750, "d": 0},
  "\\mathcal{N}": {"code": "TEX-C-4E", "w": 900, "h": 750, "d": 0},
  "\\mathcal{O}": {"code": "TEX-C-4F", "w": 850, "h": 750, "d": 0},
  "\\mathcal{P}": {"code": "TEX-C-50", "w": 800, "h": 750, "d": 0},
  "\\mathcal{Q}": {"code": "TEX-C-51", "w": 900, "h": 750, "d": 0},
  "\\mathcal{R}": {"code": "TEX-C-52", "w": 900, "h": 750, "d": 0},
  "\\mathcal{S}": {"code": "TEX-C-53", "w": 800, "h": 750, "d": 0},
  "\\mathcal{T}": {"code": "TEX-C-54", "w": 900, "h": 750, "d": 0},
  "\\mathcal{U}": {"code": "TEX-C-55", "w": 800, "h": 750, "d": 0},
  "\\mathcal{V}": {"code": "TEX-C-56", "w": 800, "h": 750, "d": 0},
  "\\mathcal{W}": {"code": "TEX-C-57", "w": 1100, "h": 750, "d": 0},
  "\\mathcal{X}": {"code": "TEX-C-58", "w": 900, "h": 750, "d": 0},
  "\\mathcal{Y}": {"code": "TEX-C-59", "w": 850, "h": 750, "d": 0},
  "\\mathcal{Z}": {"code": "TEX-C-5A", "w": 900, "h": 750, "d": 0},
};
