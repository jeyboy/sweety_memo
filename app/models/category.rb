class Category < ActiveRecord::Base
  has_many :topics, dependent: :destroy
  has_many :posts, through: :topics

  has_one :image, as: :imageable

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}

  scope :enabled, -> { where(disabled: false) }
end
