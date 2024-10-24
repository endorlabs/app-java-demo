function f1() { }
f1();

var x = {
    mem() { console.log("x.mem"); }
}
x.f = function () { console.log("f"); }
x["dyn"] = function () { console.log("dyn"); }

x.mem();
x.f();
x.dyn();

function Y() {
}

Y.prototype.one = function () {
    console.log("Y.one");
}

let y = new Y();
y.two = function () {
    console.log("y.two");
}

y["one"]();
y["two"]();
