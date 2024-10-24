function f1() { }
f1(); // calls f1 on line 1

const f2 = function () { return f1; };
f2(); // calls f2 on line 4

let f3 = () => { };
f3(); // calls f3 on line 7

function f4(x) {
    return x(f1); // calls argument
}

f4(f4); // calls f4 on line 10 (twice)

var t1 = {};
t1.f5 = () => { };
t1.f6 = t1.f5;
t1.f6(); // calls t1.f5 on line 17

class C1 {
    constructor() {
        f1(); // calls f1 on line 1
    }
    f7(y) {
        return y(); // calls argument
    }
    f8 = () => { return f1; }
}

let t2 = new C1; // calls C1.constructor on line 22, then f1 on line 1

t2.f7(f2); // calls C1.f7 on line 25, then calls f2 on line 4
let t222 = t2.f8(); // calls C1.f8 on line 28

class C2 {
    f8() { }
}
let t3 = new C2;
t3.f8(); // calls C2.f8 on line 37

let C3 = class {
    constructor() {

    }
    f9() { }
};
let t4 = new C3; // calls C3.constructor on line 43
t4.f9(); // calls C3.f9 on line 46

class C4 {
    constructor(x) {
        x(); // calls argument
    }
}

class C5 extends C4 {
    constructor(y) {
        super(y); // calls C4.constructor on line 52, then calls argument y
    }
}

const t5 = new C5(f1); // calls C5.constructor on line 58, then C4.constructor, then f1

var F1 = function () { }
let t6 = new F1;

class C6 {
    static staticProperty = (f1(), function () { }); // ???
    static staticMethod() {
        return f1(); // calls f1 on line 1
    }
    static {
        f1(); // calls f1 on line 1
    }
    static {
        f1(); // calls f1 on line 1
    }
}

C6.staticProperty(); // ???
C6.staticMethod(); // calls C6.staticMethod, then f1

class C {
    toString() { return "foo" };
}

let t7 = new C() + "bar"; // implicit call toString

const obj = {
    get property1() { },
    set property2(value) { },
    property3(parameters) { },
    *generator4(parameters) { },
    async property5(parameters) { },
    async* generator6(parameters) { },

    get ["property7"]() { },
    set ["property8"](value) { },
    ["property9"](parameters) { },
    *["generator10"](parameters) { },
    async ["property11"](parameters) { },
    async*["generator12"](parameters) { },
};

function F10(x) {
    this.f11 = x;
}

let t8 = new F10(f1);
t8.f11(); // calls f1 on line 1

let x12 = {
    f13() { },
    f14: () => { }
}
x12.f13(); // calls x12.f13
x12.f13(); // calls x12.f13

let C10 = class {
    f9() { }
};
let t40 = new C10;
t40.f9(); // calls C10.f9 online 121

class C11 {
    f16() { }
}
class C12 extends C11 {
}
let t41 = new C12;
t41.f16(); // calls C11.f16



function A(x) {
    this.f44 = x;
}

A.prototype.s1 = function () {
    return f2();
}
A.prototype.s2 = function () {
    return f2();
}

class D extends A {
    constructor(y) {
        super(y); // calls A() on line 136
    }
    s1() {
        return f2(); // calls f2 on line 4
    }
}

let d = new D(f2); // calls D.constructor, then A()
let t42 = d.s1(); // calls D.s1, then f2
let t43 = d.s2(); // calls D.s2 (A.prototype.s2), then f2
let t45 = d.f44(); // calls f2
