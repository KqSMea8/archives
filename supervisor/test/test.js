const assert = require('power-assert')
const nock = require('nock')
const fs = require('fs')
const os = require('os')
const sinon = require('sinon')
const path = require('path')

const deviceId = 'Uz3GDcfqQ0axGQ70p5x30asCzjT0bLOumk-YdeG0'
const deviceSecret = 'MsK91P2I6kVfFKdHXPbe.UEySJuwZuuNiLECQqnh'
process.env.MAKESTACK_DEVICE_TYPE = 'raspberrypi3'
process.env.RUNTIME_MODULE = path.resolve(__dirname, '../../runtime')

const serverURL = 'http://test-server'

describe('Supervisor', function () {
  beforeEach(function () {
    const adapter = 'http'
    const osVersion = 'c'
    const appVersion = '9'
    this.heartbeatInterval = 5
    this.now = new Date('2017-11-26T09:30:00Z')

    this.clock = sinon.useFakeTimers(this.now.getTime())

    this.heartbeatRequest = nock(serverURL)
      .post('/api/v1/smms', () => true)
      .reply(200, Buffer.from([
        // A SMMS payload.
        0x10, 0x9d, 0x01, 0x11, 0x01, 0x39, 0x13, 0x40, 0x34, 0x30, 0x39, 0x30, 0x35, 0x63, 0x33, 0x33, 0x61, 0x36, 0x39, 0x37, 0x62, 0x33, 0x31, 0x61, 0x62, 0x31, 0x31, 0x61, 0x30, 0x61, 0x37, 0x32, 0x38, 0x62, 0x32, 0x36, 0x32, 0x32, 0x62, 0x64, 0x34, 0x63, 0x64, 0x33, 0x62, 0x33, 0x30, 0x33, 0x38, 0x66, 0x63, 0x63, 0x65, 0x37, 0x62, 0x35, 0x32, 0x31, 0x62, 0x32, 0x30, 0x39, 0x33, 0x61, 0x65, 0x32, 0x35, 0x61, 0x33, 0x32, 0x34, 0x38, 0x07, 0x14, 0x32, 0x30, 0x31, 0x37, 0x2d, 0x31, 0x31, 0x2d, 0x32, 0x36, 0x54, 0x30, 0x39, 0x3a, 0x33, 0x30, 0x3a, 0x34, 0x32, 0x5a, 0x06, 0x40, 0x36, 0x32, 0x38, 0x30, 0x66, 0x36, 0x30, 0x39, 0x35, 0x37, 0x63, 0x63, 0x30, 0x61, 0x34, 0x32, 0x33, 0x37, 0x66, 0x36, 0x32, 0x63, 0x32, 0x62, 0x66, 0x38, 0x65, 0x38, 0x30, 0x38, 0x62, 0x63, 0x31, 0x33, 0x33, 0x66, 0x39, 0x62, 0x64, 0x33, 0x37, 0x31, 0x33, 0x61, 0x38, 0x38, 0x33, 0x31, 0x35, 0x38, 0x38, 0x34, 0x36, 0x38, 0x61, 0x63, 0x35, 0x61, 0x39, 0x38, 0x63, 0x64, 0x61, 0x63
      ]))

    this.appImageRequest = nock(serverURL)
      .get(`/api/v1/images/app/${deviceId}/${appVersion}`)
      .reply(200, Buffer.from([
        // A .zip file with start.js: console.log("I am a app!")
        0x50, 0x4b, 0x03, 0x04, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00, 0xce, 0x93, 0x7a, 0x4b, 0xc7, 0x10, 0xd0, 0x39, 0x34, 0x00, 0x00, 0x00, 0x34, 0x00, 0x00, 0x00, 0x08, 0x00, 0x1c, 0x00, 0x73, 0x74, 0x61, 0x72, 0x74, 0x2e, 0x6a, 0x73, 0x55, 0x54, 0x09, 0x00, 0x03, 0xb4, 0x89, 0x1a, 0x5a, 0xb6, 0x89, 0x1a, 0x5a, 0x75, 0x78, 0x0b, 0x00, 0x01, 0x04, 0xf5, 0x01, 0x00, 0x00, 0x04, 0x14, 0x00, 0x00, 0x00, 0x70, 0x72, 0x6f, 0x63, 0x65, 0x73, 0x73, 0x2e, 0x73, 0x65, 0x6e, 0x64, 0x28, 0x7b, 0x20, 0x74, 0x79, 0x70, 0x65, 0x3a, 0x20, 0x27, 0x6c, 0x6f, 0x67, 0x27, 0x2c, 0x20, 0x62, 0x6f, 0x64, 0x79, 0x3a, 0x20, 0x27, 0x49, 0x20, 0x61, 0x6d, 0x20, 0x61, 0x6e, 0x20, 0x61, 0x70, 0x70, 0x21, 0x27, 0x20, 0x7d, 0x29, 0x0a, 0x50, 0x4b, 0x01, 0x02, 0x1e, 0x03, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00, 0xce, 0x93, 0x7a, 0x4b, 0xc7, 0x10, 0xd0, 0x39, 0x34, 0x00, 0x00, 0x00, 0x34, 0x00, 0x00, 0x00, 0x08, 0x00, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0xa4, 0x81, 0x00, 0x00, 0x00, 0x00, 0x73, 0x74, 0x61, 0x72, 0x74, 0x2e, 0x6a, 0x73, 0x55, 0x54, 0x05, 0x00, 0x03, 0xb4, 0x89, 0x1a, 0x5a, 0x75, 0x78, 0x0b, 0x00, 0x01, 0x04, 0xf5, 0x01, 0x00, 0x00, 0x04, 0x14, 0x00, 0x00, 0x00, 0x50, 0x4b, 0x05, 0x06, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x4e, 0x00, 0x00, 0x00, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00
      ]))

    const appDir = path.resolve(os.tmpdir(), 'makestack-supervisor-test-app')
    if (!fs.existsSync(appDir)) {
      fs.mkdirSync(appDir)
    }

    const Supervisor = require('..')
    this.instance = new Supervisor({
      appDir,
      adapter: {
        name: adapter,
        url: serverURL
      },
      osType: 'mock',
      deviceType: 'raspberrypi3',
      deviceId: deviceId,
      deviceSecret: deviceSecret,
      debugMode: true,
      testMode: true,
      osVersion,
      heartbeatInterval: this.heartbeatInterval
    })
  })

  afterEach(function () {
    this.clock.restore()
  })

  it('generates a heartbeat request', function (done) {
    this.instance.start().then(() => {
      assert.strictEqual(this.heartbeatRequest.isDone(), true)
      this.instance.waitForApp().then(log => {
        if (log.includes('I am an app!')) {
          done()
        }
      })
    })
  })
})
