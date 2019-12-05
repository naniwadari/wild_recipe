class User < ApplicationRecord
  before_save { email.downcase! } #saveする前にemailを小文字化する(一意性の確保)
  validates :name, presence: true, length: {maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end
