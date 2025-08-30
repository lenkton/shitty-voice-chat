# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    message = Message.build(**message_params, user: current_user)
    respond_to do |format|
      if message.save
        format.json { head :no_content }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'chat_form',
            partial: 'rooms/chat_form',
            locals: { room: message.room }
          )
        end
      else
        format.json { render json: message.errors.full_messages, status: :unprocessable_content }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'alerts',
            partial: 'alerts',
            locals: { messages: message.errors.full_messages }
          )
        end
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :text)
  end
end
