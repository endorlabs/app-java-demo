var x1 = {
    a: () => { console.log("1") },
    b: {
        c: () => { console.log("2") },
    },
    get bar() {
        return () => { console.log("3") };
    }
};
var { a: y1 = () => { console.log("1b") }, ["a"]: y2, a: y3, b: { c: y4 }, bar: y5, d: y6 = () => { console.log("1c") } } = x1;
y1(); // calls x.a on line 2
y2(); // calls x.a on line 2
y3(); // calls x.a on line 2
y4(); // calls x1.b.c on line 4
y5(); // calls x1.bar on line 7
y6(); // calls y6 function on line 10

let c = {
    set foo(q) {
        console.log("4");
        q();
    }
};
({ a: c.foo } = x1); // calls c.foo setter on line 19, then x1.a

var x2 = [
    () => { console.log("5") },
    [
        () => { console.log("6") }
    ]
];
var [z1, [z2]] = x2;
z1(); // calls func on line 27
z2(); // calls func on line 29

let d = {};
[d.baz] = x2;
d.baz(); // calls func on line 27

const [x, y] = new Set([() => { }, () => { }]);
x();
y();

// const {a,...others} = {a:1,b:2,c:3};
// const [a2,...others2] = [1,2,3];
