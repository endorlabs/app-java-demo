function f1() { }
f1();

function f2() { console.log("f2"); }
function f3() { console.log("f3"); }
function f4() { console.log("f4"); }

var a = [f2];
a.push(f3);
a[0]();
a[1]();

var b = new Array(f4);
b[0]();

a.forEach((item) => { console.log("foreach"); });
