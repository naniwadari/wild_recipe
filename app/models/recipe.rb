class Recipe < ApplicationRecord
  #リレーション
  belongs_to :user
  has_many :ingredient
  
  validates :name,presence: true, length: {maximum: 20}
end
