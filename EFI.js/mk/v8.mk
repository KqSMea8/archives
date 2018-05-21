vendor/v8/build/experimental-extras-libraries.cc:
	mkdir -p $(dir $@)
	$(CMDECHO) JS2C $@
	python vendor/v8/tools/js2c.py $@ EXPERIMENTAL_EXTRAS $^

vendor/v8/build/extras-libraries.cc:
	mkdir -p $(dir $@)
	$(CMDECHO) JS2C $@
	python vendor/v8/tools/js2c.py $@ EXTRAS $^

vendor/v8/build/experimental-libraries.cc: $(v8_experimental_libraries)
	mkdir -p $(dir $@)
	$(CMDECHO) JS2C $@
	python vendor/v8/tools/js2c.py $@ EXPERIMENTAL $^

vendor/v8/build/libraries.cc: $(v8_ibraries)
	mkdir -p $(dir $@)
	$(CMDECHO) JS2C $@
	python vendor/v8/tools/js2c.py $@ CORE $^

vendor/v8/build/snapshot.cc:
	mkdir -p $(dir $@)
	$(CMDECHO) JS2C $@
	python vendor/v8/tools/js2c.py $@ CORE $^

v8_experimental_libraries = \
    vendor/v8/src/js/macros.py \
    vendor/v8/src/messages.h \
    vendor/v8/src/js/harmony-async-await.js \
    vendor/v8/src/js/harmony-atomics.js \
    vendor/v8/src/js/harmony-sharedarraybuffer.js \
    vendor/v8/src/js/harmony-simd.js \
    vendor/v8/src/js/harmony-string-padding.js \
    vendor/v8/src/js/promise-extra.js

v8_libraries = \
    js/macros.py \
    messages.h \
    js/prologue.js \
    js/runtime.js \
    js/v8natives.js \
    js/symbol.js \
    js/array.js \
    js/string.js \
    js/math.js \
    js/regexp.js \
    js/arraybuffer.js \
    js/typedarray.js \
    js/iterator-prototype.js \
    js/collection.js \
    js/weak-collection.js \
    js/collection-iterator.js \
    js/promise.js \
    js/messages.js \
    js/array-iterator.js \
    js/string-iterator.js \
    js/templates.js \
    js/spread.js \
    js/proxy.js \
    debug/mirrors.js \
    debug/debug.js \
    debug/liveedit.js

v8_autogen_files = \
    vendor/v8/build/experimental-extras-libraries.cc \
    vendor/v8/build/extras-libraries.cc \
    vendor/v8/build/experimental-libraries.cc \
    vendor/v8/build/libraries.cc

