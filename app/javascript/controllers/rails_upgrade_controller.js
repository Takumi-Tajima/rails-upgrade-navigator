import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "links", "railsdiffLink"]
  static values = { currentVersion: String }

  connect() {
    this.updateLinks()
  }

  updateLinks() {
    const targetVersion = this.selectTarget.value

    if (targetVersion) {
      const railsdiffUrl = `https://railsdiff.org/${this.currentVersionValue}/${targetVersion}`
      this.railsdiffLinkTarget.href = railsdiffUrl
      this.railsdiffLinkTarget.textContent = railsdiffUrl
      this.linksTarget.classList.remove("hidden")
    } else {
      this.linksTarget.classList.add("hidden")
    }
  }
}
