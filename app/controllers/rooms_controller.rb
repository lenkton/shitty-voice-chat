# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :find_room, only: %i[show join leave]
  def index
    @rooms = Room.all
  end

  def show; end

  def create
    @room = Room.build(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room has been successfully created' }
      else
        format.html { redirect_to rooms_path, alert: @room.errors.full_messages }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'alerts',
            partial: 'alerts',
            locals: { messages: @room.errors.full_messages }
          )
        end
      end
    end
  end

  def join
    result = RoomJoiner.call(user: current_user, room: @room)

    if result.success?
      render json: result.data[:room], status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_content
    end
  end

  def leave
    result = RoomLeaver.call(user: current_user, room: @room)

    render json: result.data[:room], status: :ok
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

  def find_room
    # TODO: preload messages and their authors
    @room = Room.preload(:users).find(params[:id])
  end
end
