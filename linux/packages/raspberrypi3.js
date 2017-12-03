const { isRebuilt, bootfsPath, assetPath, buildPath, run, sudo, mkdirp } = require('../pkgbuilder').pkg
const { spawnSync } = require('child_process')

const linuxVersion = '1.20170811-1'
const dependencies = ['linux', 'raspberrypi-firmware', 'bootfs-files']

module.exports = {
  name: 'raspberrypi3',
  type: 'target',
  dependencies,

  config() {
    return {
      'target.name': 'raspberrypi3',
      'target.initramfs_dependencies': ['raspberrypi-wifi-firmware'],
      'target.linux_arch': 'arm',
      'target.deb_arch': 'armhf',
      'target.node_arch': 'armv7l',
      'target.node_gyp_arch': 'arm',
      'target.build_prefix': `${buildPath('usr')}`,
      'target.libTriplet': 'arm-linux-gnueabihf',
      'glibc.ldDestPath': '/lib/ld-linux-armhf.so.3',
      'glibc.ldSourcePath': 'lib/arm-linux-gnueabihf/ld-linux-armhf.so.3',
      'target.ubuntu_pkg_url': 'http://ports.ubuntu.com/ubuntu-ports',
      'target.configure_host': 'arm-linux-gnueabihf',
      'target.toolchain_prefix': 'arm-linux-gnueabihf-',
      'openssl.configure_target': 'linux-armv4',
      'linux.version': linuxVersion,
      'linux.url': `https://github.com/raspberrypi/linux/archive/raspberrypi-kernel_${linuxVersion}.tar.gz`,
      'linux.sha256': '58addd6b6b65cc491d46bf2d3869d456976a49901d6986f004991745d4df7d66',
      'linux.make_target': 'zImage',
      'linux.bootfs': {
        '/kernel7.img': 'arch/arm/boot/zImage'
      },
      'linux.rootfs': {}
    }
  },

  changed() {
    return dependencies.some(isRebuilt)
  },

  buildImage(imageFile) {
    const mountPoint = buildPath('image')
    const username = spawnSync('whoami', { encoding: 'utf-8' })
      .stdout.replace('\n', '')

    mkdirp(mountPoint)
    run(['dd', 'if=/dev/zero', `of=${imageFile}`, 'bs=1M', 'count=64'])
    run(['mkfs.fat', '-n', 'MAKESTACK', imageFile])
    run(['mkdir', '-p', mountPoint])
    sudo(['mount', imageFile, mountPoint, '-o', `uid=${username}`, '-o', `gid=${username}`])
    run(['sh', '-c', `cp -r ${bootfsPath('.')}/* ${mountPoint}`])
    sudo(['umount', mountPoint])
  },

  bootfs: {
    '/cmdline.txt': assetPath('raspberrypi3', 'cmdline.txt'),
    '/config.txt': assetPath('raspberrypi3', 'config.txt')
  }
}
