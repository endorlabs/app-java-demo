function C() { }

C.prototype = {
    foo: function () { }
}

var v = new C(); // calls C() on line 1
v.foo(); // calls foo on line 4
