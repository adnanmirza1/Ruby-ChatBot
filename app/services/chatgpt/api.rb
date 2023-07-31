# frozen_string_literal: true

module Chatgpt
  class Api
    def initialize(prompt, model = 'gpt-3.5-turbo')
      @prompt = prompt
      @model = model
    end

    def fetch_response
      response = post_chatgpt_request

      return response.dig('choices', 0, 'message', 'content') if response['choices'].present?

      return response.dig('error', 'message') if response['error'].present?
    end

    private

    def post_chatgpt_request
      client = OpenAI::Client.new(access_token: ENV['ChatGPT_ACCESS_TOKEN'])
    
      messages_data = Message.all.order(:created_at).pluck(:writer, :body)
    
      messages = messages_data.map do |writer, body|
        { role: (writer == "ChatGPT" ? "assistant" : "user"), content: body.to_s }
      end
    
      messages << { role: 'user', content: @prompt.to_s }
    
      client.chat(
        parameters: {
          model: @model,
          messages: messages, # Pass the messages array directly
        }
      )
    end
  end
end
