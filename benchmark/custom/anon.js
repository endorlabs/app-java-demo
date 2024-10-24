function f1() { }
f1();

function f2(f) {
    f();
}

function f3(f) {
    f();
}

function f4(f) {
    f();
}

function f5(f) {
    f();
}

function f6(f) {
    f();
}

f2(function () {
    console.log("f2");
})

f3(() => console.log("f3"))

function def1() {
    (function () {
        console.log("xyz")
    })
    f4(function () {
        console.log("f3");
    })
    f5(() => console.log("f4"))
}

f6(function notimportant() {
    console.log("f6");
});

(function () {
    console.log("abc")
});

var jkl = function () { console.log("jkl"); };

[1].forEach((item) => { console.log("foreach"); });

(function () {
    var thingNotCalled = function insideIife() {
        console.log("inside iife");
    }
    console.log("iife - at module scope");
}).call(this);

var thingNotCalled2 = function notInsideIife() {
    console.log("not inside iife");
}
