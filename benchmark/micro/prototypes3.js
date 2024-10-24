
function Foo() { }

Foo.prototype = {
    foo() {
        console.log("foo1");
    },
};

const a = new Foo(); // calls Foo on line 2
const b = Object.create(Object.getPrototypeOf(a));
b.foo(); // calls foo on line 5

Object.setPrototypeOf(b, {
    foo() {
        console.log("foo2");
    },
});

b.foo(); // calls foo on line 15


class Bar {
    static bar() {
        console.log("bar");
    };
};


const c = { __proto__: Bar };
c.bar(); // calls bar on line 24
