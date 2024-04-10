import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { blurbers: String };
  
  async blurber_confirmation(event) { 
    if (!this.blurbersValue) {
      return;
    }
    const blurbersMsg = `Are you sure? The following writers are blurbing: ${this.blurbersValue}`;
    if (!window.confirm(blurbersMsg)) {
      event.preventDefault();
    }
  }
  
}