require 'net/http'
require 'json'

class OpenaiClient
  API_ENDPOINT = 'https://api.openai.com/v1/engines/davinci/completions'
  API_KEY = ENV['OPENAI_API_KEY']

  def self.generate_sub_tasks(main_task_description)
    uri = URI(API_ENDPOINT)
    header = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{API_KEY}"
    }
    body = {
      prompt: main_task_description,
      max_tokens: 50
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri, header)
    request.body = body.to_json

    response = http.request(request)

    Rails.logger.info "OpenAI API Request: #{request.body}"
    Rails.logger.info "OpenAI API Response Status: #{response.code}"
    Rails.logger.info "OpenAI API Response Body: #{response.body}"

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)['choices'].first['text'].strip
    else
      []
    end
  end
end
