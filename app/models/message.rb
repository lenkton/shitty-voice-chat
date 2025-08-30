# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit :append_to_room_chat

  private

  def append_to_room_chat
    broadcast_append_to(
      room,
      partial: 'rooms/chat_message',
      locals: { message: self },
      target: :chat
    )
  end
end
