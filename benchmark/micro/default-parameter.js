
function f(x = function () { console.log("hello"); }) {
    x(); // calls arg x (func on line 2)
}

function g(x = f()) { } // calls f on line 2, then func on line 2
g(); // calls g on line 6
