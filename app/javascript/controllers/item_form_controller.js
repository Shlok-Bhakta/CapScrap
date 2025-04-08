import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="item-form"
export default class extends Controller {
  static targets = ["description", "location", "category"]

  connect() {
    console.log("ItemForm controller connected")
  }

  // Handle item creation
  createItem(event) {
    event.preventDefault()
    
    // Validate inputs
    if (!this.descriptionTarget.value || !this.locationTarget.value || !this.categoryTarget.value) {
      alert("Please fill in all fields")
      return
    }
    
    // Create form data
    const formData = new FormData()
    formData.append('item[description]', this.descriptionTarget.value)
    formData.append('item[location]', this.locationTarget.value)
    formData.append('item[category_id]', this.categoryTarget.value)
    
    // Get CSRF token
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    
    // Send request to create item
    fetch('/admin/dashboard/create_item', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      body: formData
    })
    .then(response => {
      if (response.ok) {
        // Clear form
        this.descriptionTarget.value = ''
        this.locationTarget.value = ''
        this.categoryTarget.value = ''
        
        // Reload to show the new item
        window.location.reload()
      } else {
        throw new Error('Failed to create item')
      }
    })
    .catch(error => {
      console.error('Error creating item:', error)
      const event = new CustomEvent('item-form:create-error', { 
        detail: error,
        bubbles: true 
      })
      this.element.dispatchEvent(event)
      alert('Failed to create item. Please try again.')
    })
  }
} 