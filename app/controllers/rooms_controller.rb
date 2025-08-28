class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

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

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
