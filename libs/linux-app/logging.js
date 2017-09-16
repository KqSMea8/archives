module.exports = class {
  constructor() {
    this.log = "";
  }

  get globals() {
    return {
      print: this.print.bind(this)
    };
  }

  reset() {
    this.log = "";
  }

  getLog() {
    let log = this.log;
    this.log = "";
    return log;
  }

  print(message) {
    console.info("I " + message);
    this.log += message + "\n";
  }
}