class RoleUser < ApplicationRecord
  belongs_to :role_master
  belongs_to :user
end
