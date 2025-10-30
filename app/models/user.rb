# app/models/user.rb
class User < ApplicationRecord
  has_many :investments, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 255 }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
