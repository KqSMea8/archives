COMPONENT_DIR := $(PWD)/jerryscript
JERRYSCRIPT_DIR := $(PWD)/deps/jerryscript

COMPONENT_ADD_INCLUDEDIRS := \
    ../deps/jerryscript/jerry-ext/include \
    ../deps/jerryscript/jerry-port/default/include \
    ../deps/jerryscript/jerry-core \
    ../deps/jerryscript/jerry-core/include \
    ../deps/jerryscript/jerry-core/debugger \
    ../deps/jerryscript/jerry-core/vm \
    ../deps/jerryscript/jerry-core/ecma/base \
    ../deps/jerryscript/jerry-core/ecma/operations \
    ../deps/jerryscript/jerry-core/ecma/operations \
    ../deps/jerryscript/jerry-core/ecma/builtin-objects \
    ../deps/jerryscript/jerry-core/ecma/builtin-objects/typedarray \
    ../deps/jerryscript/jerry-core/parser/regexp \
    ../deps/jerryscript/jerry-core/parser/js \
    ../deps/jerryscript/jerry-core/jcontext \
    ../deps/jerryscript/jerry-core/jrt \
    ../deps/jerryscript/jerry-core/lit \
    ../deps/jerryscript/jerry-core/jmem

COMPONENT_OBJS := \
	$(COMPONENT_DIR)/port.o \
    $(JERRYSCRIPT_DIR)/jerry-ext/handler/handler-assert.o \
    $(JERRYSCRIPT_DIR)/jerry-ext/handler/handler-gc.o \
    $(JERRYSCRIPT_DIR)/jerry-ext/handler/handler-print.o \
    $(JERRYSCRIPT_DIR)/jerry-ext/handler/handler-register.o \
    $(JERRYSCRIPT_DIR)/jerry-ext/module/module.o \
    $(JERRYSCRIPT_DIR)/jerry-ext/arg/arg-transform-functions.o \
    $(JERRYSCRIPT_DIR)/jerry-ext/arg/arg-js-iterator-helper.o \
    $(JERRYSCRIPT_DIR)/jerry-ext/arg/arg.o \
    $(JERRYSCRIPT_DIR)/jerry-core/jcontext/jcontext.o \
    $(JERRYSCRIPT_DIR)/jerry-core/lit/lit-char-helpers.o \
    $(JERRYSCRIPT_DIR)/jerry-core/lit/lit-strings.o \
    $(JERRYSCRIPT_DIR)/jerry-core/lit/lit-magic-strings.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/regexp/re-compiler.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/regexp/re-bytecode.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/regexp/re-parser.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/byte-code.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/common.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/js-parser-statm.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/js-parser.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/js-parser-mem.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/js-lexer.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/js-parser-expr.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/js-parser-util.o \
    $(JERRYSCRIPT_DIR)/jerry-core/parser/js/js-parser-scanner.o \
    $(JERRYSCRIPT_DIR)/jerry-core/jrt/jrt-fatals.o \
    $(JERRYSCRIPT_DIR)/jerry-core/vm/opcodes-ecma-arithmetics.o \
    $(JERRYSCRIPT_DIR)/jerry-core/vm/vm.o \
    $(JERRYSCRIPT_DIR)/jerry-core/vm/opcodes-ecma-relational-equality.o \
    $(JERRYSCRIPT_DIR)/jerry-core/vm/opcodes-ecma-bitwise.o \
    $(JERRYSCRIPT_DIR)/jerry-core/vm/vm-stack.o \
    $(JERRYSCRIPT_DIR)/jerry-core/vm/opcodes.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-number.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-typeerror-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-syntaxerror.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-date.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-regexp.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-number-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-evalerror.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-rangeerror-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-string.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-helpers-date.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-urierror.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-typedarray.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-uint32array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-uint8clampedarray-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-float32array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-int32array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-int16array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-int16array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-float64array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-uint16array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-uint32array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-int32array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-uint16array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-uint8array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-float64array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-int8array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-uint8clampedarray.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-float32array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-typedarray-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-int8array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/typedarray/ecma-builtin-uint8array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-array.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-array-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-referenceerror.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-referenceerror-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-typeerror.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtins.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-regexp-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-helpers-error.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-arraybuffer-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-helpers-json.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-global.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-boolean.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-error-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-rangeerror.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-boolean-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-promise.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-syntaxerror-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-function-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-string-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-urierror-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-type-error-thrower.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-arraybuffer.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-json.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-date-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-evalerror-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-error.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-function.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-promise-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-math.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-helpers.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/builtin-objects/ecma-builtin-object-prototype.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-get-put-value.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-objects-general.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-regexp-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-promise-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-boolean-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-jobqueue.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-string-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-objects.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-array-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-function-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-typedarray-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-comparison.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-number-arithmetic.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-arraybuffer-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-conversion.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-eval.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-lex-env.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-number-object.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-exceptions.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-reference.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/operations/ecma-objects-arguments.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-helpers-number.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-property-hashmap.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-helpers-string.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-helpers.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-helpers-values-collection.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-alloc.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-helpers-value.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-lcache.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-helpers-errol.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-literal-storage.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-init-finalize.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-helpers-conversion.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-gc.o \
    $(JERRYSCRIPT_DIR)/jerry-core/ecma/base/ecma-helpers-external-pointers.o \
    $(JERRYSCRIPT_DIR)/jerry-core/jmem/jmem-poolman.o \
    $(JERRYSCRIPT_DIR)/jerry-core/jmem/jmem-allocator.o \
    $(JERRYSCRIPT_DIR)/jerry-core/jmem/jmem-heap.o \
    $(JERRYSCRIPT_DIR)/jerry-core/debugger/debugger-ws.o \
    $(JERRYSCRIPT_DIR)/jerry-core/debugger/debugger.o \
    $(JERRYSCRIPT_DIR)/jerry-core/debugger/debugger-sha1.o \
    $(JERRYSCRIPT_DIR)/jerry-core/api/jerry.o \
    $(JERRYSCRIPT_DIR)/jerry-core/api/jerry-snapshot.o \
    $(JERRYSCRIPT_DIR)/jerry-core/api/jerry-debugger.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/atan.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/log.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/finite.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/scalbn.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/exp.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/atan2.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/fabs.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/floor.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/pow.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/sqrt.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/nextafter.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/acos.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/asin.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/fmod.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/copysign.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/isnan.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/trig.o \
    $(JERRYSCRIPT_DIR)/jerry-libm/ceil.o

$(COMPONENT_OBJS): CC = xtensa-esp32-elf-gcc
$(COMPONENT_OBJS): CFLAGS = \
    -Wall -g -O2 \
    -mlongcalls \
    -DCONFIG_MEM_HEAP_AREA_SIZE=64000 \
	-DJERRY_ENABLE_ERROR_MESSAGES

$(COMPONENT_OBJS): %.o: %.c
	@echo CC $@
	$(CC) $(CFLAGS) $(addprefix -I, $(COMPONENT_INCLUDES)) $(addprefix -I../, $(COMPONENT_ADD_INCLUDEDIRS)) -c -o $@ $<