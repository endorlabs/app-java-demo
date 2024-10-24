const lib = require('./lib2');
const arit = new lib.Arit(); // calls Arit() from lib2.js line 1

console.log(arit.sum(1, 2)); // calls Arit.sum from lib2.js line 2
