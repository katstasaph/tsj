import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { FetchRequest } from '@rails/request.js'

// Connects to data-controller="sortable"
export default class extends Controller {

  static values = {
    url: String,
    test: String
  }

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      ghostClass: "sortable-ghost",
      chosenClass: "sortable-chosen",
      dragClass: "sortable-drag",
      onEnd: this.end.bind(this)
    })
  }

  async end(event) {
    const request = new FetchRequest('patch', `/reviews/${event.item.dataset.id}/move`, { query: {oldIndex: event.oldIndex, newIndex: event.newIndex}});
    const response = await request.perform()
  }

}