class User < ApplicationRecord
  has_secure_password
  has_many :ratings, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
end
