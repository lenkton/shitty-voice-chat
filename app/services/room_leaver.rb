# frozen_string_literal: true

class RoomLeaver
  def self.call(**params)
    new(**params).call
  end

  def initialize(room:, user:)
    @room = room
    @user = user
  end

  def call
    @room.users.destroy(@user)

    update_room_users_list
    update_join_leave_button

    Success.new({ room: @room })
  end

  private

  def update_room_users_list
    Turbo::StreamsChannel.broadcast_remove_to(
      [@room, :users],
      target: "room_user_#{@user.id}"
    )
  end

  def update_join_leave_button
    Turbo::StreamsChannel.broadcast_replace_to(
      [@user, @room],
      partial: 'rooms/join_leave_button',
      locals: { user: @user, room: @room },
      target: :join_leave_button
    )
  end
end
