class GalleryTopic < ActiveRecord::Base
  has_many :gallery_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 254}

  scope :enabled, -> { where(disabled: false) }
end
