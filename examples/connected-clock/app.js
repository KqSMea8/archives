const AQM0802A = plugin('aqm0802a')
const HDC1000 = plugin('hdc1000')

const display = new AQM0802A()
const sensor = new HDC1000()
let displayMessages = []

Store.onChange('messages', newMessages => {
  displayMessages = JSON.parse(newMessages)
})

Timer.loop(async () => {
  if (displayMessages.length === 0) {
    await Timer.sleep(3)
    return
  }

  for (const text of displayMessages) {
    display.update(text)
    await Timer.sleep(3)
  }
})

Timer.interval(5, () => {
  Event.publish('t', sensor.read_temperature())
  Event.publish('h', sensor.read_humidity())
})
