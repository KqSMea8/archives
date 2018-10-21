use core::cmp::min;
use core::mem::{size_of, transmute};
use core::option::Option;
use core::str;
use resea::{ErrorCode, Result as ServerResult};
use resea::interfaces::blk_device::BlkDevice;
use alloc::vec::Vec;

#[repr(C, packed)]
#[derive(Clone, Debug)]
pub struct FatEntry {
    name: [u8; 8],
    ext: [u8; 3],
    attr: u8,
    ntres: u8,
    time_created_ms: u8,
    time_created: u16,
    date_created: u16,
    date_last_accessed: u16,
    first_cluster_high: u16,
    time_modified: u16,
    date_modified: u16,
    first_cluster_low: u16,
    size: u32,
}

#[repr(C, packed)]
pub struct Mbr {
    jump: [u8; 3],
    oem_name: [u8; 8],
    sector_size: u16,
    sectors_per_cluster: u8,
    reserved_sectors: u16,
    number_of_fats: u8,
    root_dir_entries: u16,
    total_sectors: u16,
    media: u8,
    sectors_per_fat: u16,
    sectors_per_track: u16,
    number_of_heads: u16,
    number_of_hidden_sectors: u32,
    total_sectors32: u32,
    sectors_per_fat32: u32,
    mirroring_flags: u16,
    version: u16,
    root_dir_cluster: u32,
    fs_info_sector: u16,
    backup_sector: u16,
    boot_filename: [u8; 12],
    drive_number: u8,
    flags: u8,
    extended_boot_signature: u8,
    volume_serial_number: u32,
}

impl FatEntry {
    pub fn cluster(&self) -> Cluster {
        ((self.first_cluster_high as Cluster) << 16) | self.first_cluster_low as Cluster
    }
}

type Cluster = u32;

struct Bpb {
    cluster_size: usize, /* sector_size * sectors_per_cluster */
    root_dir_cluster: Cluster,
    sector_size: usize,
    sectors_per_cluster: usize,
    cluster_start_offset: usize,
    fat_table_offset: usize,
}

fn parse_mbr(mbr: &[u8], part_begin: usize) -> Bpb {
    let bpb = unsafe { transmute::<*const u8, *const Mbr>(mbr.as_ptr()) };
    let sector_size = unsafe { (*bpb).sector_size as usize };
    let cluster_size = unsafe { sector_size * (*bpb).sectors_per_cluster as usize };
    let sectors_per_cluster = unsafe { (*bpb).sectors_per_cluster as usize };
    let fat_table_sector_start = unsafe { (*bpb).reserved_sectors as usize };
    let fat_table_offset = part_begin + fat_table_sector_start * sector_size;
    let number_of_fats = unsafe { (*bpb).number_of_fats as usize };
    let sectors_per_fat = unsafe { (*bpb).sectors_per_fat32 as usize };
    let cluster_start_offset =
        part_begin + (fat_table_sector_start + number_of_fats * sectors_per_fat) * sector_size;
    let root_dir_cluster = unsafe { (*bpb).root_dir_cluster };
    Bpb {
        cluster_size: cluster_size,
        root_dir_cluster: root_dir_cluster,
        sector_size: sector_size,
        sectors_per_cluster: sectors_per_cluster,
        cluster_start_offset: cluster_start_offset,
        fat_table_offset: fat_table_offset,
    }
}

pub struct Fat {
    device: BlkDevice,
    part_begin: usize,
    bpb: Bpb,
}

impl Fat {
    pub fn new(device: BlkDevice, part_begin: usize) -> Fat {
        let bpb = {
            let mbr = device.read(part_begin as u64, 512).unwrap();
            parse_mbr(mbr.as_slice(), part_begin)
        };

        Fat {
            bpb: bpb,
            device: device,
            part_begin: part_begin,
        }
    }

    pub fn look_for_file(&self, path: &str) -> Option<Cluster> {
        for frag in path.split("/") {
            // main.rs => name='MAIN    ', ext='RS '
            let mut s = frag.split(".");
            let name = format!("{:<8}", s.nth(0).unwrap_or("").to_ascii_uppercase());
            let ext = format!("{:<3}", s.nth(0).unwrap_or("").to_ascii_uppercase());

            let mut current = self.bpb.root_dir_cluster;
            let mut buf = Vec::new();

            while let Some(next) = self.read_cluster(&mut buf, current) {
                for i in 0..(self.bpb.cluster_size / size_of::<FatEntry>()) {
                    // FIXME:
                    let entries = unsafe { transmute::<&[u8], &[FatEntry]>(buf.as_slice()) };
                    let entry = entries[i].clone();

                    if entry.name[0] == 0x00 {
                        // End of entries.
                        return None;
                    }

                    if let Ok(entry_name) = str::from_utf8(&entry.name) {
                        if let Ok(entry_ext) = str::from_utf8(&entry.ext) {
                            if entry_name == name && entry_ext == ext {
                                return Some(entry.cluster());
                            }
                        }
                    }
                }

                current = next;
            }
        }

        None
    }

    pub fn read_file(
        &self,
        buf: &mut Vec<u8>,
        cluster: Cluster,
        offset: usize,
        len: usize,
    ) -> ServerResult<usize> {
        let mut current = cluster;
        let mut data = Vec::new();
        let mut total_len = 0;
        let mut remaining = len;
        let mut off = offset;
        while let Some(next) = self.read_cluster(&mut data, current) {
            if off < self.bpb.cluster_size {
                let read_len = min(self.bpb.cluster_size - off, len);
                buf.extend_from_slice(&data[off..(off + read_len)]);
                off = 0;
                remaining -= read_len;
                total_len += read_len;

                if remaining == 0 {
                    return Ok(total_len);
                }
            }

            off -= self.bpb.cluster_size;
            current = next;
        }

        Err(ErrorCode::NotImplemented as u8)
    }

    fn read_cluster(&self, buf: &mut Vec<u8>, cluster: Cluster) -> Option<Cluster> {
        if cluster == 0xffffff00 {
            return None;
        }

        let cluster_start = 2; // XXX: FAT32
        let cluster_offset = self.bpb.cluster_start_offset
            + ((cluster as usize - cluster_start) * self.bpb.cluster_size);
        let data = self
            .device
            .read(cluster_offset as u64, self.bpb.cluster_size)
            .unwrap();

        let entry_offset = (size_of::<Cluster>() * cluster as usize) % self.bpb.sector_size;
        let fat_offset = (self.bpb.fat_table_offset + entry_offset) % self.bpb.sector_size;
        let fat_data = self
            .device
            .read(fat_offset as u64, self.bpb.sector_size)
            .unwrap();
        let table = unsafe { transmute::<&[u8], &[Cluster]>(fat_data.as_slice()) };
        let next = table[entry_offset];
        *buf = data.as_slice().to_vec();

        Some(next)
    }
}
