class RoleMaster < ApplicationRecord
    validates :content, presence: true, length: { maximum: 50 }
    validates :abrev, presence: true, length: { maximum: 5 }
    validates :description, presence: true, length: { maximum: 500 }
end
