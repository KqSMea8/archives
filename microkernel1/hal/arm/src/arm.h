#ifndef __ARM_ARM_H__
#define __ARM_ARM_H__

#define PACKAGE_NAME "arm"

#include <resea.h>
#include <hal.h>

#define CPU_MAX_NUM  32
#define CPUVAR ((struct arm_cpuvar *) &arm_cpuvars[hal_get_cpuid()])


struct arm_cpuvar {
  ident_t current_thread;
  struct hal_thread_regs *irq_thread_state;
};


extern struct arm_cpuvar arm_cpuvars[CPU_MAX_NUM];

namespace arm {
result_t console_read(uint8_t *data);
result_t console_write(uint8_t data);
} // namespace arm

extern "C" {
    void arm_accept_irq(void);
};

#endif
