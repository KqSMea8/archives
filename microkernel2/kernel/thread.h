#ifndef __KERNEL_THREAD_H__
#define __KERNEL_THREAD_H__

#include <types.h>

enum {
    THREAD_RUNNABLE = 1,
    THREAD_BLOCKED  = 2,
};

struct process;
struct thread {
    struct thread *next;
    struct process *process;
    tid_t tid;
    int state;
    struct arch_thread arch;
};


tid_t allocate_tid(void);
struct thread *get_current_thread(void);
struct thread *create_thread(struct process *process, uintptr_t start,
                             uintmax_t arg, size_t stack_size);
void resume_thread(struct thread *thread);
void start_thread(struct thread *thread);
void destroy_thread(struct thread *thread);
void set_thread_state(struct thread *thread, int state);
void yield(void);

#endif
