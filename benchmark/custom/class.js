function f1() { }
f1();

function f2() {
    console.log("f2");
}

class C1 {
    constructor() {
        console.log("C1.C()")
    }
    mem() {
        console.log("C1.mem");
    }
    memarw = () => { console.log("C1.memarw"); }
    static staticMethod() {
        console.log("C1.staticMethod");
    }
    get g() {
        console.log("C1.get_g");
        return "g";
    }
    set s(val) {
        console.log("C1.set_s");
    }
    static {
        console.log("C1.clinit");
        f2();
    }
}

class Base {
    constructor() { console.log("Base.Base()"); }
    mem() { console.log("Base.mem"); }
}

class C2 extends Base {
    constructor() {
        super();
        console.log("C2.C2()");
    }
    othermem() {
        super.mem();
        console.log("C2.othermem");
    }
}

var c1 = new C1();
c1.mem();
c1.memarw();
console.log(c1.g);
c1.s = "s";
C1.staticMethod();

let c2 = new C2();
c2.othermem();

