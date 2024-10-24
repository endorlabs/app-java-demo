class A {
    constructor(x) {
        x(); // calls argument
    }
    m() {
        console.log("A.m");
    }
    static s() {
        console.log("A.s");
    }
    static f = () => {
        console.log("A.f");
    }
}

class B extends A {
    constructor() {
        super(() => {
            console.log("c");
        });
        console.log(B.__proto__ === A);
        super.m(); // calls A.m on line 5
        console.log(super.m === B.prototype.__proto__.m);
    }
    m() {
        console.log("B.m");
        super.m(); // calls A.m on line 5
        console.log(super.m === B.prototype.__proto__.m);
    }
    static s() {
        console.log("B.s");
        super.s(); // calls A.s on line 8
        console.log(super.s === this.__proto__.s);
    }
    static g = super.f;
    static {
        super.f(); // calls A.f on line 11
        console.log(super.f === this.__proto__.f);
    }
}

var x = new B(); // calls B() on line 17, then A() on line 2, then func on line 18, then A.m on line 5
x.m(); // calls B.m on line 25, then A.m on line 5
B.s(); // calls B.s on line 30, then A.s on line 8
B.g(); // calls B.g or A.11 on line 11

var q1 = {
    m1() {
        console.log("q1.m1");
    }
}
var q2 = {
    m2() {
        console.log("q2.m2");
        super.m1();
        console.log(super.m1 === this.__proto__.m1);
    }
}
Object.setPrototypeOf(q2, q1);
q2.m2(); // calls q2.m2 on line 53, then q1.m1 on line 48
var q3 = {
    m3() {
        console.log("q3.m3");
        super.m1();
        console.log(super.m1 === this.__proto__.m1);
    }
}
q3.__proto__ = q1;
q3.m3(); // calls q3.m3 on line 62, then q1.m1 on line 48
