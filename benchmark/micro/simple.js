
/** Simple dynamic read/write on object literals. */
var x1 = {};
var x2 = { f: function () { } }

const prop = "qwe";
const f = "f";

x1[prop] = x2;
var temp = x2[f];
temp(); // calls x2.f on line 4
x2[f]() // calls x2.f on line 4
x1.qwe.f(); // calls x2.f on line 4

/** Simple dynamic read/write on functions */

function Foo() { }
var x3 = () => { }
//
// Write/Read for Arrow and Normal function
x3[prop] = Foo;
Foo[prop] = x3;
Foo[prop]() // calls x3 on line 18
x3[prop](); // calls Foo() on line 17

const prop2 = "p2"

/** "new" constructs */
class A { }

let x4 = new Foo(); // calls Foo() on line 17
const x5 = new A(); // calls implicit A() on line 29
x4[prop2] = x3;
x4.p2(); // calls x3 on line 18
x5[prop2] = x4;
x5[prop2][prop2](); // calls x3 on line 18

/** Object literal and Class creation with dynamic properties */
var x6 = {
    p1: function () { },
    [prop2]: function () { },
    ["p" + "3"]: function () { }
}

class C {
    ["my" + "Function"]() { }
}

x6.p2(); // calls x6.p2 on line 41
x6.p3(); // calls x6.p3 on line 42
new C().myFunction(); // C() and C.myFunction on line 46


/** Getter/Setter declarations. */
class D {
    get ["ba" + "z"]() { }
    set ["q" + "w" + "e" + "Set"](x) { }
}
var x7 = new D; // calls implicit D()
// Function call to corresponding setter function
x7.baz; // calls getter on line 56
x7.qweSet = x6; // calls setter on line 57


/** Operations involving objects from classes or new-constructs */
class E { }
class F extends E {
    constructor() {
        super();
    }
}

var x8 = new Foo();// calls Foo() on lin3 17
var x9 = new F; // calls F() on line 68, then E() on line 69
x8[prop] = x9;
x9[prop] = x2[f]
x9.qwe() // calls x2.f on line 4

/** Calls to super within methods. */
class A1 {
    getProperty() {
        return "p";
    }
}
class B1 extends A1 {
    setProperty(val) {
        this[super.getProperty()] = val;
    }
}

const b = new B1(); // calls implicit B1() and A1()
const val = function foo() { }
b.setProperty(val)
b.p(); // calls function foo/val on line 92

/** Optionals - ensure non-crashing behaviour. */
const x = {}
x.nonExistent?.()
x.alsoNonExistent?.property;
x["p" + "1"] = function () { }
x.p1(); // calls function on line 100