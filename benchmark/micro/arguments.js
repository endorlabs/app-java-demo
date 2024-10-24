// Move f1 to 2nd line to make it discernible from synthetic module function
function f1(x) {
    console.log("0");
    if (!x)
        return;
    arguments[0](); // calls anon func on line 12
    arguments[1](); // calls anon func on line 12
    arguments[0] = () => { console.log("3") };
    x(); // ???
    arguments.callee(); // ???
}
f1(() => { console.log("1") }, () => { console.log("2") }); // calls f1 on line 2

function f2() {
    const f = () => arguments[0]; // arrow functions don't have their own 'arguments'
    f()(); // calls anon func on line 18
}
f2(() => { console.log("4") }); // calls f2 on line 14
