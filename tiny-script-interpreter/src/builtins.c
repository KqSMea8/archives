#include "builtins.h"
#include "api.h"
#include "eval.h"

#define DEFINE_BINOP(name, type, c_op) \
    static ena_value_t int_##name(UNUSED struct ena_vm *vm, ena_value_t self, ena_value_t *args, UNUSED int num_args) { \
        int lhs = ena_to_int(vm, self); \
        int rhs = ena_to_int(vm, args[0]); \
        return ena_create_##type(vm, lhs c_op rhs); \
    }

#define DEFINE_BINOP_DIV(name, type, c_op) \
    static ena_value_t int_##name(UNUSED struct ena_vm *vm, ena_value_t self, ena_value_t *args, UNUSED int num_args) { \
        int lhs = ena_to_int(vm, self); \
        int rhs = ena_to_int(vm, args[0]); \
        if (rhs == 0) { \
            RUNTIME_ERROR("divide by zero"); \
        } \
        return ena_create_##type(vm, lhs c_op rhs); \
    }

DEFINE_BINOP(add, int, +)
DEFINE_BINOP(sub, int, -)
DEFINE_BINOP(mul, int, *)
DEFINE_BINOP_DIV(div, int, /)
DEFINE_BINOP_DIV(mod, int, %)
DEFINE_BINOP(lt, bool, <)
DEFINE_BINOP(lte, bool, <=)
DEFINE_BINOP(gt, bool, >)
DEFINE_BINOP(gte, bool, >=)
DEFINE_BINOP(eq, bool, ==)
DEFINE_BINOP(neq, bool, !=)

struct ena_class *ena_create_int_class(struct ena_vm *vm) {
    ena_value_t cls = ena_create_class(vm);
    ena_define_method(vm, cls, "+", int_add);
    ena_define_method(vm, cls, "-", int_sub);
    ena_define_method(vm, cls, "*", int_mul);
    ena_define_method(vm, cls, "/", int_div);
    ena_define_method(vm, cls, "%", int_mod);
    ena_define_method(vm, cls, "<", int_lt);
    ena_define_method(vm, cls, "<=", int_lte);
    ena_define_method(vm, cls, ">", int_gt);
    ena_define_method(vm, cls, ">=", int_gte);
    ena_define_method(vm, cls, "!=", int_neq);
    ena_define_method(vm, cls, "==", int_eq);
    return ena_to_class_object(vm, cls);
}
