NODE_ARCH=armv7l
DEB_ARCH=armhf
LD_ARCH=armhf
TRIPLET=arm-linux-gnueabihf
RPI_LINUX_VERSION=1.20170811-1
FIRMWARE_VERSION=1.20170811
LINUX_DIR=$BUILD_DIR/linux-raspberrypi-kernel_${RPI_LINUX_VERSION}
LINUX_TARBALL=$DOWNLOADS_DIR/raspberrypi-kernel_${RPI_LINUX_VERSION}.tar.gz
LINUX_MAKE_TARGET=(zImage dtbs)
DYLINKER_PATH=lib/ld-linux-armhf.so.3
IMAGE_FILE=$BUILD_DIR/makestack-linux-${MAKESTACK_LINUX_VERSION}-raspberrypi3.img
VMLINUZ=$LINUX_DIR/arch/arm/boot/zImage
DTB_PATH=$LINUX_DIR/arch/arm/boot/dts/bcm2710-rpi-3-b.dtb
DOWNLOAD_URLS=(\
    https://github.com/raspberrypi/firmware/archive/${FIRMWARE_VERSION}.tar.gz
    https://github.com/raspberrypi/linux/archive/raspberrypi-kernel_${RPI_LINUX_VERSION}.tar.gz \
    http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2 \
    https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz \
    http://http.us.debian.org/debian/pool/main/g/gcc-6/libgcc1_${LIBGCC_VERSION}_${DEB_ARCH}.deb \
    http://http.us.debian.org/debian/pool/main/g/gcc-6/libstdc++6_${LIBSTDCPP_VERSION}_${DEB_ARCH}.deb \
    http://http.us.debian.org/debian/pool/main/g/glibc/libc6_${GLIBC_VERSION}_${DEB_ARCH}.deb \
    http://ports.ubuntu.com/ubuntu-ports/pool/main/a/apparmor/apparmor_${APPARMOR_VERSION}_${DEB_ARCH}.deb
)

LIB_FILES=(\
        libgcc_s.so.1 \
        libnss_nis.so.2 \
        libm.so.6 \
        libthread_db.so.1 \
        libresolv.so.2 \
        libnss_nisplus.so.2 \
        libanl.so.1 \
        libdl.so.2 \
        libc.so.6 \
        libBrokenLocale.so.1 \
        libnss_files.so.2 \
        libpthread.so.0 \
        libcidn.so.1 \
        libnss_hesiod.so.2 \
        librt.so.1 \
        libnss_compat.so.2 \
        libnss_dns.so.2 \
        libutil.so.1 \
        libcrypt.so.1 \
        libnsl.so.1
)
QEMU=(
    qemu-system-arm
    -machine raspi2
    -kernel $BUILD_DIR/kernel.img
    -append '"console=ttyAMA0"'
    -dtb $DTB_PATH
    -nographic
)

# For Busybox and Linux.
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

NODE_GYP_ARCH=arm
NODE_GYP_ENV=(
    AR=arm-linux-gnueabihf-ar
    CC=arm-linux-gnueabihf-gcc
    CXX=arm-linux-gnueabihf-g++
    LINK=arm-linux-gnueabihf-g++
)

build-image() {
    build

    pushd $BUILD_DIR
    
    [ -d "firmware-$FIRMWARE_VERSION" ] || tar xf $DOWNLOADS_DIR/$FIRMWARE_VERSION.tar.gz
    mkdir -p disk
    dd if=/dev/zero of=$IMAGE_FILE bs=1M count=64
    mkfs.fat -L MAKESTACK $IMAGE_FILE
    sudo mount $IMAGE_FILE disk -o uid=$(whoami) -o gid=$(whoami)
    cp -r firmware-$FIRMWARE_VERSION/boot/* disk
    rm disk/kernel.img disk/kernel7.img
    cp $KERNEL_IMG disk/kernel7.img
    cp -r $DISK_DIR/* disk
    cp $TARGET_DIR/config.txt disk
    cp $TARGET_DIR/cmdline.txt disk
    sudo umount $IMAGE_FILE

    rm -f $IMAGE_FILE.xz
    xz --keep $IMAGE_FILE
    du -h $IMAGE_FILE
    sha256sum $IMAGE_FILE

    du -h $IMAGE_FILE.xz
    sha256sum $IMAGE_FILE.xz

    popd
}