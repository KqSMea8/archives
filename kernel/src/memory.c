#include <hal.h>
#include <resea.h>
#include <resea/cpp/io.h>
#include <resea/cpp/memory.h>
#include <resea/pager.h>
#include <string.h>
#include "kernel.h"


/*
 *  Physical memory space
 */
struct pm_space {
    mutex_t    lock;
    size_t     num;    /* the number of pages */
    paddr_t    paddr;   /* the beginning address of the space */
    uint8_t    *pages; /* reference counts */
    struct pm_space *next; /* the next physical memory space if it is not NULL */
};


/* a singly linked list of physical memory spaces */
static struct pm_space *memory_spaces = NULL;
static size_t memory_space_num = 0;
static uintptr_t dynamic_vpages_start = 0;
static size_t dynamic_vpages_num = 0;


/**
 *
 *  Initlaizes memory management
 *
 *  @param[in] mmap  a memory map
 *
 */
static void init_memory(void) {
    struct hal_pmmap *pmmap = hal_get_pmmaps();
    struct hal_vmmap *vmmap = hal_get_vmmaps();
    int i;

    memory_spaces = (struct pm_space *) hal_paddr_to_vaddr(pmmap[0].addr);

    /*
     *  add memory maps from HAL into this CPU's `memory_spaces`
     */
    for (i=0; pmmap[i].size > 0; i++) {
        struct pm_space *m;

        INFO("new physical memory space: addr=%p size=%lldMB",
             pmmap[i].addr,
             pmmap[i].size / 1024 / 1024);

        m = (struct pm_space *) hal_paddr_to_vaddr(pmmap[i].addr);
        init_mutex(&m->lock, MUTEX_UNLOCKED);
        m->pages = (uint8_t *) hal_paddr_to_vaddr(pmmap[i].addr) + sizeof(struct pm_space);
        m->num   = pmmap[i].size / PAGE_SIZE;
        m->paddr = ((pmmap[i].addr + sizeof(struct pm_space) +
                     sizeof(uintmax_t) * m->num) & (paddr_t) ~(PAGE_SIZE - 1)) +
                     PAGE_SIZE;

        if (pmmap[i+1].size > 0)
            m->next = (struct pm_space *) hal_paddr_to_vaddr(pmmap[i+1].addr);
        else
            m->next = NULL;

        memory_space_num++;
    }

    //
    //  XXX: look for dynamic vpages area
    //
    for (i=0; vmmap[i].size > 0; i++) {
        if (vmmap[i].type == VMMAP_DYNAMIC) {
           dynamic_vpages_start = vmmap[i].addr; 
           dynamic_vpages_num   = vmmap[i].size / PAGE_SIZE;
           break;
        }
    }

    if (vmmap[i].size == 0) {
        WARN("dynamic vpages area not found");
    }
}


size_t kernel_get_dynamic_vpages_num(void) {

    return dynamic_vpages_num;
}


/**
 *  Allocates virtual memory pages
 *
 *  @param[in] size  The number of bytes.
 *  @return  The beginning virtual address of the allocated virtual pages.
 *
 */
uintptr_t kernel_vmalloc(size_t size) {
    void *p;
    size_t num = size / PAGE_SIZE + ((size % PAGE_SIZE == 0)? 0:1);
    struct thread_group *group = kernel_get_current_thread_group();
    uint8_t *vpages = group->vm.dynamic_vpages;
    mutex_t *lock   = &group->vm.dynamic_vpages_lock;

    lock_mutex(lock);
    p = memchrseq(vpages, sizeof(*vpages) * dynamic_vpages_num, 0x00, num);

    if (p) {
        /* allocation succeeded */
        uintmax_t st = (PTR2ADDR(p) - PTR2ADDR(vpages));

        // mark as used
        for (uintmax_t i=st; i < (st + num); i++) {
            vpages[i] = 1;
        }

        unlock_mutex(lock);
        return (dynamic_vpages_start + (st * PAGE_SIZE));
    }

    unlock_mutex(lock);
    return 0;
}


/**
 *  Allocates physical memory pages
 *
 *  @param[in] num   The number of memory pages to be allocated.
 *  @return  The address to the allocated memory pages.
 *
 */
