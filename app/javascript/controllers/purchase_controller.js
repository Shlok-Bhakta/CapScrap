import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["table"]

  connect() {
    console.log("Purchase controller connected")
  }

  editRow(event) {
    event.preventDefault()
    const row = event.currentTarget.closest('tr')
    const purchaseId = event.currentTarget.getAttribute('data-purchase-id')

    if (!purchaseId) {
      console.error('No purchase ID found')
      return
    }

    // Show edit fields, hide text
    row.querySelectorAll('td').forEach(td => {
      const textSpan = td.querySelector('[class$="-text"]')
      const input = td.querySelector('input, select')
      if (textSpan && input) {
        textSpan.classList.add('hidden')
        input.classList.remove('hidden')
      }
    })

    // Replace edit/delete buttons with save/cancel
    const actionsCell = row.querySelector('td:last-child')
    actionsCell.innerHTML = `
      <button type="button"
              class="save-button bg-green-500 hover:bg-green-700 text-white rounded px-2 py-1 mr-2"
              data-action="click->purchase#saveRow"
              data-purchase-id="${purchaseId}">
        Save
      </button>
      <button type="button"
              class="cancel-button bg-gray-500 hover:bg-gray-700 text-white rounded px-2 py-1"
              data-action="click->purchase#cancelEdit">
        Cancel
      </button>
    `
  }

  saveRow(event) {
    event.preventDefault()
    const row = event.currentTarget.closest('tr')
    const purchaseId = event.currentTarget.getAttribute('data-purchase-id')

    if (!purchaseId) {
      console.error('No purchase ID found')
      return
    }

    const quantity = row.querySelector('input[name="purchased_quantity"]')?.value

    if (!quantity) {
      alert('Quantity is required')
      return
    }

    if (confirm('Are you sure you want to save these changes?')) {
      const token = document.querySelector('meta[name="csrf-token"]').content

      fetch(`/purchases/${purchaseId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        },
        body: JSON.stringify({
          purchase: {
            purchased_quantity: quantity
          }
        })
      })
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok')
        }
        return response.json()
      })
      .then(data => {
        if (data.success) {
          window.location.reload()
        } else {
          throw new Error(data.error || 'Failed to update purchase')
        }
      })
      .catch(error => {
        console.error('Error:', error)
        alert(error.message)
      })
    }
  }

  deletePurchase(event) {
    event.preventDefault()
    const purchaseId = event.currentTarget.getAttribute('data-purchase-id')
    
    if (!purchaseId) {
      console.error('No purchase ID found')
      return
    }

    if (confirm('Are you sure you want to delete this purchase?')) {
      const token = document.querySelector('meta[name="csrf-token"]').content

      fetch(`/purchases/${purchaseId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        }
      })
      .then(response => {
        if (!response.ok) {
          return response.json().then(data => {
            throw new Error(data.error || 'Network response was not ok')
          })
        }
        return response.json()
      })
      .then(data => {
        if (data.success) {
          window.location.reload()
        } else {
          throw new Error(data.error || 'Failed to delete purchase')
        }
      })
      .catch(error => {
        console.error('Error:', error)
        alert(error.message)
      })
    }
  }

  cancelEdit(event) {
    event.preventDefault()
    window.location.reload()
  }
}