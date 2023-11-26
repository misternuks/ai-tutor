import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdowns"
export default class extends Controller {
  static targets = ["course", "unit", "lesson", "chatroomButton"]

  connect() {
    this.unitTarget.disabled = true;
    this.lessonTarget.disabled = true;
    this.chatroomButtonTarget.hidden = true;
  }

  selectCourse() {
    const courseId = this.courseTarget.value;
    if (courseId) {
      fetch(`/units.json?course_id=${courseId}`, { // Adjusted to fetch units for a course
        headers: {
          'X-CSRF-Token': this.getCSRFToken(),
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => this.populateDropdown(this.unitTarget, data, 'Select Unit'));
    } else {
      this.resetDropdown(this.unitTarget, 'Select Unit');
      this.resetDropdown(this.lessonTarget, 'Select Lesson');
      this.chatroomButtonTarget.hidden = true;
    }
  }

  selectUnit() {
    const unitId = this.unitTarget.value;
    if (unitId) {
      fetch(`/lessons.json?unit_id=${unitId}`, { // Adjusted to fetch lessons for a unit
        headers: {
          'X-CSRF-Token': this.getCSRFToken(),
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => this.populateDropdown(this.lessonTarget, data, 'Select Lesson'));
    } else {
      this.resetDropdown(this.lessonTarget, 'Select Lesson');
      this.chatroomButtonTarget.hidden = true;
    }
  }

  selectLesson() {
    const lessonId = this.lessonTarget.value;
    if (lessonId) {
      this.chatroomButtonTarget.href = `/chatrooms?lesson_id=${lessonId}`; // Adjust href based on selected lesson
      this.chatroomButtonTarget.hidden = false;
    } else {
      this.chatroomButtonTarget.hidden = true;
    }
  }

  populateDropdown(target, data, defaultOptionText) {
    let options = data.map(item => `<option value="${item.id}">${item.name}</option>`).join('');
    options = `<option value=''>${defaultOptionText}</option>` + options;
    target.innerHTML = options;
    target.disabled = false;
  }

  resetDropdown(target, defaultOptionText) {
    target.innerHTML = `<option value=''>${defaultOptionText}</option>`;
    target.disabled = true;
  }

  getCSRFToken() {
    return document.querySelector("meta[name='csrf-token']").getAttribute("content");
  }
}
