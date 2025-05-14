import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  confirm(event) {
    if (!window.confirm("¿Estás seguro?")) {
      event.preventDefault()
    }
  }
}