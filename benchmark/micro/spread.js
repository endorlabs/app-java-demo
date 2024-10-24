function f(a1, a2, a3) {
    a1();
    a2();
    a3();
}
const xs = [
    () => { console.log("1") }, // called in f() call
    () => { console.log("2") } // called in f() call

];
f(...xs, () => { console.log("3") }) // calls line 7, line8, and this line

const q = { p1: () => { console.log("10") }, ...xs, p2: () => { console.log("11") } };
q.p1(); // calls func on line 13
q.p2(); // calls func on line 13
q[0](); // calls func on line 7
q[1](); // calls func on line 8

const w = [() => { console.log("20") }, ...xs, () => { console.log("21") }];
w[0](); // calls func on line 19
w[1](); // calls func on line 7
w[2](); // calls func on line 8
w[3](); // calls func on line 19

const q2 = { ...q }; // spread in object (properties of object)
q2.p1(); // calls func on line 13
q2.p2(); // calls func on line 13
q2[0](); // calls func on line 7
q2[1](); // calls func on line 8

const w2 = [...w.values()]; // spread in array (values from iterable)
w2[0](); // calls func on line 19
w2[1](); // calls func on line 7
w2[2](); // calls func on line 8
w2[3](); // calls func on line 19
