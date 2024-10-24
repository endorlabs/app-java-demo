var x = { a: function () { console.log("1"); } };
var f = function () { return this.a; }.bind(x);
f()(); // calls f on line 2, calls x.a on line 1

function foo(b) { return this(b); }
(foo.call((a) => a, () => { console.log("2"); }))(); // calls foo on line 5 and console.log

function bar(c) { return this(c); }
function baz() {
    return bar.apply((d) => d, arguments); // calls bar on line 8
}
var q = baz(() => { console.log("3"); }); // calls baz on line 9
q(); // calls q on line 12 and console.log
function baz2(...args) {
    return bar.apply((d) => d, args); // calls bar on line 8
}
var q2 = baz2(() => { console.log("4"); }); // calls baz2 on line 14
q2(); // calls q2 on line 17 and console.log
function baz3(a) {
    return bar.apply((d) => d, [a]); // calls bar on line 8
}
var q3 = baz3(() => { console.log("5"); }); // calls baz3 on line 19
q3(); // calls q3 on line 22 and console.log
(baz3(() => { console.log("5"); })()); // calls baz3 on line 19 and console.log
function baz4(f) {
    const a = [];
    a.push(f);
    return bar.apply((d) => d, a); // calls bar on line 8
}
var q4 = baz4(() => { console.log("6"); }); // calls baz4 on line 25
q4(); // calls q4 on line 30 and console.log
