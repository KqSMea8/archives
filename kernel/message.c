#include <arch.h>
#include <mutex.h>
#include <queue.h>
#include <string.h>
#include <logging.h>
#include "message.h"
#include "channel.h"
#include "process.h"
#include "thread.h"


struct channel *_get_channel_by_cid(struct process *proc, cid_t cid) {

    if (cid > proc->channels_max)
        return NULL;

    return &proc->channels[cid - 1];
}


struct channel *get_channel_by_cid(cid_t cid) {

    return _get_channel_by_cid(get_current_thread()->process, cid);
}


static result_t _send(struct channel *ch, const void *m, size_t size, int flags) {

    if (ch->state != CHANNEL_LINKED) {
        WARN("bad channel (@%d)", ch->cid);
        return E_BAD_CID;
    }

    struct channel *dst = ch->linked_to;
    cid_t sent_from = dst->cid;
    if (dst->transfer_to) {
        dst = dst->transfer_to;
    }

    // Acquire a sender right
    while (!mutex_try_lock(&dst->sender_lock)) {
        // TODO: block
        yield();
    }

    // Wait for the receiver
    struct thread *current = get_current_thread();
    set_thread_state(current, THREAD_BLOCKED);
    dst->sender = current;
    while (!dst->receiver || dst->sent_from != 0) {
        // Yield so that another thread can receive the channel. The current
        // thread is blocked until the receiver resumes it.
        yield();
    }

    set_thread_state(current, THREAD_RUNNABLE);

    // Parse payload headers and transform payloads.
    payload_t *payloads = (payload_t *) m;
    size_t payloads_num = size / sizeof(payload_t);
    payload_t header = 0;

    for (int i=0; i < payloads_num; i++) {
        if (IS_PAYLOAD_HEADER_INDEX(i)) {
            header = payloads[i];
        } else {
            int type = GET_PAYLOAD_TYPE(header, i);

            switch (type) {
            case PAYLOAD_NULL:
                break;
            case PAYLOAD_INLINE:
                // Nothing to do
                break;
            case PAYLOAD_POINTER:
                NOT_YET_IMPLEMENTED();
                break;
            default:
                // Handle an unknown payload as inline.
                WARN("unknown payload type: %d", type);
            }
        }
    }

    // Copy the message.
    // TODO: access right check
    if (memcpy_s((void *) dst->buffer, dst->buffer_size, m, size) != OK)
        return E_BAD_MEMCPY;

    dst->sent_from = sent_from;
    resume_thread(dst->receiver);
    mutex_unlock(&dst->sender_lock);

    return OK;
}


static result_t _recv(struct channel *ch, void *buffer, size_t size, int flags,
                      cid_t *from) {

    struct thread *current = get_current_thread();

    set_thread_state(current, THREAD_BLOCKED);
    ch->receiver    = current;
    ch->buffer      = (uintptr_t) buffer;
    ch->buffer_size = size;

    // Resume a sender thread if it exists.
    struct thread *sender = ch->sender;
    if (sender) {
        resume_thread(sender);
    }

    // Yield so that the sender thread can send a message.
    while (current->state == THREAD_BLOCKED) {
        // TODO: implement and use queue_delete(runqueue, current)
        yield();
    }

    // Sending is done and the sent message is filled in `buffer`.
    *from = ch->sent_from;
    ch->sent_from = 0;
    ch->receiver = NULL;
    mutex_unlock(&ch->receiver_lock);
    return OK;
}


cid_t _open(struct process *proc) {
    cid_t cid;
    struct channel *channels = proc->channels;

    mutex_lock(&proc->channels_lock);

    // Look for closed (unused) channels
    for (cid = 1; cid <= proc->channels_max; cid++) {
        if (channels[cid - 1].state == CHANNEL_CLOSED) {
            channels[cid - 1].state = CHANNEL_OPEN;
            mutex_unlock(&proc->channels_lock);

            // Initialize the allocated channel
            channels[cid - 1].cid       = cid;
            channels[cid - 1].process   = proc;
            channels[cid - 1].sent_from = 0;
            channels[cid - 1].sender    = NULL;
            channels[cid - 1].receiver  = NULL;
            channels[cid - 1].linked_to = NULL;
            channels[cid - 1].transfer_to = NULL;
            mutex_init(&channels[cid - 1].sender_lock);
            mutex_init(&channels[cid - 1].receiver_lock);
            return cid;
        }
    }

    // No channels available.
    WARN("too many channels");
    mutex_unlock(&proc->channels_lock);
    return 0;
}


cid_t open(void) {

    return _open(get_current_thread()->process);
}


result_t send(cid_t cid, const void *m, size_t size, int flags) {

    struct channel *ch = get_channel_by_cid(cid);
    if (!ch) {
        return E_BAD_CID;
    }

    return _send(ch, m, size, flags);
}


result_t recv(cid_t cid, void *buffer, size_t size, int flags, cid_t *from) {

    struct channel *ch = get_channel_by_cid(cid);

    if (!ch) {
        return E_BAD_CID;
    }

    if (!mutex_try_lock(&ch->receiver_lock)) {
        return E_ALREADY_RECVED;
    }

    return _recv(ch, buffer, size, flags, from);
}


result_t call(cid_t cid, const void *m, size_t m_size,
              void *r, size_t r_size) {

    result_t result;

    struct channel *ch = get_channel_by_cid(cid);
    if (!ch) {
        return E_BAD_CID;
    }

    // Lock the receiver lock of `src` channel to prevent
    // other threads from receiving the reply message of this
    // message.
    mutex_lock(&ch->receiver_lock);

    result = _send(ch, m, m_size, 0);
    if (result != OK) {
        return result;
    }

    cid_t from; // We don't care this.
    return _recv(ch, r, r_size, 0, &from);
}


result_t _link(struct channel *ch1, struct channel *ch2) {
    // TODO: add a assertion

    ch1->state     = CHANNEL_LINKED;
    ch1->linked_to = ch2;
    ch2->state     = CHANNEL_LINKED;
    ch2->linked_to = ch1;

    return OK;
}


result_t link(cid_t cid1, cid_t cid2) {

    struct channel *ch1 = get_channel_by_cid(cid1);
    struct channel *ch2 = get_channel_by_cid(cid2);

    if (!ch1 || !ch2) {
        return E_BAD_CID;
    }

    return _link(ch1, ch2);
}


result_t _transfer(struct channel *from, struct channel *to) {
    // TODO: add a assertion

    from->transfer_to = to;
    return OK;
}


result_t transfer(cid_t from, cid_t to) {

    struct channel *_from = get_channel_by_cid(from);
    struct channel *_to   = get_channel_by_cid(to);

    if (!_from || !_to) {
        return E_BAD_CID;
    }

    return _transfer(_from, _to);
}
