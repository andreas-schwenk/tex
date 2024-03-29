/// tex - a tiny TeX engine
/// (c) 2023-2024 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

// this file can be used to show an SVG output on the command line + the used letter curves (paths)

let process = require("process");

if (process.argv.length != 3) {
  console.log('usage example: node char.js "x^2+y^2"');
  process.exit(0);
}
let texSrc = process.argv[2];

let parse = require("svg-parser");

require("mathjax")
  .init({
    loader: { load: ["input/tex", "output/svg"] },
  })
  .then((MathJax) => {
    const svg = MathJax.startup.adaptor.outerHTML(
      MathJax.tex2svg(texSrc, { display: true })
    );
    console.log("======== SVG DATA ========");
    console.log(svg);

    console.log("======== PATHS ========");
    let obj = parse.parse(svg);
    let defs = obj.children[0].children[0].children[0].children;
    for (let def of defs) {
      let pathId = def.properties["id"];
      console.log(pathId);
    }
  })
  .catch((err) => console.log(err.message));
