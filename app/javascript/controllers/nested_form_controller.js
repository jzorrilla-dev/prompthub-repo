import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add() {
    const index = `${Date.now()}${Math.floor(Math.random() * 1000)}`
    const html = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", index)
    this.containerTarget.insertAdjacentHTML("beforeend", html)
  }

  remove(event) {
    event.currentTarget.closest(".result-fields").remove()
  }
}
