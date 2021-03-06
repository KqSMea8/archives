/// @file
/// @brief map object.
#include "map.h"
#include "malloc.h"
#include "eval.h"

static ena_value_t map_get(struct ena_vm *vm, ena_value_t self, ena_value_t *args, int num_args) {
    ena_check_args(vm, "get()", "x", args, num_args);
    struct ena_map *self_map = ena_to_map_object(vm, self);
    ena_value_t key = args[0];

    struct ena_hash_entry *entry = ena_hash_search(vm, &self_map->entries, (void *) key);
    return entry ? (ena_value_t) entry->value : ENA_NULL;
}

static ena_value_t map_set(struct ena_vm *vm, ena_value_t self, ena_value_t *args, int num_args) {
    ena_check_args(vm, "set()", "xx", args, num_args);
    struct ena_map *self_map = ena_to_map_object(vm, self);
    ena_value_t key = args[0];
    ena_value_t value = args[1];

    struct ena_hash_entry *e;
    e = ena_hash_search(vm, &self_map->entries, (void *) key);
    if (e) {
        e->value = (void *) value;
    } else {
        ena_hash_insert(vm, &self_map->entries, (void *) key, (void *) value);
    }

    return ENA_NULL;
}

struct ena_class *ena_create_map_class(struct ena_vm *vm) {
    ena_value_t cls = ena_create_class(vm);
    ena_define_method(vm, cls, "get", map_get);
    ena_define_method(vm, cls, "set", map_set);
    return ena_to_class_object(vm, cls);
}
