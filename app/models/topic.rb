class Topic < ActiveRecord::Base
  belongs_to :category

  has_one :image, as: :imageable

  has_many :posts, dependent: :destroy

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}

  scope :enabled, -> { where(disabled: false) }

  accepts_nested_attributes_for :image, reject_if: ->(attributes) { attributes['file'].blank? }
end
