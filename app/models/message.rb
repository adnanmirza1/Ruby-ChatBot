class Message < ApplicationRecord
  enum writer: { ChatGPT: 0, User: 1 }

  belongs_to :user
end
