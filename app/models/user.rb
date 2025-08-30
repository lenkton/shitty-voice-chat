# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         #  :recoverable,
         :rememberable,
         :validatable

  has_many :participations, dependent: :destroy
  has_many :rooms, through: :participations
  has_many :messages, dependent: :restrict_with_exception
end
