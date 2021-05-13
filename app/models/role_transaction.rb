class RoleTransaction < ApplicationRecord
  belongs_to :role_master
  belongs_to :feature_master
end
