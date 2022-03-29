class Movie < ApplicationRecord

  before_save :set_slug

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  RATINGS = %w(G PG PG-13 R NC-17).freeze

  validates :title, presence: true, uniqueness: true
  validates :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }

  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  validates :image_file_name, format: { with: /\w+.(jpg|png)\z/i, message: 'must be a JPG or PNG image' }

  validates :rating, inclusion: { in: RATINGS }

  scope :released, -> { where('released_on <= ?', Time.now).order(released_on: :desc) }
  scope :upcoming, -> { where('released_on > ?', Time.now).order(released_on: :asc) }
  scope :recent, ->(max=5) { released.limit(max) }
  scope :hits, -> { released.where('total_gross >= 300000000').order(total_gross: :desc) }
  scope :flops, -> { released.where('total_gross < 225000000').order(total_gross: :asc) }
  scope :grossed_less_than, ->(amount) { released.where('total_gross < ?', amount) }

  def flop?
    # Change the definition of the flop? method so that cult classics aren't included. For example,
    # if a movie has more than 50 reviews and the average review is 4 stars or better, then the movie
    # shouldn't be a flop regardless of the total gross.

    # Here's a hint: Because the logic for determining whether a movie is a flop is tucked inside the Movie model,
    # you can make this change in one place. When you can do that, you know you're on the right design path!

    total_gross.blank? || total_gross < 225_000_000
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100.0
  end

  def to_param
    slug
  end

private
  def set_slug
    self.slug = title.parameterize
  end
end
