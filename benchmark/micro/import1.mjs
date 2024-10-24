// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export

import cube2, { cube, foo, graph, function1, function2 } from './export1.mjs';

graph.options = {
    color: 'blue',
    thickness: '3px'
};

graph.draw(); // calls graph.draw from export1 line 17
console.log(cube(3)); // calls cube from export1 line 6
console.log(foo);

console.log(cube2(3)); // calls cube2 from export1 line 24

console.log(function1(2)); // calls function1 from export2 line 3
console.log(function2(2)); // calls function2 from export2 line 7

console.log(import.meta);

// see also https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import

