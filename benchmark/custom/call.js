function f1() { }
f1();

function f2() { console.log("f2"); }
function f3() { console.log("f3"); }
function f4() { console.log("f4"); }

f2.call();
f3.apply();
f4.bind()();

function f5() { console.log("f5"); }
var f6 = new Function('f', "console.log('Function'); f();")
f6(f5);

