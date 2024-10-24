package benchmark

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/endorlabs/monorepo/src/golang/internal.endor.ai/pkg/callgraphs"
	"github.com/endorlabs/monorepo/src/golang/internal.endor.ai/pkg/datastructures"
	"github.com/endorlabs/monorepo/src/golang/internal.endor.ai/pkg/functionrefs"
	endorctllogger "github.com/endorlabs/monorepo/src/golang/internal.endor.ai/service/endorctl/logger"
	"github.com/endorlabs/monorepo/src/golang/internal.endor.ai/service/endorctl/plugin/jsplugin/client"
	pluginclient "github.com/endorlabs/monorepo/src/golang/internal.endor.ai/service/endorctl/plugin/pluginclient"
	endorpb "github.com/endorlabs/monorepo/src/golang/spec/internal.endor.ai/endor/v1"
	"github.com/stretchr/testify/assert"
	timestamppb "google.golang.org/protobuf/types/known/timestamppb"
)

// log test cases that we don't expect to succeed on (yet).
func logNotFound(t *testing.T, err error) {
	t.Logf("(not a test failure) %s : %s", t.Name(), err.Error())
}

func TestJSCallgraph_Refs(t *testing.T) {

	t.Run("test funcrefs", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck
		cfg, r, err := setupTest(tempDir, "refs.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/second()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/f()"); err != nil {
			t.Error(err)
		}

		// find function call on object literal property
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/x/a()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/obj/o()"); err != nil {
			t.Error(err)
		}

		// call to inner function that is ambiguous. we accept it as ambiguous.
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/foo().inner()"); err != nil {
			t.Error(err)
		}

		// calling deeply nested function
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/refs]/topf().next().anonymous_function_46_16().after()"); err != nil {
			t.Error(err)
		}

		// find arrow assignment and function call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/refs]/arw()"); err != nil {
			t.Error(err)
		}

		// class constructor and methods
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/C1/C1()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/C1/f7()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/refs]/C1/f8()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/C1/staticMethod()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/C1/g()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/C1/s()"); err != nil {
			t.Error(err)
		}

		// find implicit F() constructor call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/F()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/F().mem()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/F.prototype/pmem()"); err != nil {
			t.Error(err)
		}

		// find call to class literal method
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/CL/m()"); err != nil {
			t.Error(err)
		}

		// find call to Function()
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/d()"); err != nil {
			t.Error(err)
		}

		// TODO skip array calls for now

		// find iife and the arrow call within
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/anonymous_function_131_2()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/anonymous_function_131_24()"); err != nil {
			t.Error(err)
		}
		// and the other one
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/anonymous_function_138_2()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/refs]/call()"); err != nil {
			t.Error(err)
		}
	})
}

func TestJSCallgraph_Functions(t *testing.T) {

	t.Run("test functions", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "funcs.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		// find function called as argument
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/funcs]/f2()"); err != nil {
			logNotFound(t, err)
		}

		// find anonymous function returned from function
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/funcs]/ret().anonymous_function_13_12()"); err != nil {
			logNotFound(t, err)
		}

		// find other function returned from function
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/funcs]/f7()"); err != nil {
			logNotFound(t, err)
		}

		// find function assigned to variable
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/funcs]/f3()"); err != nil {
			t.Error(err)
		}

		// find function call within iife
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/funcs]/f4()"); err != nil {
			t.Error(err)
		}

		// and find iife call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/funcs]/anonymous_function_30_2()"); err != nil {
			t.Error(err)
		}

		// find arrow function expression
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/funcs]/arw()"); err != nil {
			t.Error(err)
		}

		// find others
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/funcs]/f5()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/funcs]/f6()"); err != nil {
			t.Error(err)
		}
	})
}

func TestJSCallgraph_CallApply(t *testing.T) {

	t.Run("test function call apply", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "call.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		// find function called via call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/call]/f2()"); err != nil {
			t.Error(err)
		}

		// find function called via apply
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/call]/f3()"); err != nil {
			t.Error(err)
		}

		// find function called via bind
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/call]/f4()"); err != nil {
			t.Error(err)
		}

		// find function called via Function
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/call]/f6()"); err != nil {
			t.Error(err)
		}

		// find function called within Function
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/call]/f5()"); err != nil {
			logNotFound(t, err)
		}
	})
}

