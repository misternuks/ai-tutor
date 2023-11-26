import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdowns"
export default class extends Controller {
  static targets = ["course", "unit", "lesson", "chatroomButton"]

  connect() {
    // Initial state when the page loads
    this.unitTarget.disabled = true;
    this.lessonTarget.disabled = true;
    this.chatroomButtonTarget.hidden = true;
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
          console.log(data);
          let options = data.map(unit => `<option value="${unit.id}">${unit.name}</option>`).join('');
          options = `<option value=''>Select Unit</option>` + options;
          this.unitTarget.innerHTML = options;
          this.unitTarget.disabled = false;
        });
    }
  }

  selectUnit() {
    const unitId = this.unitTarget.value;
  const courseId = this.courseTarget.value; // Get the selected course ID
  if (unitId) {
    fetch(`/courses/${courseId}/lessons?unit_id=${unitId}.json`, { // Updated URL
      headers: {
        'X-CSRF-Token': this.getCSRFToken(),
          'Accept': 'application/json'

        }
      })
        .then(response => response.json())
        .then(data => {
          console.log(data);
          let options = data.map(lesson => `<option value="${lesson.id}">${lesson.name}</option>`).join('');
          options = `<option value=''>Select Lesson</option>` + options;
          this.lessonTarget.innerHTML = options;
          this.lessonTarget.disabled = false;
        });
    }
  }

  selectLesson() {
    const lessonId = this.lessonTarget.value;
    const unitId = this.unitTarget.value; // Get the selected unit ID
    const courseId = this.courseTarget.value; // Get the selected course ID
    if (lessonId) {
      fetch(`/courses/${courseId}/lessons?unit_id=${unitId}.json`, { // Updated URL and format
        headers: {
          'X-CSRF-Token': this.getCSRFToken(),
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        console.log(data);
        // Process the JSON data to update the chatroomButton or other elements as needed
        // For example, updating the href for the chatroom button:
        if(data.length > 0) {
          this.chatroomButtonTarget.href = `/courses/${courseId}/chatrooms?lesson_id=${lessonId}/chatrooms`;
          this.chatroomButtonTarget.hidden = false;
        }
      });
    }
  }

  getCSRFToken() {
    return document.querySelector("meta[name='csrf-token']").getAttribute("content");
  }
}