static paddr_t pmalloc(size_t num) {
    struct pm_space *m = memory_spaces;

    for (size_t i=0; i < memory_space_num; m = m->next, i++) {
        /*
         *  look for enough continuous pages
         */

        lock_mutex(&m->lock);
        void *p = memchrseq(m->pages, sizeof(*m->pages) * m->num, 0x00, num);

        if (p) {
            /* allocation succeeded */
            uintmax_t st = (PTR2ADDR(p) - PTR2ADDR(m->pages));

            // increment the reference counts
            for (uintmax_t j=st; j < (st + num); j++) {
                m->pages[j]++;
            }

            unlock_mutex(&m->lock);
            return (m->paddr + (PAGE_SIZE * st));
        }

        unlock_mutex(&m->lock);
    }

    return 0;
}


/**
 *  Frees physical memory pages
 *
 *  @param[in] p    The addreess to a memory space to be freed.
 *  @param[in] num  The number of physical pages to be freed.
 *
 */
UNUSED static void pfree(paddr_t p, size_t num) {
    struct pm_space *m;
    paddr_t st, end;
    uintmax_t i;

    BUG_IF(num == 0, "pfree() with n=0");

    /*
     *  look for the space where `p` belongs to
     */
    for (m=memory_spaces; m != NULL; m = m->next) {
        st  = m->paddr;
        end = m->paddr + (m->num * PAGE_SIZE);
        if (st <= p && p <= end)
            break;
    }

    if (m == NULL || p < st || p >= end) {
        DEBUG("pfree(): freeing an invalid pointer");
        return;
    }

    /*
     *  decrement reference count
     */
    i = (p - st) / PAGE_SIZE;
    while(num > 0) {
        m->pages[i]--;
        i++;
        num--;
    }
}


void kernel_release_memory(void *p) {
  /* TODO */
}


/**
 *  Allocates memory block
 *
 *  @param[in] size   The size of memory pages to be allocated.
 *  @param[in] flags  Attribute of pages
 *  @return  The pointer to the allocated memory block.
 *
 */
void *kernel_allocate_memory(size_t size, uint32_t flags) {
    paddr_t paddr;

    return allocPhysicalMemory(0, size, flags, &paddr);
}


void *allocPhysicalMemory(paddr_t addr, size_t size, uint32_t flags, paddr_t *alloced_addr){
    size_t required;
    paddr_t paddr;
    void *p;

    // calculate the number of pages large enough for `size`
    required = (size / PAGE_SIZE) + 1;

    // allocate physical memory pages
    if ((paddr = pmalloc(required)) == 0)
        PANIC("pmalloc: failed to allocate memory");

    p = (void *) hal_paddr_to_vaddr(paddr);

    // zero clear
    memset(p, 0x00, size);

    *alloced_addr = paddr;
    return p;
}


void kernel_page_fault_handler(uintptr_t addr, uint32_t reason) {
    struct thread_group *g;

    if(!(reason & PGFAULT_USER)) {
        PANIC("page fault in the kernel mode: addr=%p, reason=%#8x",
              addr, reason);
    }

    g = kernel_get_current_thread_group();

    for (size_t i=0; i< g->vm.areas_num; i++) {
        struct vm_area *area = &g->vm.areas[i];

        if (area->addr <= addr && addr < area->addr + area->size) {
            /* found the vm_area */
            offset_t offset; // offset from the area
            result_t result;
            uintptr_t aligned_addr, filled_addr;
            size_t filled_size;

            INFO("page_fault_handler: found a vm_area, filling...");

            aligned_addr = addr & ~(PAGE_SIZE - 1);
            offset = aligned_addr - area->addr;
            call_pager_fill(area->pager,
                 area->pager_arg, area->offset + offset, PAGE_SIZE,
                 &result, (void *) &filled_addr, &filled_size);

            INFO("linking v=%p, p=%p, filled_addr=%p", aligned_addr,
                 hal_vaddr_to_paddr(&g->vm, filled_addr), filled_addr);

            hal_link_page(&g->vm, aligned_addr,
                          hal_vaddr_to_paddr(&g->vm, filled_addr), 1,
                          PAGE_PRESENT | PAGE_READABLE | PAGE_WRITABLE |
                          PAGE_USER | PAGE_EXECUTABLE /* XXX: use area->flags and
                                                  verify `reason` */);
            INFO("page_fault_handler: filled, resuming");
            return;
        }
    }

    PANIC("page fault at an unmapped area: addr=%p, reason=%#8x",
          addr, reason);
}


void kernel_memory_startup(void) {

    INFO("initializing the memory system");

    init_memory();
}
