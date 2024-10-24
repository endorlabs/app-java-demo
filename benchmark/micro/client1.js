const lib1 = require('./lib1.js');
const filter = lib1.filter;
console.log(filter(x => x % 2 === 0)([1, 2, 3])); // calls from lib1.js line 1, and calls anon func here
lib1.obj.foo = 87;
