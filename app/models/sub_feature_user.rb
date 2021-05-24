class SubFeatureUser < ApplicationRecord
  belongs_to :sub_feature_master
  belongs_to :user
end
