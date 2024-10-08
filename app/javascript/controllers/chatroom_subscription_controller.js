import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static values = { chatroomId: Number, currentUserId: Number }
  static targets = ["messages"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      { received: data => this.#insertMessageAndScrollDown(data)

    }
    )
    console.log(`Subscribe to the chatroom with the id ${this.chatroomIdValue}.`)
    this.scrollToBottomOnLoad();
    if (this.chatroomFullValue) {
      this.#disableChat()
    }
  }

  scrollToBottomOnLoad() {
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight);
  }

  #insertMessageAndScrollDown(data) {
    const currentUserIsSender = this.currentUserIdValue === data.sender_id
    const messageElement = this.#buildMessageElement(currentUserIsSender, data.message)
    this.messagesTarget.insertAdjacentHTML("beforeend", messageElement)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)

    if (data.chatroom_full) {
      this.#disableChat()
    }
  }

  #disableChat() {
    if (this.submitTarget) {
      this.submitTarget.disabled = true
    }
    if (this.inputTarget) {
      this.inputTarget.disabled = true
    }
    const message = document.createElement("p")
    message.classList.add("text-danger")
    message.textContent = "This conversation has reached its maxium length. Please make a new one."
    this.inputTarget.parentElement.appendChild(message)
  }

  #buildMessageElement(currentUserIsSender, message) {
    return `
      <div class="message-row d-flex ${this.#justifyClass(currentUserIsSender)}">
        <div class="${this.#userStyleClass(currentUserIsSender)}">
          ${message}
        </div>
      </div>
    `
  }

  #justifyClass(currentUserIsSender) {
    return currentUserIsSender ? "justify-content-end" : "justify-content-start"
  }

  #userStyleClass(currentUserIsSender) {
    return currentUserIsSender ? "sender-style" : "receiver-style"
  }

  resetForm(event) {
    event.target.reset()
  }

  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }
}
