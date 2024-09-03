import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdowns"
export default class extends Controller {
  static targets = ["course", "unit", "lesson", "chatroomButton"]

  connect() {
    this.unitTarget.disabled = true;
    this.lessonTarget.disabled = true;
    this.chatroomButtonTarget.hidden = true;

    // Restore saved selections if any
    this.restoreSelections();
  }

  selectCourse() {
    const courseId = this.courseTarget.value;
    if (courseId) {
      // Save the selected course in local storage
      localStorage.setItem('selectedCourse', courseId);

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

      // Clear the saved selection if no course is selected
      localStorage.removeItem('selectedCourse');
      localStorage.removeItem('selectedUnit');
      localStorage.removeItem('selectedLesson');
    }
  }

  selectUnit() {
    const unitId = this.unitTarget.value;
    if (unitId) {
      // Save the selected unit in local storage
      localStorage.setItem('selectedUnit', unitId);

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

      // Clear the saved selection if no unit is selected
      localStorage.removeItem('selectedUnit');
      localStorage.removeItem('selectedLesson');
    }
  }

  selectLesson() {
    const lessonId = this.lessonTarget.value;
    if (lessonId) {
      // Save the selected lesson in local storage
      localStorage.setItem('selectedLesson', lessonId);

      this.chatroomButtonTarget.href = `/chatrooms?lesson_id=${lessonId}`; // Adjust href based on selected lesson
      this.chatroomButtonTarget.hidden = false;
    } else {
      this.chatroomButtonTarget.hidden = true;

      // Clear the saved selection if no lesson is selected
      localStorage.removeItem('selectedLesson');
    }
  }

  populateDropdown(target, data, defaultOptionText) {
    let options = data.map(item => `<option value="${item.id}">${item.name}</option>`).join('');
    options = `<option value=''>${defaultOptionText}</option>` + options;
    target.innerHTML = options;
    target.disabled = false;

    // Restore the selection if it exists
    const selectedValue = localStorage.getItem(target === this.unitTarget ? 'selectedUnit' : 'selectedLesson');
    if (selectedValue) {
      target.value = selectedValue;
      if (target === this.unitTarget) this.selectUnit();
      if (target === this.lessonTarget) this.selectLesson();
    }
  }

  resetDropdown(target, defaultOptionText) {
    target.innerHTML = `<option value=''>${defaultOptionText}</option>`;
    target.disabled = true;
  }

  restoreSelections() {
    const selectedCourse = localStorage.getItem('selectedCourse');
    if (selectedCourse) {
      this.courseTarget.value = selectedCourse;
      this.selectCourse();
    }
  }

  getCSRFToken() {
    return document.querySelector("meta[name='csrf-token']").getAttribute("content");
  }
}