func TestJSCallgraph_Class(t *testing.T) {

	t.Run("test classes", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "class.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		// find C1 constructor call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/C1/C1()"); err != nil {
			t.Error(err)
		}

		// find C1.mem call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/C1/mem()"); err != nil {
			t.Error(err)
		}

		// find C1.memarw call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/class]/C1/memarw()"); err != nil {
			t.Error(err)
		}

		// find C1.g getter call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/C1/g()"); err != nil {
			t.Error(err)
		}

		// find C1.s setter call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/C1/s()"); err != nil {
			t.Error(err)
		}

		// find C1.staticMethod call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/C1/staticMethod()"); err != nil {
			t.Error(err)
		}

		// find f2 call from C1's static init block
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/f2()"); err != nil {
			t.Error(err)
		}

		// find C2 constructor call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/C2/C2()"); err != nil {
			t.Error(err)
		}

		// find Base constructor call via super
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/Base/Base()"); err != nil {
			t.Error(err)
		}

		// find C2.othermem call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/C2/othermem()"); err != nil {
			t.Error(err)
		}

		// find Base.mem call via super
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/class]/Base/mem()"); err != nil {
			t.Error(err)
		}
	})
}

func TestJSCallgraph_Object(t *testing.T) {

	t.Run("test object literals", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "obj.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		// find x.mem call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/obj]/x/mem()"); err != nil {
			t.Error(err)
		}

		// find x.f call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/obj]/x/f()"); err != nil {
			t.Error(err)
		}

		// find x.dyn call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/obj]/x/dyn()"); err != nil {
			t.Error(err)
		}

		// find y["one"] call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/obj]/Y.prototype/one()"); err != nil {
			t.Error(err)
		}

		// find y["two"] call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/obj]/y/two()"); err != nil {
			t.Error(err)
		}
	})
}

func TestJSCallgraph_Prototype(t *testing.T) {

	t.Run("test prototype", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "proto.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		// find C() call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/proto]/C()"); err != nil {
			t.Error(err)
		}

		// and f2 call within C()
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/proto]/f2()"); err != nil {
			t.Error(err)
		}

		// find C.foo call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/proto]/C/foo()"); err != nil {
			t.Error(err)
		}

		// find Foo() call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/proto]/Foo()"); err != nil {
			t.Error(err)
		}

		// find b.foo call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/proto]/b/foo()"); err != nil {
			logNotFound(t, err)
		}

		// find b.foo2 call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/proto]/b/foo2()"); err != nil {
			logNotFound(t, err)
		}

		// find c.bar call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/proto]/c/bar()"); err != nil {
			logNotFound(t, err)
		}

		// find c.foo3 call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/proto]/c/foo3()"); err != nil {
			logNotFound(t, err)
		}
	})
}

func TestJSCallgraph_Array(t *testing.T) {

	t.Run("test arrays", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "array.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		// find calls to functions in array
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/array]/f2()"); err != nil {
			logNotFound(t, err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/array]/f3()"); err != nil {
			logNotFound(t, err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/array]/f4()"); err != nil {
			logNotFound(t, err)
		}

		// find function called via forEach
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/array]/anonymous_function_16_11()"); err != nil {
			t.Error(err)
		}
	})
}

func TestJSCallgraph_Anon(t *testing.T) {

	t.Run("test anon edges", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "anon.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/anon]/anonymous_function_24_4()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/anon]/anonymous_function_28_4()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/anon]/def1().anonymous_function_34_8()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/anon]/def1().anonymous_function_37_8()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/anon]/anonymous_function_50_13()"); err != nil {
			t.Error(err)
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/anon]/notimportant()"); err != nil {
			t.Error(err)
		}

		// verify these are not reachable
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/anon]/anonymous_function_52_2().insideIife()"); err == nil {
			t.Error("unexpected: 'insideIife' called")
		}
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[jscgtest:1.0.0:benchmark_test/anon]/notInsideIife()"); err == nil {
			t.Error("unexpected: 'notInsideIife' called")
		}
	})
}

