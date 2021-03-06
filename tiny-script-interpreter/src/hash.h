#ifndef __ENA_HASH_H__
#define __ENA_HASH_H__

#include "internal.h"

#define INITIAL_NUM_BUCKETS 32
#define REHASH_THRESHOLD 8
#define REHASH_NEEDED(table) (((table)->num_entries / (table)->num_buckets) > REHASH_THRESHOLD)
#define ENTRY_EQUALS(vm, table, entry, digest, key) \
        ((digest) == (table)->methods->hash(vm, key) && (table)->methods->equals(vm, key, (entry)->key))

typedef uintptr_t ena_hash_digest_t;

struct ena_hash_methods {
    bool (*equals)(struct ena_vm *vm, void *key1, void *key2);
    ena_hash_digest_t (*hash)(struct ena_vm *vm, void *key);
};

struct ena_hash_entry {
    /// The pointer to the next entry in the bucket.
    struct ena_hash_entry *next;
    ena_hash_digest_t hash;
    void *key;
    void *value;
};

struct ena_hash_table {
    struct ena_hash_methods *methods;
    struct ena_hash_entry **buckets;
    int num_buckets;
    int num_entries;
};

struct ena_vm;
void ena_hash_init_table(struct ena_vm *vm, struct ena_hash_table *table, struct ena_hash_methods *methods);
void ena_hash_free_table(struct ena_vm *vm, struct ena_hash_table *table, void (*free_value)(void *value));
struct ena_hash_entry *ena_hash_search(struct ena_vm *vm, struct ena_hash_table *table, void *key);
void ena_hash_insert(struct ena_vm *vm, struct ena_hash_table *table, void *key, void *value);
struct ena_hash_entry *ena_hash_search_or_insert(struct ena_vm *vm, struct ena_hash_table *table, void *key, void *value);
bool ena_hash_remove(struct ena_vm *vm, struct ena_hash_table *table, void *key);
void ena_hash_remove_all(struct ena_vm *vm, struct ena_hash_table *table, void *key);
void ena_hash_foreach_key(struct ena_vm *vm, struct ena_hash_table *table, void (*cb)(struct ena_vm *vm, void *value));
void ena_hash_foreach_value(struct ena_vm *vm, struct ena_hash_table *table, void (*cb)(struct ena_vm *vm, void *value));

void ena_hash_init_ident_table(struct ena_vm *vm, struct ena_hash_table *table);
void ena_hash_init_cstr_table(struct ena_vm *vm, struct ena_hash_table *table);
void ena_hash_init_value_table(struct ena_vm *vm, struct ena_hash_table *table);

void ena_hash_dump_ident_value_table(struct ena_vm *vm, struct ena_hash_table *table);

#endif
