# config/initializers/openai.rb
require 'openai'

OpenAI.configure do |config|
  config.access_token = OPENAI_API_KEY
  # Add other configurations if necessary
end
