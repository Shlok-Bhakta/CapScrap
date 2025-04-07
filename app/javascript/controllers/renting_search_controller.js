import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["userField", "itemField", "userSuggestions", "itemSuggestions"]

  connect() {
    console.log("Renting search controller connected")
    // Close suggestions when clicking outside
    document.addEventListener('click', (e) => {
      if (!this.element.contains(e.target)) {
        this.hideUserSuggestions()
        this.hideItemSuggestions()
      }
    })
  }

  searchUsers() {
    const query = this.userFieldTarget.value.trim()
    if (!query || query.length < 2) {
      this.hideUserSuggestions()
      return
    }

    const base = window.location.pathname.includes('/ta/') ? '/ta/dashboard' : '/admin/dashboard';
    fetch(`${base}/search_users?query=${encodeURIComponent(query)}`, {
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
      if (data.users && data.users.length > 0) {
        this.showUserSuggestions(data.users)
      } else {
        this.hideUserSuggestions()
      }
    })
    .catch(error => {
      console.error('Error:', error)
      this.hideUserSuggestions()
    })
  }

  searchItems() {
    const query = this.itemFieldTarget.value.trim()
    if (!query || query.length < 2) {
      this.hideItemSuggestions()
      return
    }

    const base = window.location.pathname.includes('/ta/') ? '/ta/dashboard' : '/admin/dashboard';
    fetch(`${base}/search_items?query=${encodeURIComponent(query)}`, {
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
        this.showItemSuggestions(data.items)
      } else {
        this.hideItemSuggestions()
      }
    })
    .catch(error => {
      console.error('Error:', error)
      this.hideItemSuggestions()
    })
  }

  selectUser(event) {
    const userDiv = event.currentTarget
    const fullName = userDiv.querySelector('.font-medium').textContent.trim()
    this.userFieldTarget.value = fullName
    this.hideUserSuggestions()
  }

  selectItem(event) {
    const itemDiv = event.currentTarget
    const description = itemDiv.querySelector('.font-medium').textContent.trim()
    this.itemFieldTarget.value = description
    this.hideItemSuggestions()
  }

  showUserSuggestions(users) {
    const suggestionsList = users.map(user => `
      <div class="p-2 hover:bg-gray-100 cursor-pointer" data-action="click->renting-search#selectUser">
        <div class="font-medium">${user.full_name}</div>
        <div class="text-sm text-gray-600">${user.email}</div>
      </div>
    `).join('')

    this.userSuggestionsTarget.innerHTML = suggestionsList
    this.userSuggestionsTarget.classList.remove('hidden')
  }

  showItemSuggestions(items) {
    const suggestionsList = items.map(item => `
      <div class="p-2 hover:bg-gray-100 cursor-pointer" data-action="click->renting-search#selectItem">
        <div class="font-medium">${item.description}</div>
        <div class="text-sm text-gray-600">${item.location} - ${item.category}</div>
      </div>
    `).join('')

    this.itemSuggestionsTarget.innerHTML = suggestionsList
    this.itemSuggestionsTarget.classList.remove('hidden')
  }

  hideUserSuggestions() {
    this.userSuggestionsTarget.classList.add('hidden')
    this.userSuggestionsTarget.innerHTML = ''
  }

  hideItemSuggestions() {
    this.itemSuggestionsTarget.classList.add('hidden')
    this.itemSuggestionsTarget.innerHTML = ''
  }
}