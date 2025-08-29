# frozen_string_literal: true

class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # after_commit { broadcast_refresh_to "room_#{room_id}" }
  broadcasts_to :room

  validates :user_id, uniqueness: { message: 'can join only one room at a time' }
end
