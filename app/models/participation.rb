# frozen_string_literal: true

class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_destroy_commit :remove_user_from_room_list, :after_destroy_update_user_button

  validates :user_id, uniqueness: { message: 'can join only one room at a time' }

  private

  def remove_user_from_room_list
    broadcast_remove_to([room, :users], target: "room_user_#{user.id}")
  end

  def update_user_button
    broadcast_replace_to([user, room], partial: 'rooms/join_leave_button',
                                       locals: { user: user, room: room },
                                       target: :join_leave_button)
  end
  # because of the rails implementation of the callbacks
  # we cannot call the same method from two different after_*_commit
  alias after_create_update_user_button update_user_button
  alias after_destroy_update_user_button update_user_button
end
