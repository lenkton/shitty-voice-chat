# frozen_string_literal: true

class RoomJoiner
  def self.call(**params)
    new(**params).call
  end

  def initialize(room:, user:)
    @room = room
    @user = user
  end

  def call
    @user.rooms = [] if @user.rooms.any?

    @room.users << @user

    update_room_users_list
    update_join_leave_button

    Success.new({ room: @room })
  rescue ActiveRecord::RecordInvalid => e
    errors = e.record.errors.full_messages
    Failure.new(errors: errors)
  end

  private

  def update_room_users_list
    Turbo::StreamsChannel.broadcast_append_to(
      [@room, :users],
      partial: 'rooms/room_user',
      locals: { user: @user },
      target: :room_users
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
