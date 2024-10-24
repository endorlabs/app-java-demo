
var l3a = require('./level3a.js').f;
var l3b = require('./level3b.js')
var s_from_3c = require('./level3c.js')('s')

module.exports = exp2;

function exp2() {
    return "export from level 2";
}

console.log(l3a() + "\n" + l3b());
console.log(s_from_3c);
