class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { casesensitive: false }
  validates :password, length: { minimum: 8, allow_blank: tue }
end
