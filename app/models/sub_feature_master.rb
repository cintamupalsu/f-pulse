class SubFeatureMaster < ApplicationRecord
  belongs_to :feature_master
  has_many :sub_feature_users, dependent: :destroy
end
