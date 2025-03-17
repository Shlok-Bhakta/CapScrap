import { Controller } from "@hotwired/stimulus"

// Handles the search functionality for tables
export default class extends Controller {
  search() {
    // Use debounce to avoid too many requests
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.form.requestSubmit()
    }, 300)
  }
}