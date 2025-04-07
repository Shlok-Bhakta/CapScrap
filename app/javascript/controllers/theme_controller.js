import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "icon" ]

  connect() {
    this.initializeTheme();
  }

  initializeTheme() {
    const savedMode = localStorage.getItem('display-mode') || this.detectDefaultMode();
    this.applyMode(savedMode, false); // Apply without saving again initially
  }

  detectDefaultMode() {
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    } else {
      return 'light';
    }
  }

  toggle() {
    const currentMode = localStorage.getItem('display-mode') || 'light';
    let nextMode;

    if (currentMode === 'light') {
      nextMode = 'dark';
    } else if (currentMode === 'dark') {
      // Cycle through light -> dark -> high-contrast -> light
      // Adjust this logic if you don't have/want high-contrast
      nextMode = 'high-contrast';
    } else { // high-contrast
      nextMode = 'light';
    }

    this.applyMode(nextMode);
  }

  applyMode(mode, save = true) {
    document.documentElement.classList.remove('dark', 'high-contrast');

    if (mode === 'dark') {
      document.documentElement.classList.add('dark');
    } else if (mode === 'high-contrast') {
      document.documentElement.classList.add('high-contrast');
    }
    // 'light' mode has no specific class, it's the default

    if (save) {
      localStorage.setItem('display-mode', mode);
    }
    this.updateIcon(mode);
  }

  updateIcon(mode) {
    if (!this.hasIconTarget) return; // Guard clause if target isn't found

    let iconUrl;
    if (mode === 'light') {
      iconUrl = 'https://api.iconify.design/material-symbols:clear-day-rounded.svg';
    } else if (mode === 'dark') {
      iconUrl = 'https://api.iconify.design/material-symbols:dark-mode.svg';
    } else { // high-contrast
      iconUrl = 'https://api.iconify.design/material-symbols:eye-tracking.svg';
    }
    this.iconTarget.src = iconUrl;
  }
} 