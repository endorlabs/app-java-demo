eval("console.log(42)"); // calls console.log

var x = new Map();
x.set(1, function () { console.log("1") });
var y = x.get(1);
y(); // calls func on line 4

var z = new Function("console.log(87)");
z(); // calls Function on line 8, then console.log

var a = new Array();
a.push(function () { console.log("2") });
var b = a.pop();
b() // calls func on line 12

var c = Array.from([() => { console.log(3) }]);
c[0](); // calls func on line 16

