#include "_x86.h"
#include "x86.h"
#include <resea.h>
#include <resea/x86.h>
#include <resea/hal.h>
#include "handler.h"


void x86_handler(channel_t __ch, payload_t *m) {
    if ((m[0] & 1) != 1) {
        WARN("the first payload is not inline one (expected inline msgid_t)");
        return;
    }

    switch (EXTRACT_MSGID(m)) {
    }

    WARN("unsupported message: msgid=%#x", EXTRACT_MSGID(m));
}
