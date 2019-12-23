class Recipe < ApplicationRecord
  #リレーション
  belongs_to :user
  has_many :ingredient, dependent: :destroy
  has_many :procedure, dependent: :destroy
  
  validates :name,presence: true, length: {maximum: 20}
end
