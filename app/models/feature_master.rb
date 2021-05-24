class FeatureMaster < ApplicationRecord
    validates :content, presence: true, length: { maximum: 50 }
    validates :abrev, presence: true, length: { maximum: 5 }, uniqueness: true
    has_many :role_transactions, dependent: :destroy
    has_many :sub_feature_masters, dependent: :destroy
end
