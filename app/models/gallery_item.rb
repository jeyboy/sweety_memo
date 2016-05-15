class GalleryItem < ActiveRecord::Base
  has_one :image, as: :imageable
  belongs_to :gallery_topic

  validates :name, presence: true, length: { maximum: 254}
  validates :description, presence: true

  scope :enabled, -> { where(disabled: false) }
  scope :global, -> { where(gallery_topic_id: nil) }

  accepts_nested_attributes_for :image, reject_if: ->(attributes) { attributes['file'].blank? }
end
