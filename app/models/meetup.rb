class Meetup < ActiveRecord::Base
  has_many :signups
  belongs_to :user
  has_many :users, through: :signups

  validates :title, presence: true, length: { minimum: 1 }
  validates :description, presence: true, length: { minimum: 1 }
  validates :location, presence: true, length: { minimum: 1 }
  validates :user_id, presence: {message: "error - Please Sign In!"}
end
