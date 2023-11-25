import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdowns"
export default class extends Controller {
  static targets = ["course", "unit", "lesson", "chatroomButton"]

  connect() {
    // Initial state when the page loads
    this.unitTarget.disabled = true;
    this.lessonTarget.disabled = true;
    this.chatroomButtonTarget.disabled = true;
  }

  selectCourse() {
    const courseId = this.courseTarget.value;
    if (courseId) {
      fetch(`/courses/${courseId}/units.json`, {
        headers: {
          'X-CSRF-Token': this.getCSRFToken(),
          'Accept': 'application/json'
        }
      })
        .then(response => response.json())
        .then(data => {
          let options = data.map(unit => `<option value="${unit.id}">${unit.name}</option>`).join('');
          options = `<option value=''>Select Unit</option>` + options;
          this.unitTarget.innerHTML = options;
        });
    }
  }

  selectUnit() {
    const unitId = this.unitTarget.value;
    if (unitId) {
      fetch(`/courses/units/${unitId}/lessons.js`, {
        headers: {
          'X-CSRF-Token': this.getCSRFToken(),
          'Accept': 'text/javascript'

        }
      })
        .then(response => response.text())
        .then(data => {
          this.lessonTarget.innerHTML = data;
          this.lessonTarget.disabled = false;
        });
    }
  }

  selectLesson() {
    const lessonId = this.lessonTarget.value;
    if (lessonId) {
      // Optionally, you might fetch lesson's chatrooms here, or just enable the chatroom button
      this.chatroomButtonTarget.disabled = false;
      this.chatroomButtonTarget.href = `/lessons/${lessonId}/chatrooms`;
    }
  }

  getCSRFToken() {
    return document.querySelector("meta[name='csrf-token']").getAttribute("content");
  }
}
