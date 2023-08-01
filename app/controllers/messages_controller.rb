class MessagesController < ApplicationController
  def index
    @messages = current_user.messages.order(created_at: :asc)
    @message = Message.new
  end

  def create
    @message = current_user.messages.new(message_params.merge(writer: :User))

    if @message.save
      respond_to do |format|
        chatgpt_response = Chatgpt::Api.new(@message.body).fetch_response
        @chatgpt_message = current_user.messages.create(body: chatgpt_response, writer: :ChatGPT)

        format.html { redirect_to root_path }
        format.js
      end
    else
      redirect_to root_path, notice: @message.errors.full_messages
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
