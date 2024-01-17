require 'net/http'
require 'json'

class OpenaiClient
  API_ENDPOINT = 'https://api.openai.com/v1/chat/completions'
  API_KEY = ENV['OPENAI_API_KEY']

  def self.generate_sub_tasks(main_task_description)
    uri = URI(API_ENDPOINT)
    header = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{API_KEY}"
    }
    body = {
      model: 'gpt-3.5-turbo',
      messages: [
        {
          "role": "system",
          "content": "次のメインタスクに対して必要なサブタスクのリストを提案してください。サブタスクの内容は20文字以内の簡単な文字列を、json形式の配列で返してください。"
        },
        {
          "role": "user",
          "content": main_task_description
        }
      ]
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
      response_data = JSON.parse(response.body)
      if response_data['choices'] && response_data['choices'].first['message']
        response_data['choices'].first['message']['content'].strip
      else
        []
      end
    else
      []
    end
  end
end
