import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { interval: { type: Number, default: 3000 } }

  connect() {
    this.startReloading()
  }

  disconnect() {
    this.stopReloading()
  }

  startReloading() {
    this.timer = setInterval(() => {
      window.location.reload()
    }, this.intervalValue)
  }

  stopReloading() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }
}
