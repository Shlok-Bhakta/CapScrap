import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.applyScaling();
  }

  applyScaling() {
    const scale = localStorage.getItem("font-scale") || "1.5"; // Default scale
    document.querySelectorAll("[data-font-size]").forEach((el) => {
      const baseSize = parseFloat(el.dataset.fontSize) || 16;
      el.style.fontSize = `${baseSize * scale}px`;
    });
  }

  updateScale(event) {
    const newScale = event.target.value;
    localStorage.setItem("font-scale", newScale);
    this.applyScaling();
  }
}

// Ensure scaling is reapplied after Turbo updates the DOM
document.addEventListener("turbo:load", () => {
  document.querySelectorAll("[data-controller='font']").forEach((el) => {
    el.dispatchEvent(new Event("connect"));
  });
});

document.addEventListener("turbo:frame-load", () => {
  document.querySelectorAll("[data-controller='font']").forEach((el) => {
    el.dispatchEvent(new Event("connect"));
  });
});