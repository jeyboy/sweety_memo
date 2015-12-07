class Category < ActiveRecord::Base
  has_many :topics, dependent: :destroy
  has_many :posts, through: :topics

  has_one :image, as: :imageable
end
