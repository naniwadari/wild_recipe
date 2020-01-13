class Impression < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  
  validates :user_id, presence: true
  validates :recipe_id, presence: true
  validates :comment, presence: true, length: { maximum: 140 }
end
