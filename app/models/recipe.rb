class Recipe < ApplicationRecord
  #リレーション
  belongs_to :user
  has_many :ingredient, dependent: :destroy
  has_many :procedure, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :impressions, dependent: :destroy
  
  validates :name,presence: true, length: {maximum: 20}
  
  #キーワードに対応したレシピを返す
  def self.search(search)
    #検索ワードが空なら公開レシピをすべて取得
    return Recipe.where(release: true) unless search
    #検索ワードに似たレシピを返す
    Recipe.where("(name LIKE ?) AND (release = ?)", "%#{search}%", true)
  end
end
