const path = require('path')
const { spawn } = require('child_process')

module.exports.ARDUINO_DIR = path.resolve(__dirname, 'deps/arduino-esp32')

module.exports.esptool = (args) =>{
  args = [path.resolve(__dirname, 'deps/esptool/esptool.py')].concat(args)

  return spawn('python3', args, {
    env: {
      PATH: process.env.PATH,
      PYTHONPATH: path.resolve(__dirname, 'deps/pyserial')
    }
  })
}
