import { Controller } from "@hotwired/stimulus"

// Registers this controller as "item" with stimulus
export default class extends Controller {
  static targets = [ "table", "newRow" ]
  static values = {
    itemId: String
  }

  connect() {
    // Called when controller connects
    console.log("Item controller connected")
  }

  addNewRow(event) {
    event.preventDefault()
    const newRow = this.newRowTarget.content.cloneNode(true)
    this.tableTarget.querySelector('tbody').prepend(newRow)
  }

  editRow(event) {
    event.preventDefault()
    const row = event.currentTarget.closest('tr')
    const itemId = event.currentTarget.getAttribute('data-item-id')

    if (!itemId) {
      console.error('No item ID found for edit')
      return
    }

    console.log('Editing item:', itemId) // Debug log

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
              data-action="click->item#saveRow"
              data-item-id="${itemId}">
        Save
      </button>
      <button type="button"
              class="cancel-button bg-gray-500 hover:bg-gray-700 text-white rounded px-2 py-1"
              data-action="click->item#cancelEdit">
        Cancel
      </button>
    `
  }

  saveRow(event) {
    event.preventDefault()
    const row = event.currentTarget.closest('tr')
    const itemId = event.currentTarget.getAttribute('data-item-id')

    if (!itemId) {
      console.error('No item ID found')
      return
    }

    console.log('Saving item:', itemId) // Debug log
    const description = row.querySelector('input[name="description"]')?.value
    const location = row.querySelector('input[name="location"]')?.value
    const categoryId = row.querySelector('select[class*="category-select"]')?.value

    if (!description || !location || !categoryId) {
      alert('Description, Location, and Category are required fields')
      return
    }

    if (confirm('Are you sure you want to save these changes?')) {
      const token = document.querySelector('meta[name="csrf-token"]').content
      
      fetch(`/admin/dashboard/update_item`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        },
        body: JSON.stringify({
          item: {
            id: itemId,
            description: description,
            location: location,
            category_id: categoryId
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
          throw new Error(data.error || 'Failed to update item')
        }
      })
      .catch(error => {
        console.error('Error:', error)
        alert(error.message)
      })
    }
  }

  saveNewRow(event) {
    console.log("saveNewRow")
    event.preventDefault()
    const form = event.target.closest('form')
    const description = form.querySelector('input[name="description"]').value
    const location = form.querySelector('input[name="location"]').value
    const categoryId = form.querySelector('select[name="category_id"]').value

    if (!description || !location) {
      alert('Description and Location are required fields')
      return
    }

    const token = document.querySelector('meta[name="csrf-token"]').content

    fetch('/admin/dashboard/create_item', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': token,
        'Accept': 'application/json'
      },
      body: JSON.stringify({
        item: {
          description: description,
          location: location,
          category_id: categoryId
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
        throw new Error(data.error || 'Failed to create item')
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert(error.message)
    })
  }

  deleteRow(event) {
    event.preventDefault()
    const itemId = event.currentTarget.getAttribute('data-item-id')
    
    if (!itemId) {
      console.error('No item ID found')
      return
    }

    console.log('Deleting item:', itemId) // Debug log
    if (confirm('Are you sure you want to delete this item?')) {
      const token = document.querySelector('meta[name="csrf-token"]').content

      fetch(`/admin/dashboard/delete_item?id=${itemId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        }
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
          throw new Error(data.error || 'Failed to delete item')
        }
      })
      .catch(error => {
        console.error('Error:', error)
        alert(error.message)
      })
    }
  }

  cancelNewRow(event) {
    event.preventDefault()
    event.target.closest('tr').remove()
  }

  cancelEdit(event) {
    event.preventDefault()
    window.location.reload()
  }
}