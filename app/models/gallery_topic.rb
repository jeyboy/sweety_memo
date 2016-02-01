class GalleryTopic < ActiveRecord::Base
  has_one :image, as: :imageable
  has_many :gallery_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 254}

  scope :enabled, -> { where(disabled: false) }

  accepts_nested_attributes_for :image, reject_if: ->(attributes) { attributes['file'].blank? }
end
