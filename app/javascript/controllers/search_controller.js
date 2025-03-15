import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static debounceTime = 300

  search(event) {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    this.timeout = setTimeout(() => {
      event.target.form.requestSubmit()
    }, this.constructor.debounceTime)
  }
}