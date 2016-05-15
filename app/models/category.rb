class Category < ActiveRecord::Base
  TAGS = [
    RELATED= 0,
    ALL_VIDEOS = 1
  ]

  has_many :topics, dependent: :destroy
  has_many :posts, through: :topics

  has_one :image, as: :imageable

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}
  validates :order_pos, presence: true, numericality: true

  scope :enabled, -> { where(disabled: false) }

  accepts_nested_attributes_for :image, reject_if: ->(attributes) { attributes['file'].blank? }

  def preview
    ("#{name[0..15]} ..." if name.length > 15) || name
  end
end
