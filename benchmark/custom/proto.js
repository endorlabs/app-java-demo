function f1() { }
f1();

function f2() { console.log("f2"); }

function C() {
    f2();
}

C.prototype = {
    foo: function () { console.log("C.foo"); }
}

var v = new C();
v.foo();


function Foo() { }

Foo.prototype = {
    foo() {
        console.log("foo1");
    },
};

const a = new Foo();
const b = Object.create(Object.getPrototypeOf(a));
b.foo();

Object.setPrototypeOf(b, {
    foo2() {
        console.log("foo2");
    },
});

b.foo2();


class Bar {
    static bar() {
        console.log("bar");
    };
};


const c = { __proto__: Bar };
c.bar();

Object.defineProperty(c, "foo3", { value: function () { console.log("foo3"); } });
c.foo3();
