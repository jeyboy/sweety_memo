# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base
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

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def self.default_url
    ActionController::Base.helpers.asset_path('default.png')
    # ActionController::Base.helpers.asset_path([version_name, 'def_cat.png'].compact.join('_'))

    # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  # process resize_to_fill: [200, 200]
  process convert: 'png'
  process tags: ['picture']

  version :standard do
    scale(nil, 300)
  end

  version :thumbnail do
    scale(nil, 100)
  end
end
