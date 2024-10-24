const a1 = [() => { console.log("1") }, () => { console.log("2") }];

var s1 = new Set(a1);
for (const f of s1)
    f(); // calls funcs on line 1

var m2 = new Map([[() => { console.log("3") }, () => { console.log("4") }], [() => { console.log("5") }, () => { console.log("6") }]]);
for (const [k, v] of m2) {
    k(); // calls funcs on line 7
    v(); // calls funcs on line 7
}

var a3 = Array.from(a1)
for (const f of a3) // array-like
    f(); // calls funcs on line 1

var a4 = Array.from(s1)
for (const f of a4) // iterable
    f(); // calls funcs on line 1

const x = {
    f: () => { console.log("8") }
};

x.f(); // calls x.f on line 22

var a5 = Array.from(a1, function (element) {
    element(); // calls func in array
    this.f(); // ???
    return () => { console.log("7") };
}, x);
for (const f of a5)
    f(); // calls func on line 30

var a6 = [[() => { console.log("8") }]];
var a7 = [() => { console.log("9") }, [() => { console.log("10") }]];
var a8 = a6.concat(a7, () => { console.log("11") });
a8[0][0](); // calls func on line 35
a8[1](); // calls first func line 36
a8[2][0](); // calls other func on line 36
a8[3](); // calls func on line 37

var a10 = [() => { console.log("12") }, [() => { console.log("13") }], [[() => { console.log("14") }]]];
var a11 = a10.flat();
var a12 = a10.flat(2);
a11[0]();
a11[1]();
a11[2][0]();
a12[0]();
a12[1]();
a12[2]();

var a13 = [() => { console.log("15") }, () => { console.log("16") }];
var a14 = a13.flatMap(f => [f, f]);
a14[0]();
a14[1]();
a14[2]();
a14[3]();
