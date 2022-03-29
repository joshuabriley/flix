class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations
  before_save :set_slug

  def to_param
    slug
  end

  private
  def set_slug
    self.slug = name.parameterize
  end
end
