class RoleMaster < ApplicationRecord
    validates :content, presence: true, length: { maximum: 50 }
    validates :abrev, presence: true, length: { maximum: 5 }
    validates :description, presence: true, length: { maximum: 500 }
    has_many :role_transactions, dependent: :destroy
    has_many :role_users, dependent: :destroy
end
