# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    message = Message.build(**message_params, user: current_user)
    if message.save
      head :no_content
    else
      render json: message.errors.full_messages, status: :unprocessable_content
    end
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :text)
  end
end
