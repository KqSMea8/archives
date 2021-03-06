#ifndef __HAL_H__
#define __HAL_H__

#include <resea.h>
#include <_hal.h>

extern "C" {

// HAL handler_t
enum hal_callback_type {
  HAL_CALLBACK_INTERRUPT          = 0,
  HAL_CALLBACK_EXCEPTION          = 1,
  HAL_CALLBACK_SYSCALL            = 2,
  HAL_CALLBACK_TIMER_TICK         = 3,
  HAL_CALLBACK_RESUME_NEXT_THREAD = 4,
  HAL_CALLBACK_ALLOCATE_MEMORY    = 5,
  HAL_CALLBACK_RUN_THREAD         = 6,
  HAL_CALLBACK_START_THREADING    = 7,
  HAL_CALLBACK_PAGE_FAULT         = 8,
  HAL_CALLBACK_MAX                = 9
};

void * hal_get_callback(enum hal_callback_type type);
void hal_set_callback(enum hal_callback_type type, void *handler);

// implemented in cpp
bool is_hal_callback_set(enum hal_callback_type type);
result_t call_hal_callback(enum hal_callback_type type, ...);

enum exception_type {
  EXCEPTION_DIVIDE_BY_ZERO,
  EXCEPTION_PROTECTION_FAULT,
  EXCEPTION_INVALID_OPCODE,
  EXCEPTION_PAGE_FAULT,
  EXCEPTION_KERNEL_FAULT,  // exceptions caused by kernel's bug
  EXCEPTION_HARDWARE_ERROR,
};

void hal_wait_interrupt(void);
bool hal_interrupt_enabled(void);
void hal_enable_interrupt(void);
void hal_disable_interrupt(void);
void hal_enable_irq(uintmax_t irq);

// CPU
typedef uintmax_t cpuid_t;
cpuid_t hal_get_cpuid(void);
void hal_panic(void);

// Memory
#define PAGE_PRESENT    (1 << 1)
#define PAGE_READABLE   (1 << 2)
#define PAGE_WRITABLE   (1 << 3)
#define PAGE_EXECUTABLE (1 << 4)
#define PAGE_KERNEL     (1 << 5)
#define PAGE_USER       (1 << 6)
#define PAGE_RW (PAGE_PRESENT | PAGE_READABLE | PAGE_WRITABLE)
typedef uint32_t page_attrs_t;

struct hal_pmmap{
  paddr_t addr;
  size_t  size; // 0: the end of memory maps
};

enum vmmap_type {
  VMMAP_USER,
  VMMAP_DYNAMIC,
  VMMAP_KERNEL
};

struct hal_vmmap{
  enum vmmap_type type;
  paddr_t addr;
  size_t  size; // 0: the end of memory maps
};


#define VM_AREA_MAX 32
struct vm_area {
    uintptr_t    addr;
    size_t    size;
    uint32_t  flags;
    channel_t pager;
    ident_t      pager_arg;
    offset_t  offset;
};

struct vm_space {
    struct vm_area areas[VM_AREA_MAX];
    size_t areas_num;
    uint8_t* dynamic_vpages;
    mutex_t dynamic_vpages_lock;
    struct hal_vm_space  hal;
};


enum{
    PGFAULT_PRESENT = (1 << 1), // 1: present,            0: not present
    PGFAULT_WRITE   = (1 << 2), // 1: caused by write,    0: caused by read
    PGFAULT_EXEC    = (1 << 3), // 1: caused by execute,  0: caused by r/w
    PGFAULT_USER    = (1 << 4)  // 1: caused in usermode, 0: in kernelmode
};

struct hal_pmmap *hal_get_pmmaps(void);
struct hal_vmmap *hal_get_vmmaps(void);
void hal_create_vm_space(struct vm_space *vms);
void hal_remove_vm_space(struct vm_space *vms);
void hal_switch_vm_space(struct hal_vm_space *vms);
void hal_link_page(struct vm_space *vms, uintptr_t v, paddr_t p, size_t n,
                   page_attrs_t attrs);
void hal_set_page_attribute(struct vm_space *vms, uintptr_t v, size_t n, page_attrs_t attrs);
page_attrs_t hal_get_page_attribute(struct vm_space *vms, uintptr_t v);

// Returns the physical page address pointered from `v`.
paddr_t hal_vaddr_to_paddr(struct vm_space *vms, uintptr_t v);

// Returns vaddr wired to `p`. Note that it does not supports physical unwired pages.
uintptr_t hal_paddr_to_vaddr(paddr_t p);

// Threading
void hal_set_thread(struct hal_thread *t, bool is_kernel, uintptr_t entry,
                    uintptr_t arg, uintptr_t stack, uintptr_t stack_size);
NORETURN void hal_resume_thread(ident_t id, struct hal_thread *t, struct hal_vm_space *vms);
void hal_save_thread(struct hal_thread *t);
ident_t hal_get_current_thread_id(void);
void hal_set_current_thread_id(ident_t thread);

void hal_switch_thread(struct hal_thread *t);

// misc.
void hal_printchar(char c);

} // extern "C"

#endif

