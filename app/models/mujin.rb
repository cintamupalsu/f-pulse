class Mujin < ApplicationRecord
  belongs_to :user
  has_many :mujin_items, dependent: :destroy
  has_one_attached :image
end
