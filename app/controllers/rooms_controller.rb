# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :find_room, only: %i[show join leave]
  def index
    @rooms = Room.all
  end

  def show; end

  def create
    @room = Room.build(room_params)

    if @room.save
      flash[:notice] = 'Room has been successfully created'
      redirect_to @room
    else
      flash[:alert] = @room.errors.full_messages
      redirect_to rooms_path
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
    @room.users.destroy(current_user)

    render json: @room, status: :ok
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

  def find_room
    @room = Room.preload(:users).find(params[:id])
  end
end
