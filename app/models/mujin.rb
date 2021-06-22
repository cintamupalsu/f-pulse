class Mujin < ApplicationRecord
  belongs_to :user
  has_many :mujin_items, dependent: :destroy
  has_one_attached :image

  def display_image
    image.variant(resize_to_limit: [500,500])
  end
end
