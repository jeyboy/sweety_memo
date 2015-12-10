# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  def self.default_url
    ActionController::Base.helpers.asset_path('default.png')
  end

  # process resize_to_fill: [200, 200]
  process convert: 'png'
  process tags: ['picture']

  version :large do
    scale(nil, 800)
  end

  version :standard do
    scale(nil, 400)
  end

  version :thumbnail do
    scale(nil, 100)
  end
end
