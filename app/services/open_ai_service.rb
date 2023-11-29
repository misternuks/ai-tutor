require 'openai'

class OpenAiService
  def self.chat(message, context)
    client = OpenAI::Client.new

    system_message = context[:system_message]
    course_details = context[:course_details]
    unit_details = context[:unit_details]
    lesson_details = context[:lesson_details]
    previous_messages = context[:messages]

    messages = format_messages(previous_messages, message)

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # You can change the model as needed
        messages: [
          { role: "system", content: system_message },
          { role: "user", content: format_context(course_details, unit_details, lesson_details) },
          *messages
        ]
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  def self.format_context(course_details, unit_details, lesson_details)
    "Course: #{course_details}\nUnit: #{unit_details}\nLesson: #{lesson_details}"
  end

  def self.format_messages(previous_messages, current_message)
    previous_messages.map do |msg|
      { role: "user", content: "#{msg[:user]}: #{msg[:content]}" }
    end + [{ role: "user", content: "User: #{current_message}" }]
  end
end
