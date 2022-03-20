class Review < ApplicationRecord
  belongs_to :movie

  STARS = [1, 2, 3, 4, 5].freeze

  validates :name, presence: true
  validates :comment, length: { minimum: 4 }
  validates :stars, inclusion: { in: STARS }

  def stars_as_percent
    (stars / 5.0) * 100.0
  end
end
