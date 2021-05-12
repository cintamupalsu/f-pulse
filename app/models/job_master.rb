class JobMaster < ApplicationRecord
    validates :content, presence: true, length: { maximum: 50 }
    validates :order, presence: true, length: { maximum: 3 }
end
