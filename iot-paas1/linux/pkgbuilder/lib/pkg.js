const fs = require('fs')
const os = require('os')
const path = require('path')
const { spawnSync } = require('child_process')
const { find, mkdirp, copyFiles } = require('./helpers')
const ubuntuPackages = require(path.resolve(__dirname, '../../packages/ubuntu-packages.json'))
const chalk = require('chalk')

function config(key) {
  if (!(key in build.config)) {
    throw new Error(`undefined config \`${key}'`)
  }

  return build.config[key]
}

function isNewerFile(file1, file2) {
  if (!fs.existsSync(file1) || !fs.existsSync(file2)) {
    return true
  }

  const stat1 = fs.statSync(file1)
  const stat2 = fs.statSync(file2)

  return stat1.mtimeMs > stat2.mtimeMs
}

function isNewerDirContent(dir1, dir2, ignorePatterns) {
  if (!fs.existsSync(dir2)) {
    return true
  }

  let files = find(dir1)
  for (const file of files) {
    if (ignorePatterns.some(pattern => file.match(pattern))) {
      continue
    }

    const file1 = path.join(dir1, file)
    const file2 = path.join(dir2, file)
    if (!fs.existsSync(file2)) { return true }

    const stat1 = fs.statSync(file1)
    const stat2 = fs.statSync(file2)
    if (stat1.ctimeMs > stat2.ctimeMs) { return true }
  }

  return false
}

function copyFile(src, dest) {
  mkdirp(path.dirname(dest))
  return fs.copyFileSync(src, dest)
}

function assetPath(pkgName, filepath = '') {
  return path.resolve(__dirname, '../../packages', pkgName, filepath)
}

function buildPath(filepath) {
  return path.resolve(build.buildDir, filepath)
}

function bootfsPath(filepath) {
  return path.resolve(build.bootfsDir, filepath)
}

function rootfsPath(filepath) {
  return path.resolve(build.rootfsDir, filepath)
}

function isRebuilt(pkg) {
  return build.rebuiltPackages.includes(pkg)
}

function run(argv, env, cwd = process.cwd()) {
  if (cwd === process.cwd()) {
    console.log(chalk.bold(`${argv.join(' ')}`))
  } else {
    console.log(chalk.bold(`${argv.join(' ')}` + ` (in ${cwd})`))
  }

  const cp = spawnSync(argv[0], argv.slice(1), {
    stdio: 'inherit',
    cwd,
    env: Object.assign({
      PATH: process.env.PATH,
      MAKEFLAGS: `-j${os.cpus().length}`,
      JOBS: os.cpus().length // Used by node-gyp.
    }, env)
  })

  if (cp.error) {
    throw new Error(`error: failed to run ${argv[0]}: ${cp.error}`)
  }

  if (cp.status !== 0) {
    throw new Error(`error: \`${argv[0]}' exited with ${cp.status}.`)
  }
}

function runWithPipe(argv, env = {}, cwd = process.cwd(), options = {}) {
  if (cwd === process.cwd()) {
    console.log(chalk.bold(`${argv.join(' ')}`))
  } else {
    console.log(chalk.bold(`${argv.join(' ')}` + ` (in ${cwd})`))
  }

  const cp = spawnSync(argv[0], argv.slice(1), Object.assign({
    cwd,
    encoding: 'utf-8',
    env: Object.assign({
      PATH: process.env.PATH,
      MAKEFLAGS: `-j${os.cpus().length}`
    }, env)
  }, options))

  if (cp.error) {
    throw new Error(`error: failed to run ${argv[0]}: ${cp.error}`)
  }

  if (cp.status !== 0) {
    throw new Error(
      `error: \`${argv[0]}' exited with ${cp.status}.\n` +
      `stdout:${cp.stdout}\n\nstderr:${cp.stderr}`
    )
  }

  return cp.stdout
}

function applyPatch(patchFile) {
  console.log(chalk.bold(`Applying ${patchFile}`))

  const cp = spawnSync('patch', ['-p1'], {
    input: fs.readFileSync(patchFile)
  })

  if (cp.error) {
    throw new Error(`error: failed to patch: ${cp.error}`)
  }

  if (cp.status !== 0) {
    throw new Error(`error: \`patch' exited with ${cp.status}:\n${cp.stdoust}`)
  }
}

function sudo(argv, env) {
  console.log(chalk.bold(`sudo ${argv.join(' ')}`))
  spawnSync('sudo', argv, {
    stdio: 'inherit',
    env: Object.assign({
      PATH: process.env.PATH,
      MAKEFLAGS: `-j${os.cpus().length}`
    }, env)
  })
}

function buildFatImage(imageFile) {

  const mountPoint = buildPath('image')
  const username = runWithPipe(['whoami']).replace('\n', '')

  mkdirp(mountPoint)
  run(['dd', 'if=/dev/zero', `of=${imageFile}`, 'bs=1M', 'count=64'])
  runWithPipe(['fdisk', imageFile], null, null, { input: 'n\np\n\n\n\na\n1\nt\n6\nw\n' })

  const partedOutput = runWithPipe(
    ['parted', '-s', imageFile, 'unit', 'b', 'print']
  ).split('\n').filter(line => line.includes('boot'))[0]

  if (!partedOutput) {
    throw new Error('failed to get the partiton layout by parted(8');
  }

  const partOffset = partedOutput.replace(/^\s+/, '').split(/\s+/)[1].replace(/B$/, '')
  const partLength = partedOutput.replace(/^\s+/, '').split(/\s+/)[3].replace(/B$/, '')

  const loopFile = runWithPipe(
    ['sudo', 'losetup', '-o', partOffset, '--sizelimit', partLength,
    '--show', '-f', imageFile]
  ).replace(/\n+$/, '')

  sudo(['mkfs.fat', '-n', 'MAKESTACK', loopFile])
  run(['mkdir', '-p', mountPoint])
  sudo(['mount', loopFile, mountPoint, '-o', `uid=${username}`, '-o', `gid=${username}`])
  run(['sh', '-c', `cp -r ${bootfsPath('.')}/* ${mountPoint}`])
  sudo(['umount', mountPoint])
  run(['sudo', 'losetup', '-d', loopFile])
}

function loadJsonFile(filepath) {
  return JSON.parse(fs.readFileSync(filepath))
}

function saveJsonFile(filepath, obj) {
  fs.writeFileSync(filepath, JSON.stringify(obj))
}

function progress(message) {
  console.log(chalk.bold.magenta(message))
}

function modifyJsonFile(filepath, obj) {
  const packageJson = loadJsonFile(filepath)

  for (const [k, v] of Object.entries(obj)) {
    Object.assign(packageJson[k], v)
  }

  saveJsonFile(filepath, packageJson)
}

function defineUbuntuPackage(name, pkg) {
  return Object.assign({}, pkg, {
    version() {
      return ubuntuPackages[config('target.deb_arch')][name]['version']
    },
    url() {
      return ubuntuPackages[config('target.deb_arch')][name]['url']
    },
    sha256() {
      return ubuntuPackages[config('target.deb_arch')][name]['sha256']
    },
    changed() {
      return false
    }
  })
}

module.exports = {
  config,
  isNewerFile,
  isNewerDirContent,
  copyFile,
  copyFiles,
  assetPath,
  buildPath,
  bootfsPath,
  rootfsPath,
  isRebuilt,
  run,
  runWithPipe,
  applyPatch,
  sudo,
  mkdirp,
  buildFatImage,
  loadJsonFile,
  saveJsonFile,
  progress,
  find,
  modifyJsonFile,
  defineUbuntuPackage
}
