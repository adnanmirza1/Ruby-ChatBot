# frozen_string_literal: true

module Chatgpt
  class Api
    def initialize(prompt, model = 'gpt-3.5-turbo')
      @prompt = prompt
      @model = model
    end

    def fetch_response
      response = post_chatgpt_request

      response.dig('choices', 0, 'message', 'content')
    end

    private

    def post_chatgpt_request
      client = OpenAI::Client.new(access_token: ENV['ChatGPT_ACCESS_TOKEN'])

      client.chat(
        parameters: {
          model: @model,
          messages: [{ role: 'system', content: @prompt }]
        }
      )
    end
  end
end
