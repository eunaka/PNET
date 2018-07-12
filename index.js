
var fs = require('fs');
var jison = require('jison');

var bnf = fs.readFileSync("petri.jison", "utf8");
var script = fs.readFileSync("script.pnet", "utf8");

var compiler = new jison.Parser(bnf);

try {
  var result = compiler.parse(script);
  console.log("\nSyntactic Tree:\n");
  console.log(JSON.stringify(result, null, 2));
  // console.log("\nMap:\n");
  // console.log(JSON.stringify(result.check(), null, 2));
  result.compile();
  console.log("\n\njson\n");
  print(result.exe());
} catch(e) {
  console.log(e);
}

function print(json) {
  var data = JSON.stringify(json,null,2);
  fs.writeFile(`petri-net.json`, data, 'utf-8', function(err) {
    if (err) console.log(err);
    else console.log("done.");
  });
}