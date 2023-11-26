require 'net/http'
require 'uri'
require 'json'

class OpenAiService
  def self.chat(message, context)
    uri = URI.parse("https://api.openai.com/v1/engines/davinci/completions")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{ENV['OPENAI_API_KEY']}"
    request.body = JSON.dump({
      prompt: format_prompt(message, context),
      max_tokens: 150
    })

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def self.format_prompt(message, context)
    # Extracting context details
    course_details = context[:course_details]
    unit_details = context[:unit_details]
    lesson_details = context[:lesson_details]
    previous_messages = context[:messages]

    # Formatting the context as a readable string
    context_string = "Course: #{course_details}\nUnit: #{unit_details}\nLesson: #{lesson_details}\n"

    # Adding previous chat messages to the context
    chat_history = previous_messages.map do |msg|
      "#{msg[:user]}: #{msg[:content]} (#{msg[:time].strftime('%Y-%m-%d %H:%M:%S')})"
    end.join("\n")

    # Combining everything into a single prompt
    "#{context_string}\nChat History:\n#{chat_history}\n\nUser: #{message}\nAI:"
  end

end
