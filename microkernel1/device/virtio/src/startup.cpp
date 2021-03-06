#include <resea.h>
#include <resea/channel.h>
#include <resea/net_device.h>
#include <resea/storage_device.h>
#include "virtio.h"
#include "handler.h"
#include "virtio_net.h"
#include "virtio_blk.h"


handler_t virtio_handler;
channel_t virtio_server;

extern "C" void virtio_startup(void) {

    INFO("starting");

    virtio_server = create_channel();

    // virito_server will be regitered in init functions below
    set_channel_handler(virtio_server, virtio::server_handler);

    virtio_net_init();
    virtio_blk_init();

    INFO("ready");
    serve_channel(virtio_server, virtio::server_handler);
}
