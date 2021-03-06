#include <resea.h>
#include <arch.h>
#include <kernel/timer.h>
#include <kernel/thread.h>
#include "hypercall.h"


unsigned long prev_millis = 0;

void arch_halt_until(size_t ms) {
    size_t from_prev_wait = hypercalls->millis() - prev_millis;

    if (prev_millis == 0) {
        hypercalls->delay(ms);
        advance_clock(ms);
    } else {
        if (from_prev_wait < ms) {
            hypercalls->delay(ms - from_prev_wait);
            advance_clock(ms);
        } else {
            advance_clock(from_prev_wait);
        }
    }

    prev_millis = hypercalls->millis();
    // return to yield()
}