v8_objs = \
    vendor/v8/src/base/accounting-allocator.o \
    vendor/v8/src/base/atomicops_internals_x86_gcc.o \
    vendor/v8/src/base/bits.o \
    vendor/v8/src/base/cpu.o \
    vendor/v8/src/base/division-by-constant.o \
    vendor/v8/src/base/file-utils.o \
    vendor/v8/src/base/functional.o \
    vendor/v8/src/base/ieee754.o \
    vendor/v8/src/base/logging.o \
    vendor/v8/src/base/once.o \
    vendor/v8/src/base/platform/condition-variable.o \
    vendor/v8/src/base/platform/mutex.o \
    vendor/v8/src/base/platform/semaphore.o \
    vendor/v8/src/base/platform/time.o \
    vendor/v8/src/base/sys-info.o \
    vendor/v8/src/base/utils/random-number-generator.o \
    vendor/v8/src/accessors.o \
    vendor/v8/src/address-map.o \
    vendor/v8/src/allocation-site-scopes.o \
    vendor/v8/src/allocation.o \
    vendor/v8/src/api-arguments.o \
    vendor/v8/src/api-experimental.o \
    vendor/v8/src/api-natives.o \
    vendor/v8/src/api.o \
    vendor/v8/src/arguments.o \
    vendor/v8/src/asmjs/asm-js.o \
    vendor/v8/src/asmjs/asm-types.o \
    vendor/v8/src/asmjs/asm-wasm-builder.o \
    vendor/v8/src/asmjs/typing-asm.o \
    vendor/v8/src/assembler.o \
    vendor/v8/src/assert-scope.o \
    vendor/v8/src/ast/ast-expression-rewriter.o \
    vendor/v8/src/ast/ast-expression-visitor.o \
    vendor/v8/src/ast/ast-literal-reindexer.o \
    vendor/v8/src/ast/ast-numbering.o \
    vendor/v8/src/ast/ast-value-factory.o \
    vendor/v8/src/ast/ast.o \
    vendor/v8/src/ast/modules.o \
    vendor/v8/src/ast/prettyprinter.o \
    vendor/v8/src/ast/scopeinfo.o \
    vendor/v8/src/ast/scopes.o \
    vendor/v8/src/ast/variables.o \
    vendor/v8/src/background-parsing-task.o \
    vendor/v8/src/bailout-reason.o \
    vendor/v8/src/basic-block-profiler.o \
    vendor/v8/src/bignum-dtoa.o \
    vendor/v8/src/bignum.o \
    vendor/v8/src/bit-vector.o \
    vendor/v8/src/bootstrapper.o \
    vendor/v8/src/builtins.o \
    vendor/v8/src/cached-powers.o \
    vendor/v8/src/cancelable-task.o \
    vendor/v8/src/char-predicates.o \
    vendor/v8/src/code-factory.o \
    vendor/v8/src/code-stub-assembler.o \
    vendor/v8/src/code-stubs-hydrogen.o \
    vendor/v8/src/code-stubs.o \
    vendor/v8/src/codegen.o \
    vendor/v8/src/compilation-cache.o \
    vendor/v8/src/compilation-dependencies.o \
    vendor/v8/src/compilation-statistics.o \
    vendor/v8/src/compiler.o \
    vendor/v8/src/compiler/access-builder.o \
    vendor/v8/src/compiler/access-info.o \
    vendor/v8/src/compiler/all-nodes.o \
    vendor/v8/src/compiler/ast-graph-builder.o \
    vendor/v8/src/compiler/ast-loop-assignment-analyzer.o \
    vendor/v8/src/compiler/basic-block-instrumentor.o \
    vendor/v8/src/compiler/branch-elimination.o \
    vendor/v8/src/compiler/bytecode-branch-analysis.o \
    vendor/v8/src/compiler/bytecode-graph-builder.o \
    vendor/v8/src/compiler/c-linkage.o \
    vendor/v8/src/compiler/checkpoint-elimination.o \
    vendor/v8/src/compiler/code-assembler.o \
    vendor/v8/src/compiler/code-generator.o \
    vendor/v8/src/compiler/common-node-cache.o \
    vendor/v8/src/compiler/common-operator-reducer.o \
    vendor/v8/src/compiler/common-operator.o \
    vendor/v8/src/compiler/control-builders.o \
    vendor/v8/src/compiler/control-equivalence.o \
    vendor/v8/src/compiler/control-flow-optimizer.o \
    vendor/v8/src/compiler/dead-code-elimination.o \
    vendor/v8/src/compiler/effect-control-linearizer.o \
    vendor/v8/src/compiler/escape-analysis-reducer.o \
    vendor/v8/src/compiler/escape-analysis.o \
    vendor/v8/src/compiler/frame-elider.o \
    vendor/v8/src/compiler/frame-states.o \
    vendor/v8/src/compiler/frame.o \
    vendor/v8/src/compiler/gap-resolver.o \
    vendor/v8/src/compiler/graph-reducer.o \
    vendor/v8/src/compiler/graph-replay.o \
    vendor/v8/src/compiler/graph-trimmer.o \
    vendor/v8/src/compiler/graph-visualizer.o \
    vendor/v8/src/compiler/graph.o \
    vendor/v8/src/compiler/instruction-scheduler.o \
    vendor/v8/src/compiler/instruction-selector.o \
    vendor/v8/src/compiler/instruction.o \
    vendor/v8/src/compiler/int64-lowering.o \
    vendor/v8/src/compiler/js-builtin-reducer.o \
    vendor/v8/src/compiler/js-call-reducer.o \
    vendor/v8/src/compiler/js-context-specialization.o \
    vendor/v8/src/compiler/js-create-lowering.o \
    vendor/v8/src/compiler/js-frame-specialization.o \
    vendor/v8/src/compiler/js-generic-lowering.o \
    vendor/v8/src/compiler/js-global-object-specialization.o \
    vendor/v8/src/compiler/js-graph.o \
    vendor/v8/src/compiler/js-inlining-heuristic.o \
    vendor/v8/src/compiler/js-inlining.o \
    vendor/v8/src/compiler/js-intrinsic-lowering.o \
    vendor/v8/src/compiler/js-native-context-specialization.o \
    vendor/v8/src/compiler/js-operator.o \
    vendor/v8/src/compiler/js-typed-lowering.o \
    vendor/v8/src/compiler/jump-threading.o \
    vendor/v8/src/compiler/linkage.o \
    vendor/v8/src/compiler/live-range-separator.o \
    vendor/v8/src/compiler/liveness-analyzer.o \
    vendor/v8/src/compiler/load-elimination.o \
    vendor/v8/src/compiler/loop-analysis.o \
    vendor/v8/src/compiler/loop-peeling.o \
    vendor/v8/src/compiler/machine-operator-reducer.o \
    vendor/v8/src/compiler/machine-operator.o \
    vendor/v8/src/compiler/memory-optimizer.o \
    vendor/v8/src/compiler/move-optimizer.o \
    vendor/v8/src/compiler/node-cache.o \
    vendor/v8/src/compiler/node-marker.o \
    vendor/v8/src/compiler/node-matchers.o \
    vendor/v8/src/compiler/node-properties.o \
    vendor/v8/src/compiler/node.o \
    vendor/v8/src/compiler/opcodes.o \
    vendor/v8/src/compiler/operation-typer.o \
    vendor/v8/src/compiler/operator-properties.o \
    vendor/v8/src/compiler/operator.o \
    vendor/v8/src/compiler/osr.o \
    vendor/v8/src/compiler/pipeline-statistics.o \
    vendor/v8/src/compiler/pipeline.o \
    vendor/v8/src/compiler/raw-machine-assembler.o \
    vendor/v8/src/compiler/redundancy-elimination.o \
    vendor/v8/src/compiler/register-allocator-verifier.o \
    vendor/v8/src/compiler/register-allocator.o \
    vendor/v8/src/compiler/representation-change.o \
    vendor/v8/src/compiler/schedule.o \
    vendor/v8/src/compiler/scheduler.o \
    vendor/v8/src/compiler/select-lowering.o \
    vendor/v8/src/compiler/simplified-lowering.o \
    vendor/v8/src/compiler/simplified-operator-reducer.o \
    vendor/v8/src/compiler/simplified-operator.o \
    vendor/v8/src/compiler/source-position.o \
    vendor/v8/src/compiler/state-values-utils.o \
    vendor/v8/src/compiler/store-store-elimination.o \
    vendor/v8/src/compiler/tail-call-optimization.o \
    vendor/v8/src/compiler/type-hint-analyzer.o \
    vendor/v8/src/compiler/type-hints.o \
    vendor/v8/src/compiler/typer.o \
    vendor/v8/src/compiler/value-numbering-reducer.o \
    vendor/v8/src/compiler/verifier.o \
    vendor/v8/src/compiler/wasm-compiler.o \
    vendor/v8/src/compiler/wasm-linkage.o \
    vendor/v8/src/compiler/zone-pool.o \
    vendor/v8/src/context-measure.o \
    vendor/v8/src/contexts.o \
    vendor/v8/src/conversions.o \
    vendor/v8/src/counters.o \
    vendor/v8/src/crankshaft/compilation-phase.o \
    vendor/v8/src/crankshaft/hydrogen-bce.o \
    vendor/v8/src/crankshaft/hydrogen-canonicalize.o \
    vendor/v8/src/crankshaft/hydrogen-check-elimination.o \
    vendor/v8/src/crankshaft/hydrogen-dce.o \
    vendor/v8/src/crankshaft/hydrogen-dehoist.o \
    vendor/v8/src/crankshaft/hydrogen-environment-liveness.o \
    vendor/v8/src/crankshaft/hydrogen-escape-analysis.o \
    vendor/v8/src/crankshaft/hydrogen-gvn.o \
    vendor/v8/src/crankshaft/hydrogen-infer-representation.o \
    vendor/v8/src/crankshaft/hydrogen-infer-types.o \
    vendor/v8/src/crankshaft/hydrogen-instructions.o \
    vendor/v8/src/crankshaft/hydrogen-load-elimination.o \
    vendor/v8/src/crankshaft/hydrogen-mark-deoptimize.o \
    vendor/v8/src/crankshaft/hydrogen-mark-unreachable.o \
    vendor/v8/src/crankshaft/hydrogen-osr.o \
    vendor/v8/src/crankshaft/hydrogen-range-analysis.o \
    vendor/v8/src/crankshaft/hydrogen-redundant-phi.o \
    vendor/v8/src/crankshaft/hydrogen-removable-simulates.o \
    vendor/v8/src/crankshaft/hydrogen-representation-changes.o \
    vendor/v8/src/crankshaft/hydrogen-sce.o \
    vendor/v8/src/crankshaft/hydrogen-store-elimination.o \
    vendor/v8/src/crankshaft/hydrogen-types.o \
    vendor/v8/src/crankshaft/hydrogen-uint32-analysis.o \
    vendor/v8/src/crankshaft/hydrogen.o \
    vendor/v8/src/crankshaft/lithium-allocator.o \
    vendor/v8/src/crankshaft/lithium-codegen.o \
    vendor/v8/src/crankshaft/lithium.o \
    vendor/v8/src/crankshaft/typing.o \
    vendor/v8/src/date.o \
    vendor/v8/src/dateparser.o \
    vendor/v8/src/debug/debug-evaluate.o \
    vendor/v8/src/debug/debug-frames.o \
    vendor/v8/src/debug/debug-scopes.o \
    vendor/v8/src/debug/debug.o \
    vendor/v8/src/debug/liveedit.o \
    vendor/v8/src/deoptimizer.o \
    vendor/v8/src/disassembler.o \
    vendor/v8/src/diy-fp.o \
    vendor/v8/src/dtoa.o \
    vendor/v8/src/eh-frame.o \
    vendor/v8/src/elements-kind.o \
    vendor/v8/src/elements.o \
    vendor/v8/src/execution.o \
    vendor/v8/src/extensions/externalize-string-extension.o \
    vendor/v8/src/extensions/free-buffer-extension.o \
    vendor/v8/src/extensions/gc-extension.o \
    vendor/v8/src/extensions/ignition-statistics-extension.o \
    vendor/v8/src/extensions/statistics-extension.o \
    vendor/v8/src/extensions/trigger-failure-extension.o \
    vendor/v8/src/external-reference-table.o \
    vendor/v8/src/factory.o \
    vendor/v8/src/fast-accessor-assembler.o \
    vendor/v8/src/fast-dtoa.o \
    vendor/v8/src/field-type.o \
    vendor/v8/src/fixed-dtoa.o \
    vendor/v8/src/flags.o \
    vendor/v8/src/frames.o \
    vendor/v8/src/full-codegen/full-codegen.o \
    vendor/v8/src/futex-emulation.o \
    vendor/v8/src/gdb-jit.o \
    vendor/v8/src/global-handles.o \
    vendor/v8/src/handles.o \
    vendor/v8/src/heap/array-buffer-tracker.o \
    vendor/v8/src/heap/code-stats.o \
    vendor/v8/src/heap/gc-idle-time-handler.o \
    vendor/v8/src/heap/gc-tracer.o \
    vendor/v8/src/heap/heap.o \
    vendor/v8/src/heap/incremental-marking-job.o \
    vendor/v8/src/heap/incremental-marking.o \
    vendor/v8/src/heap/mark-compact.o \
    vendor/v8/src/heap/memory-reducer.o \
    vendor/v8/src/heap/object-stats.o \
    vendor/v8/src/heap/objects-visiting.o \
    vendor/v8/src/heap/remembered-set.o \
    vendor/v8/src/heap/scavenge-job.o \
    vendor/v8/src/heap/scavenger.o \
    vendor/v8/src/heap/spaces.o \
    vendor/v8/src/heap/store-buffer.o \
    vendor/v8/src/ic/access-compiler.o \
    vendor/v8/src/ic/call-optimization.o \
    vendor/v8/src/ic/handler-compiler.o \
    vendor/v8/src/ic/ic-compiler.o \
    vendor/v8/src/ic/ic-state.o \
    vendor/v8/src/ic/ic.o \
    vendor/v8/src/ic/stub-cache.o \
    vendor/v8/src/icu_util.o \
    vendor/v8/src/identity-map.o \
    vendor/v8/src/interface-descriptors.o \
    vendor/v8/src/interpreter/bytecode-array-builder.o \
    vendor/v8/src/interpreter/bytecode-array-iterator.o \
    vendor/v8/src/interpreter/bytecode-array-writer.o \
    vendor/v8/src/interpreter/bytecode-dead-code-optimizer.o \
    vendor/v8/src/interpreter/bytecode-generator.o \
    vendor/v8/src/interpreter/bytecode-peephole-optimizer.o \
    vendor/v8/src/interpreter/bytecode-pipeline.o \
    vendor/v8/src/interpreter/bytecode-register-allocator.o \
    vendor/v8/src/interpreter/bytecode-register-optimizer.o \
    vendor/v8/src/interpreter/bytecodes.o \
    vendor/v8/src/interpreter/constant-array-builder.o \
    vendor/v8/src/interpreter/control-flow-builders.o \
    vendor/v8/src/interpreter/handler-table-builder.o \
    vendor/v8/src/interpreter/interpreter-assembler.o \
    vendor/v8/src/interpreter/interpreter-intrinsics.o \
    vendor/v8/src/interpreter/interpreter.o \
    vendor/v8/src/isolate.o \
    vendor/v8/src/json-parser.o \
    vendor/v8/src/json-stringifier.o \
    vendor/v8/src/keys.o \
    vendor/v8/src/layout-descriptor.o \
    vendor/v8/src/log-utils.o \
    vendor/v8/src/log.o \
    vendor/v8/src/lookup.o \
    vendor/v8/src/machine-type.o \
    vendor/v8/src/messages.o \
    vendor/v8/src/objects-debug.o \
    vendor/v8/src/objects-printer.o \
    vendor/v8/src/objects.o \
    vendor/v8/src/optimizing-compile-dispatcher.o \
    vendor/v8/src/ostreams.o \
    vendor/v8/src/parsing/func-name-inferrer.o \
    vendor/v8/src/parsing/parameter-initializer-rewriter.o \
    vendor/v8/src/parsing/parser.o \
    vendor/v8/src/parsing/pattern-rewriter.o \
    vendor/v8/src/parsing/preparse-data.o \
    vendor/v8/src/parsing/preparser.o \
    vendor/v8/src/parsing/rewriter.o \
    vendor/v8/src/parsing/scanner-character-streams.o \
    vendor/v8/src/parsing/scanner.o \
    vendor/v8/src/parsing/token.o \
    vendor/v8/src/pending-compilation-error-handler.o \
    vendor/v8/src/perf-jit.o \
    vendor/v8/src/profiler/allocation-tracker.o \
    vendor/v8/src/profiler/cpu-profiler.o \
    vendor/v8/src/profiler/heap-profiler.o \
    vendor/v8/src/profiler/heap-snapshot-generator.o \
    vendor/v8/src/profiler/profile-generator.o \
    vendor/v8/src/profiler/profiler-listener.o \
    vendor/v8/src/profiler/sampling-heap-profiler.o \
    vendor/v8/src/profiler/strings-storage.o \
    vendor/v8/src/profiler/tick-sample.o \
    vendor/v8/src/property-descriptor.o \
    vendor/v8/src/property.o \
    vendor/v8/src/regexp/interpreter-irregexp.o \
    vendor/v8/src/regexp/jsregexp.o \
    vendor/v8/src/regexp/regexp-ast.o \
    vendor/v8/src/regexp/regexp-macro-assembler-irregexp.o \
    vendor/v8/src/regexp/regexp-macro-assembler-tracer.o \
    vendor/v8/src/regexp/regexp-macro-assembler.o \
    vendor/v8/src/regexp/regexp-parser.o \
    vendor/v8/src/regexp/regexp-stack.o \
    vendor/v8/src/register-configuration.o \
    vendor/v8/src/runtime-profiler.o \
    vendor/v8/src/runtime/runtime-array.o \
    vendor/v8/src/runtime/runtime-atomics.o \
    vendor/v8/src/runtime/runtime-classes.o \
    vendor/v8/src/runtime/runtime-collections.o \
    vendor/v8/src/runtime/runtime-compiler.o \
    vendor/v8/src/runtime/runtime-date.o \
    vendor/v8/src/runtime/runtime-debug.o \
    vendor/v8/src/runtime/runtime-forin.o \
    vendor/v8/src/runtime/runtime-function.o \
    vendor/v8/src/runtime/runtime-futex.o \
    vendor/v8/src/runtime/runtime-generator.o \
    vendor/v8/src/runtime/runtime-i18n.o \
    vendor/v8/src/runtime/runtime-internal.o \
    vendor/v8/src/runtime/runtime-interpreter.o \
    vendor/v8/src/runtime/runtime-literals.o \
    vendor/v8/src/runtime/runtime-liveedit.o \
    vendor/v8/src/runtime/runtime-maths.o \
    vendor/v8/src/runtime/runtime-numbers.o \
    vendor/v8/src/runtime/runtime-object.o \
    vendor/v8/src/runtime/runtime-operators.o \
    vendor/v8/src/runtime/runtime-proxy.o \
    vendor/v8/src/runtime/runtime-regexp.o \
    vendor/v8/src/runtime/runtime-scopes.o \
    vendor/v8/src/runtime/runtime-simd.o \
    vendor/v8/src/runtime/runtime-strings.o \
    vendor/v8/src/runtime/runtime-symbol.o \
    vendor/v8/src/runtime/runtime-test.o \
    vendor/v8/src/runtime/runtime-typedarray.o \
    vendor/v8/src/runtime/runtime-wasm.o \
    vendor/v8/src/runtime/runtime.o \
    vendor/v8/src/safepoint-table.o \
    vendor/v8/src/snapshot/code-serializer.o \
    vendor/v8/src/snapshot/deserializer.o \
    vendor/v8/src/snapshot/natives-common.o \
    vendor/v8/src/snapshot/partial-serializer.o \
    vendor/v8/src/snapshot/serializer-common.o \
    vendor/v8/src/snapshot/serializer.o \
    vendor/v8/src/snapshot/snapshot-common.o \
    vendor/v8/src/snapshot/snapshot-source-sink.o \
    vendor/v8/src/snapshot/startup-serializer.o \
    vendor/v8/src/source-position-table.o \
    vendor/v8/src/startup-data-util.o \
    vendor/v8/src/string-builder.o \
    vendor/v8/src/string-stream.o \
    vendor/v8/src/strtod.o \
    vendor/v8/src/tracing/trace-event.o \
    vendor/v8/src/transitions.o \
    vendor/v8/src/type-cache.o \
    vendor/v8/src/type-feedback-vector.o \
    vendor/v8/src/type-info.o \
    vendor/v8/src/types.o \
    vendor/v8/src/unicode-decoder.o \
    vendor/v8/src/unicode.o \
    vendor/v8/src/uri.o \
    vendor/v8/src/utils.o \
    vendor/v8/src/v8.o \
    vendor/v8/src/v8threads.o \
    vendor/v8/src/version.o \
    vendor/v8/src/wasm/ast-decoder.o \
    vendor/v8/src/wasm/encoder.o \
    vendor/v8/src/wasm/module-decoder.o \
    vendor/v8/src/wasm/switch-logic.o \
    vendor/v8/src/wasm/wasm-debug.o \
    vendor/v8/src/wasm/wasm-external-refs.o \
    vendor/v8/src/wasm/wasm-function-name-table.o \
    vendor/v8/src/wasm/wasm-interpreter.o \
    vendor/v8/src/wasm/wasm-js.o \
    vendor/v8/src/wasm/wasm-module.o \
    vendor/v8/src/wasm/wasm-opcodes.o \
    vendor/v8/src/wasm/wasm-result.o \
    vendor/v8/src/zone.o \
    vendor/v8/src/compiler/x64/code-generator-x64.o \
    vendor/v8/src/compiler/x64/instruction-scheduler-x64.o \
    vendor/v8/src/compiler/x64/instruction-selector-x64.o \
    vendor/v8/src/crankshaft/x64/lithium-codegen-x64.o \
    vendor/v8/src/crankshaft/x64/lithium-gap-resolver-x64.o \
    vendor/v8/src/crankshaft/x64/lithium-x64.o \
    vendor/v8/src/debug/x64/debug-x64.o \
    vendor/v8/src/full-codegen/x64/full-codegen-x64.o \
    vendor/v8/src/ic/x64/access-compiler-x64.o \
    vendor/v8/src/ic/x64/handler-compiler-x64.o \
    vendor/v8/src/ic/x64/ic-compiler-x64.o \
    vendor/v8/src/ic/x64/ic-x64.o \
    vendor/v8/src/ic/x64/stub-cache-x64.o \
    vendor/v8/src/regexp/x64/regexp-macro-assembler-x64.o \
    vendor/v8/src/x64/assembler-x64.o \
    vendor/v8/src/x64/builtins-x64.o \
    vendor/v8/src/x64/code-stubs-x64.o \
    vendor/v8/src/x64/codegen-x64.o \
    vendor/v8/src/x64/cpu-x64.o \
    vendor/v8/src/x64/deoptimizer-x64.o \
    vendor/v8/src/x64/disasm-x64.o \
    vendor/v8/src/x64/frames-x64.o \
    vendor/v8/src/x64/interface-descriptors-x64.o \
    vendor/v8/src/x64/macro-assembler-x64.o \
    vendor/v8/src/libplatform/default-platform.o \
    vendor/v8/src/libplatform/task-queue.o \
    vendor/v8/src/libplatform/worker-thread.o \
    vendor/v8/src/snapshot/snapshot-empty.o \
    $(v8_autogen_files:.cc=.o)

objs += $(v8_objs)
autogen_files += $(v8_autogen_files)