class Mujin < ApplicationRecord
  belongs_to :user
  has_many :mujin_items
end