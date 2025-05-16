class Rating < ApplicationRecord
  belongs_to :user

  validates :movie_api_id, presence: true
  validates :score, inclusion: { in: 1..5 }
end
