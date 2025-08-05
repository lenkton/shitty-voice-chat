class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

  def create
    @room = Room.build(room_params)

    if @room.save
      redirect_to @room
    else
      # TODO
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