func TestJSCallgraph_CommonJS(t *testing.T) {

	t.Run("test common js require", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "cjs/app.js", "cjs/level1.js", "cjs/level2.js", "cjs/level3a.js", "cjs/level3b.js", "cjs/level3c.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		expected := map[string][]string{
			"javascript://jscgtest$1.0.0/[benchmark_test/level1]/l1()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/l1()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level2]/exp2()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/exp2()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3a]/()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3a]/()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3b]/()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3b]/()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3a]/exp3a()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3a]/exp3a()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3b]/anonymous_function_2_18()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3b]/anonymous_function_2_18()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3c]/()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3c]/()",
			},
			// TODO handle import that is immediately invoked
			/*"javascript://jscgtest$1.0.0/[level3c]/exp3c()": {
				"javascript://jscgtest$1.0.0/[app]/()",
				"javascript://jscgtest$1.0.0/[level1]/()",
				"javascript://jscgtest$1.0.0/[level2]/()",
				"javascript://jscgtest$1.0.0/[level3c]/exp3c()",
			},*/
		}

		for f, p := range expected {
			path, err := findFunctionCallFromTo(global, p[0], f)
			if err != nil {
				t.Errorf("unable to find path to %v : %v\n", f, err)
				continue
			}
			if len(path) != len(p) {
				t.Errorf("incorrect path to %v : got %v, want %v\n", f, path, p)
				continue
			}
			for i, funcRef := range path {
				if funcRef.String() != p[i] {
					t.Errorf("incorrect path to %v : got %v, want %v\n", f, path, p)
					break
				}
			}
		}
	})
}

func TestJSCallgraph_ESModule(t *testing.T) {

	t.Run("test esm import", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "ejs/app.mjs", "ejs/level1.mjs", "ejs/level2.mjs", "ejs/level3a.mjs", "ejs/level3b.mjs")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		expected := map[string][]string{
			"javascript://jscgtest$1.0.0/[benchmark_test/level1]/l1()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/l1()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level2]/exp2()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/exp2()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3a]/()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3a]/()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3b]/()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3b]/()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3a]/exp3a()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3a]/exp3a()",
			},
			"javascript://jscgtest$1.0.0/[benchmark_test/level3b]/anonymous_function_1_16()": {
				"javascript://jscgtest$1.0.0/[benchmark_test/app]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level1]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level2]/()",
				"javascript://jscgtest$1.0.0/[benchmark_test/level3b]/anonymous_function_1_16()",
			},
		}

		for f, p := range expected {
			path, err := findFunctionCallFromTo(global, p[0], f)
			if err != nil {
				t.Errorf("unable to find path to %v : %v\n", f, err)
				continue
			}
			if len(path) != len(p) {
				t.Errorf("incorrect path to %v : got %v, want %v\n", f, path, p)
				continue
			}
			for i, funcRef := range path {
				if funcRef.String() != p[i] {
					t.Errorf("incorrect path to %v : got %v, want %v\n", f, path, p)
					break
				}
			}
		}
	})
}

func TestJSCallgraph_Alternatives(t *testing.T) {

	t.Run("test alternative assignments", func(t *testing.T) {

		t.Setenv("ENDOR_JS_ENABLE_TSSERVER", "true")
		t.Setenv("ENDOR_JS_ENABLE_FUNCTION_GRAPHS", "true")
		c := client.NewClient(endorctllogger.NewNop(), os.Getenv("ENDOR_SCAN_JAVASCRIPT_PATH"))

		tempDir, err := os.MkdirTemp("", "bench")
		assert.NoError(t, err)
		defer os.RemoveAll(tempDir) //nolint errcheck

		cfg, r, err := setupTest(tempDir, "alternatives.js")
		assert.NoError(t, err)

		cg, err := c.GetCallGraph(context.Background(), cfg, r)
		assert.NoError(t, err)
		assert.NotNil(t, cg)
		assert.Len(t, cg, 1)

		global, err := callgraphs.NewGlobalCallGraphFromFunctionGraph(cg[0].GetSpec().GetFunctionGraph())
		assert.NoError(t, err)

		// find consequence call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/alternatives]/consequence()"); err != nil {
			t.Error(err)
		}

		// find alternative call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/alternatives]/alternative()"); err != nil {
			t.Error(err)
		}

		// find either call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/alternatives]/either()"); err != nil {
			t.Error(err)
		}

		// find or call
		if err := verifyFunctionCall(global, "javascript://jscgtest$1.0.0/[benchmark_test/alternatives]/or()"); err != nil {
			t.Error(err)
		}
	})
}

