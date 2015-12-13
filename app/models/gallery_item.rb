class GalleryItem < ActiveRecord::Base
  has_one :image, as: :imageable

  validates :name, presence: true, length: { maximum: 254}
  validates :description, presence: true

  scope :enabled, -> { where(disabled: false) }

  accepts_nested_attributes_for :image, reject_if: ->(attributes) { attributes['file'].blank? }
end
