require 'openai'

class OpenAiService

  VALID_MODELS = ['gpt-3.5-turbo', 'gpt-4', 'gpt-4o']

  def self.chat(message, context)
    client = OpenAI::Client.new

    system_message = context[:system_message]
    course_details = context[:course_details]
    unit_details = context[:unit_details]
    lesson_details = context[:lesson_details]
    previous_messages = context[:messages]

    messages = format_messages(previous_messages, message)

    model = Setting.find_by(key: 'openai_model')&.value
    model = VALID_MODELS.include?(model) ? model : 'gpt-3.5-turbo'

    response = client.chat(
      parameters: {
        model: model,
        messages: [
          { role: "system", content: system_message },
          { role: "user", content: format_context(course_details, unit_details, lesson_details) },
          { role: "assistant", content: ""},
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
