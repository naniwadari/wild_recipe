class User < ApplicationRecord
  attr_accessor :remember_token #仮想の属性remember_tokenを作成
  before_save { email.downcase! } #saveする前にemailを小文字化する(一意性の確保)
  
  #画像アップロード
  mount_uploader :image, ImageUploader
  validate :image_size

  #バリデーション
  validates :name, presence: true, length: {maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },allow_nil: true
  validates :profile_text, length: {maximum: 255 }
  
  #リレーション
  has_many :recipes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :impressions, dependent: :destroy
  
  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    name = auth[:info][:name]
    image = auth[:info][:image]

    self.find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = name
      user.email = User.dummy_email(auth)
      user.password = User.new_token
      user.image.url = image
    end
  end
  
  class << self
    
    #渡された文字列をBcryptで暗号化して返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    #ランダムなトークンを生成
    def new_token
      SecureRandom.urlsafe_base64
    end
    
  end
  
  #永続セッションのためにユーザーをデータベースに記憶
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  #渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  #ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  #レシピをイイネする
  def like(recipe)
    self.likes.create(recipe_id: recipe.id)
  end
  
  #レシピのイイネを取り消す
  def unlike(recipe)
    self.likes.find_by(recipe_id: recipe.id).destroy
  end
  
  #ユーザーがレシピをイイネしていたらtrueを返す
  def like?(recipe)
    self.likes.find_by(recipe_id: recipe.id).present?
  end
  
  #レシピをブックマークする
  def book(recipe)
    self.books.create(recipe_id: recipe.id)
  end
  
  #レシピのブックマークを取り消す
  def unbook(recipe)
    self.books.find_by(recipe_id: recipe.id).destroy
  end
  
  #ユーザーがレシピをブックマークしていたらtrueを返す
  def book?(recipe)
    self.books.find_by(recipe_id: recipe.id).present?
  end
  
  #ユーザーがレシピにコメントする
  def write_comment(recipe, comment)
    self.impressions.create(recipe_id: recipe.id, comment: comment)
  end
  
  private

  def image_size
    if image.size > 3.megabytes
      errors.add(:image, "画像サイズは3MB以内です")
    end
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

end
