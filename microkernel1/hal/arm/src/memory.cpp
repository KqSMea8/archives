#include <hal.h>
#include "arm.h"
#include <resea.h>


static struct hal_pmmap pmmap[16];
static struct hal_vmmap vmmap[16];

struct hal_pmmap *hal_get_pmmaps(void) {
    size_t size = 64 * 1024 * 1024;

    pmmap[0].addr = 0x01000000;
    pmmap[0].size = size;
    pmmap[1].addr = 0;
    pmmap[1].size = 0;
    return (struct hal_pmmap *) &pmmap;
}


struct hal_vmmap *hal_get_vmmaps(void) {

    vmmap[0].addr = 0;
    vmmap[0].size = 0;
    return (struct hal_vmmap *) &vmmap;
}
