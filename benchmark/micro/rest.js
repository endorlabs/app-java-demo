var arr = [
    () => { console.log("1") },
    () => { console.log("2") },
    () => { console.log("3") },
    () => { console.log("4") }
];
arr[Math.floor(Math.random())] = () => { console.log("5") };

var [a0, a1, ...arest] = arr;
a0(); // calls func on line 2 (or 7)
a1(); // calls func on line 3 (or 7)
var a2 = arest[0];
var a3 = arest[1];
var a4 = arest[2];
a2(); // calls func on line 4 (or 7)
a3(); // calls func on line 5 (or 7)
if (a4)
    a4();

var [c0, ...[c1, ...crest]] = arr;
c0(); // calls func on line 2 (or 7)
c1(); // calls func on line 3 (or 7)
var c2 = crest[0];
var c3 = crest[1];
var c4 = crest[2];
c2(); // calls func on line 4 (or 7)
c3(); // calls func on line 5 (or 7)
if (c4)
    c4();

function f1(b0, b1, ...rest) {
    b0();
    b1();
    rest[0]();
    rest[1]();
    if (rest[2])
        rest[2]();
}
f1(
    () => { console.log("11") }, // called in f1
    () => { console.log("12") }, // called in f1
    () => { console.log("13") }, // called in f1
    () => { console.log("14") } // called in f1
)

function f2(d0, ...[d1, ...drest]) {
    d0();
    d1();
    drest[0]();
    drest[1]();
    if (drest[2])
        drest[2]();
}
f2(
    () => { console.log("21") }, // called in f2
    () => { console.log("22") }, // called in f2
    () => { console.log("23") }, // called in f2
    () => { console.log("24") } // called in f2
)

var obj = {
    e1: () => { console.log("31") },
    e2: () => { console.log("32") },
    e3: () => { console.log("33") },
    e4: () => { console.log("34") }
};
obj["e" + (obj ? 1 : 2)] = () => { console.log("35") };

var { e1, e2: ee2, ...erest } = obj;
e1(); // calls obj.e1 on line 62
ee2(); // calls obj.e2 on line 63
erest.e3(); // calls obj.e3 on line 64

function f3({ e1: eee1, ...eerest }) {
    eee1();
    eerest.e4();
}
f3(obj); // calls f3 on line 74, then obj.e1 and obj.e4