func setupTest(dir string, jsFiles ...string) (*pluginclient.ConfigurationMessage, *pluginclient.ResolvedDependencies, error) {
	if len(jsFiles) == 0 {
		return nil, nil, errors.New("setupTest needs at least one file")
	}

	dir = filepath.Join(dir, "benchmark_test")
	err := os.Mkdir(dir, 0750)
	if err != nil {
		return nil, nil, err
	}

	cfg := &pluginclient.ConfigurationMessage{
		Version: "1.0.0",
		Option: &pluginclient.ConfigurationMessageWorkspace{
			Workspace: &pluginclient.WorkspaceConfiguration{
				WorkspacePath: dir,
				BuildLocally:  true,
			},
		},
	}

	r := &pluginclient.ResolvedDependencies{
		PackageName:  "npm://jscgtest$1.0.0",
		RelativePath: "",
		Result: &pluginclient.ResolvedDependenciesSpecs{
			Spec: &pluginclient.ResolvedDependenciesSpec{
				Dependencies: &endorpb.Bom{ResolutionTimestamp: timestamppb.Now()},
			},
		},
	}

	cwd, err := os.Getwd()
	if err != nil {
		return cfg, r, err
	}
	for _, jsFile := range jsFiles {
		srcPath := filepath.Join(cwd, "custom", jsFile)
		srcBytes, err := os.ReadFile(srcPath) //nolint: gosec
		if err != nil {
			return cfg, r, err
		}
		dstPath := filepath.Join(dir, filepath.Base(jsFile))
		err = os.WriteFile(dstPath, srcBytes, 0600)
		if err != nil {
			return cfg, r, err
		}
	}

	pkgjsonPath := filepath.Join(dir, "package.json")
	err = os.WriteFile(pkgjsonPath, []byte(fmt.Sprintf(`{"name" : "jscgtest", "version" : "1.0.0", "main" : "%s"}`, jsFiles[0])), 0600)
	return cfg, r, err
}

func verifyFunctionCall(global *callgraphs.GlobalCallGraph, uri string) error {
	funcRef, err := functionrefs.CreateJavascriptFunctionRef(uri)
	if err != nil {
		return err
	}
	pathFound, _ := findFunctionCall(global, funcRef)
	if len(pathFound) == 0 {
		return fmt.Errorf("unable to find path to %v\n", funcRef)
	}
	return nil
}

func findFunctionCall(global *callgraphs.GlobalCallGraph, f functionrefs.FunctionRef) ([]functionrefs.FunctionRef, bool) {

	node := global.GetNodeID(f)
	if node == -1 {
		return nil, false
	}

	entryPoints := global.GetAllEntryPoints()
	pathFound := global.PathFromTo(entryPoints.AsList(), node)
	if len(pathFound) == 0 {
		return nil, true
	}

	pathFoundRefs, _ := global.PathToFunctionRefs(pathFound) //nolint: errcheck
	return pathFoundRefs, true
}

func findFunctionCallFromTo(global *callgraphs.GlobalCallGraph, from, to string) ([]functionrefs.FunctionRef, error) {

	fromFR, err := functionrefs.CreateJavascriptFunctionRef(from)
	if err != nil {
		return nil, err
	}
	fromNode := global.GetNodeID(fromFR)
	if fromNode == -1 {
		return nil, fmt.Errorf("unable to find %v", fromFR)
	}

	toFR, err := functionrefs.CreateJavascriptFunctionRef(to)
	if err != nil {
		return nil, err
	}
	toNode := global.GetNodeID(toFR)
	if toNode == -1 {
		return nil, fmt.Errorf("unable to find %v", toFR)
	}

	pathFound := global.PathFromTo([]datastructures.Node{fromNode}, toNode)
	if len(pathFound) == 0 {
		return nil, fmt.Errorf("path not found from %v to %v", fromFR, toFR)
	}

	return global.PathToFunctionRefs(pathFound)
}
