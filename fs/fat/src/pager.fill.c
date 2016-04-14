#include <resea.h>
#include <resea/cpp/memory.h>
#include <resea/fat.h>
#include <resea/fs.h>
#include <resea/pager.h>
#include "fat.h"
#include "file.h"

/** handles pager.fill */
void fat_pager_fill(
         channel_t __ch,
         ident_t id,
         offset_t offset,
         size_t size) {

    result_t result;
    void* data;
    size_t r_size;

    data   = allocMemory(size, MEMORY_ALLOCMEM_NORMAL); // TODO: free on failure
    result = fat_read(&fat_the_disk, fat_get_file_by_id(id),
                      offset, data, size, &r_size);

    send_pager_fill_reply(__ch, result, MOVE(data), r_size);
}
