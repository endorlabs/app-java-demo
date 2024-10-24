
const o1 = Object.assign({}, {
    foo() { console.log("foo1"); },
}, {
    bar: undefined,
});

o1.foo(); // calls foo on line 3
o1.bar?.();

const o2 = Object.assign({}, {
    foo() { console.log("foo2"); },
}, {
    bar() { console.log("bar"); },
});

o2.foo(); // calls foo on line 12
o2.bar(); // calls bar on line 14
