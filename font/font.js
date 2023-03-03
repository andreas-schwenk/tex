/// tex - a tiny TeX engine
/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>
/// License: GPL-3.0-or-later

let parse = require("svg-parser");
let fs = require("fs");

let src = "";
let lines = fs.readFileSync("../meta/glyphs.csv", "utf-8").split("\n");
for (let line of lines) {
  line = line.trim();
  if (line.startsWith("#") || line.length == 0) continue;
  let tokens = line.split(";");
  let tex = tokens[0].trim();
  src += tex + " ";
}

require("mathjax")
  .init({
    loader: { load: ["input/tex", "output/svg"] },
  })
  .then((MathJax) => {
    const svg = MathJax.startup.adaptor.outerHTML(
      MathJax.tex2svg(src, { display: true })
    );
    fs.writeFileSync("all.svg", svg);

    let output = {};

    let obj = parse.parse(svg);
    let defs = obj.children[0].children[0].children[0].children;
    for (let def of defs) {
      let id = def.properties["id"];
      let d = def.properties["d"];
      output[id] = d;
    }

    var outputStr = "/// tex - a tiny TeX engine\n";
    outputStr +=
      "/// (c) 2023 by Andreas Schwenk <mailto:contact@compiler-construction.com>\n";
    outputStr += "/// License: GPL-3.0-or-later\n\n";

    outputStr += "// this file was auto-generated by file 'gen/gen.js'\n\n";

    outputStr += "Map<String, String> svgData = {\n";
    let keys = Object.keys(output).sort();
    for (let key of keys) {
      outputStr += '  "' + key + '": "' + output[key] + '",\n';
    }
    outputStr += "};\n";
    fs.writeFileSync("../lib/src/svg.dart", outputStr);

    let bp = 1337;
  })
  .catch((err) => console.log(err.message));
