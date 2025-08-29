# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations

  # after_commit { broadcast_prepend_to :rooms }
  # after_commit { broadcast_replace_to "room_#{id}" }

  validates :name, uniqueness: true
end
