class MessagesController < ApplicationController
  def index
    @messages = current_user.messages.order(created_at: :asc)
    @message = Message.new
  end

  def create
    @message = current_user.messages.create(message_params.merge(writer: :User))
    chatgpt_response = Chatgpt::Api.new(@message.body).fetch_response
    current_user.messages.create(body: chatgpt_response, writer: :ChatGPT)
    
    redirect_to root_path
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
