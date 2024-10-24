// expect first
function first() { console.log("first"); }
first();

// expect second
function second() { console.log("second"); }
second();

// expect x.a
var x = { a: function () { console.log("x.a"); } };
x.a();

// expect f
var f = function () { console.log("f"); }
f();

// expect ???
var foo_inner;
function foo(b) {
    console.log("foo");
    var inner = function () { console.log("inner 1"); }
    {
        inner();
        var inner = function () { console.log("inner 2"); }
        {
            let inner = function () { console.log("inner 3"); }
            inner();
            foo_inner = inner;
            inner = function () { console.log("inner 4"); }
            inner();
        }
        var inner = function () { console.log("inner 5"); }
        inner();
    }
    var inner = function () { console.log("inner 6"); }
    inner();
}
foo();
var foo_obj = {};
foo_obj.ff = foo_inner;
foo_obj.ff();

// calling deeply nested function
function topf() {
    var next = () => {
        return function () {
            var after = () => { console.log("after"); }
            after();
        }
    }
    next()()
}
topf();

// expect anonymous function here
var arw = () => { console.log("arw"); }
arw();

class C1 {
    // expect C1.C1 or C1.constructor
    constructor() {
        console.log("C1.C()")
    }
    // expect C1.f7
    f7(y) {
        console.log("C1.f7");
    }
    // expect C1.anonymous_function_69_10
    f8 = () => { console.log("C1.f8"); }
    // expect C1.staticMethod
    static staticMethod() {
        console.log("C1.staticMethod");
    }
    // expect C1.~get_g (start with 'invalid' char to mark as synthetic name)
    get g() {
        console.log("g");
        return "g";
    }
    // expect C1.~set_s
    set s(val) {
        console.log("s");
        this._ess = val;
    }
    // expect C1.~get_s
    get s() {
        return this._ess;
    }
}
var c = new C1();
c.f7();
c.f8();
C1.staticMethod();
var g = c.g;
c.s = "s";

// expect F
function F() {
    // expect F.mem
    this.mem = function () { console.log("F.mem"); };
}
// expect F.pmem
F.prototype.pmem = function () { console.log("F.pmem"); }
var eff = new F();
eff.mem();
eff.pmem();


let obj = {
    // expect obj.o
    o: function () { console.log("obj.o"); }
}
obj.o();

var CL = class {
    // expect CL.m
    m() { console.log("CL.m"); }
}
var thecl = new CL();
thecl.m();

// // expect d
var d = new Function("console.log('Function');")
d();

// expect arr.0 and arr.1 (or function_$line_$column)
arr = [function () { console.log("arr.0"); }, function () { console.log("arr.1"); }]
arr[0]();
arr[1]();

// expect function_$line_$column (for both functions here)
(function (f) { f() })(() => { console.log("f_arrow"); })

// above is funcexpr within parens, then invoked
// below is funcexpr invoked, then in parens
function in_iife() {
    return "iife";
}
(function () { console.log(in_iife()); }())

    // now a funcexpr invoked with call
    (function () { }.call(this))
