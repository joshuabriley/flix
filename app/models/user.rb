class User < ApplicationRecord
  before_save :format_username
  before_save :format_email
  before_save :set_slug
  has_secure_password
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true
  validates :username,  presence: true,
                        format: { with: /\A[A-Z0-9]+\z/i },
                        uniqueness: { case_sensitive: false }
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { casesensitive: false }
  validates :password, length: { minimum: 8, allow_blank: true }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  scope :by_name, -> { order(:name) }
  scope :not_admin, -> { by_name.where(admin: false) }

  def to_param
    slug
  end

  private
  def format_username
    self.username = username.downcase
  end

  def format_email
    self.email = email.downcase
  end

  def set_slug
    self.slug = username.parameterize
  end
end
