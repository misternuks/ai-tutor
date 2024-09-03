import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="logout"
export default class extends Controller {
  connect() {
    console.log("LogoutController connected");
  }

  clearStorage() {
    console.log("clearStorage action triggered");
    localStorage.removeItem('selectedCourse');
    localStorage.removeItem('selectedUnit');
    localStorage.removeItem('selectedLesson');
    // Optional:
    // localStorage.clear();
  }
}
