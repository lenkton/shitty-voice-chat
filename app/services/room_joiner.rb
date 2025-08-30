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

    Success.new({ room: @room })
  rescue ActiveRecord::RecordInvalid => e
    errors = e.record.errors.full_messages
    Failure.new(errors: errors)
  end
end
