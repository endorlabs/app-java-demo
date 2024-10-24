function f1() { }
f1();

// call function as argument
function callarg(x) {
    return x();
}
function f2() { console.log("f2"); }
callarg(f2);

// return function and call it
function ret() {
	return function() { console.log("retanon"); }
}
ret()();

function f7() { console.log("f7"); }
function ret2() {
	return f7;
}
ret2()();

// assign function to var and call it
var f3 = function() { console.log("f3"); }
let f3ref = f3;
f3ref();

// IIFE calls function declared outside
function f4() { console.log("f4"); }
(function() {
    f4();
})()

// arrow function expression
var arw = () => { console.log("arw"); }
arw();

function f5() { console.log("f5"); }
var f6 = function() {
    console.log("f6");
    f5();
}
f6();

