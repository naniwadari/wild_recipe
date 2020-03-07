class Recipe < ApplicationRecord
  #リレーション
  belongs_to :user
  has_many :ingredient, dependent: :destroy
  has_many :procedure, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :impressions, dependent: :destroy
  
  #アップローダー
  mount_uploader :image, ImageUploader
  validate :image_size
  
  #バリデーション
  validates :name,presence: true, length: {maximum: 20}
  
  private
  
    #アップロードされた画像のサイズをバリデーション
    def image_size
      if image.size > 5.megabytes
        errors.add(:image, "画像サイズは5MB以内です")
      end
    end
  
    #キーワードに対応したレシピを返す
    def self.search(search)
      #検索ワードが空なら公開レシピをすべて取得
      return Recipe.where(release: true) unless search
      #検索ワードに似たレシピを返す
      Recipe.where("name LIKE ? AND release = ?", "%#{search}%", true)
    end
    
    #レシピを時系列で返す
    def self.latest(limit_number = nil)
      #取得数の指定がなければすべてのレコードを取得
      return Recipe.where(release: true).order(created_at: "DESC") unless limit_number
      #指定された数のレコードを取得
      Recipe.where(release: true).order(updated_at: "DESC").limit(limit_number)
    end
end
