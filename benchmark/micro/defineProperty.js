function f1() { }

function defProp() {
    const obj = { baz: undefined };
    Object.defineProperty(obj, "f", { value: f1 });
    Object.defineProperty(obj, "foo", {
        get() {
            return this.baz;
        },
    });
    Object.defineProperty(obj, "bar", {
        set(x) {
            this.baz = x;
        },
    });

    obj.f(); // calls f1 on line 1

    obj.bar = f1; // calls setter on line 12

    const t1 = obj.foo; // calls getter on line 7
    t1(); // calls f1 on line 1
}

function defProps() {
    const obj = { baz: undefined };
    Object.defineProperties(obj, {
        f: { value: f1 },
        foo: {
            get() {
                return this.baz;
            },
        },
        bar: {
            set(x) {
                this.baz = x;
            },
        }
    });

    obj.f(); // calls f1 on line 1

    obj.bar = f1; // calls setter on line 35

    const t1 = obj.foo; // calls getter on line 30
    t1(); // calls f1 on line 1
}

function create() {
    const obj = Object.create(null, {
        f: { value: f1 },
        foo: {
            get() {
                return this.baz;
            },
        },
        bar: {
            set(x) {
                this.baz = x;
            },
        }
    });

    obj.f(); // calls f1 on line 1

    obj.bar = f1; // calls setter on line 58

    const t1 = obj.foo; // calls getter on line 53
    t1(); // calls f1 on line 1
}

defProp(); // calls defProp on line 3
defProps(); // calls defProps on line 25
create(); // calls create on line 49
