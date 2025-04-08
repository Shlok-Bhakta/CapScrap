import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Renting controller connected")
  }

  editRow(event) {
    const row = event.currentTarget.closest('tr')
    const rentingId = event.currentTarget.getAttribute('data-renting-id')

    if (!rentingId) {
      console.error('No renting ID found')
      return
    }

    // Show edit fields, hide text
    row.querySelectorAll('td').forEach(td => {
      const textSpan = td.querySelector('.quantity-text')
      const input = td.querySelector('input[type="number"]')
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
              data-action="click->renting#saveRow"
              data-renting-id="${rentingId}">
        Save
      </button>
      <button type="button"
              class="cancel-button bg-gray-500 hover:bg-gray-700 text-white rounded px-2 py-1"
              data-action="click->renting#cancelEdit">
        Cancel
      </button>
    `
  }

  saveRow(event) {
    const row = event.currentTarget.closest('tr')
    const rentingId = event.currentTarget.getAttribute('data-renting-id')

    if (!rentingId) {
      console.error('No renting ID found')
      return
    }

    const quantity = row.querySelector('input[name="quantity"]')?.value

    if (!quantity) {
      alert('Quantity is required')
      return
    }

    if (confirm('Are you sure you want to save these changes?')) {
      const token = document.querySelector('meta[name="csrf-token"]').content

      fetch(`/admin/dashboard/update_quantity?id=${rentingId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        },
        body: JSON.stringify({
          renting: {
            quantity: quantity
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
          throw new Error(data.error || 'Failed to update renting')
        }
      })
      .catch(error => {
        console.error('Error:', error)
        alert(error.message)
      })
    }
  }

  deleteRenting(event) {
    const rentingId = event.currentTarget.getAttribute('data-renting-id')
    
    if (!rentingId) {
      console.error('No renting ID found')
      return
    }

    if (confirm('Are you sure you want to delete this renting?')) {
      const token = document.querySelector('meta[name="csrf-token"]').content

      fetch(`/admin/dashboard/delete_renting?id=${rentingId}`, {
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
          throw new Error(data.error || 'Failed to delete renting')
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