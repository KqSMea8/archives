#include <arch.h>
#include <logging.h>
#include "init.h"
#include "panic.h"
#include "process.h"
#include "thread.h"
#include "resources.h"


extern uintptr_t apps[];

void init_kernel(struct resources *_resources) {

    INFO("Welcome to Resea");

    resources = _resources;
    resources->processes = NULL;
    mutex_init(&resources->processes_lock);
    mutex_init(&resources->runqueue_lock);
    resources->runqueue_num = MAX_THREAD_NUM;
    for (int i = 0; i < resources->runqueue_num; i++) {
        resources->runqueue[i] = NULL;
    }

    INFO("creating the kernel process");
    struct process *kproc = create_process();

    if (!apps[0]) {
        PANIC("no in-kernel apps found");
    }

    INFO("creating in-kernel app");
    for (int i=0; apps[i]; i++) {
        INFO("in-kernel app: addr=%p", apps[i]);
        start_thread(create_thread(kproc, apps[i], 0));
    }

    // Start the first thread
    struct thread *t = resources->runqueue[0];

    INFO("starting the first thread");
    arch_switch_thread(t->tid, &t->arch);
}
