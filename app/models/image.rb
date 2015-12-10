class Image < ActiveRecord::Base
  mount_uploader :file, ImageUploader

  belongs_to :imageable, polymorphic: true

  validate :image_size_validation, if: 'file?'


  private

  def image_size_validation
    errors.add(:base, 'Image should be less than 1MB') if file.size > 1.megabytes
  end
end
