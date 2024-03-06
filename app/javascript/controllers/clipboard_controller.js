import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'

export default class extends Controller {
  
  static targets = [ "button" ];  
  async copy_html(event) {
    event.preventDefault();
    this.buttonTarget.innerText = "Copied!";
    navigator.clipboard.writeText(event.params.html);
  }
}