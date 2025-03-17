import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["itemField", "newItemFields", "suggestions"]

  connect() {
    console.log("Purchase search controller connected")
    // Close suggestions when clicking outside
    document.addEventListener('click', (e) => {
      if (!this.element.contains(e.target)) {
        this.hideSuggestions()
      }
    })
  }

  searchItems() {
    const query = this.itemFieldTarget.value.trim()
    if (!query || query.length < 2) {
      this.hideNewItemFields()
      this.hideSuggestions()
      return
    }

    fetch(`/admin/dashboard/search_items?query=${encodeURIComponent(query)}`, {
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.error) {
        console.error('Error:', data.error)
        return
      }

      // Show suggestions if we have any matches
      if (data.items && data.items.length > 0) {
        this.showSuggestions(data.items)
        
        // Only show new item fields if no exact match is found
        const hasExactMatch = data.items.some(item => 
          item.description.toLowerCase() === query.toLowerCase()
        )
        
        if (!hasExactMatch) {
          this.showNewItemFields()
        } else {
          this.hideNewItemFields()
        }
      } else {
        this.hideSuggestions()
        this.showNewItemFields() // Show new item fields if no suggestions
      }
    })
    .catch(error => {
      console.error('Error:', error)
      this.hideNewItemFields()
      this.hideSuggestions()
    })
  }

  selectItem(event) {
    const itemDiv = event.currentTarget
    const description = itemDiv.querySelector('.font-medium').textContent.trim()
    this.itemFieldTarget.value = description
    this.hideSuggestions()
    this.hideNewItemFields()
  }

  showSuggestions(items) {
    const suggestionsList = items.map(item => `
      <div class="p-2 hover:bg-gray-100 cursor-pointer" data-action="click->purchase-search#selectItem">
        <div class="font-medium">${item.description}</div>
        <div class="text-sm text-gray-600">${item.location} - ${item.category}</div>
      </div>
    `).join('')

    this.suggestionsTarget.innerHTML = suggestionsList
    this.suggestionsTarget.classList.remove('hidden')
  }

  showNewItemFields() {
    this.newItemFieldsTarget.classList.remove('hidden')
  }

  hideNewItemFields() {
    this.newItemFieldsTarget.classList.add('hidden')
  }

  hideSuggestions() {
    this.suggestionsTarget.classList.add('hidden')
    this.suggestionsTarget.innerHTML = ''
  }
}