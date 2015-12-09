Cloudinary.config do |config|
  config.cloud_name = 'duofold'
  config.api_key = '951696928569826'
  config.api_secret = 'HEaT5Fesm-hp_1ucPr8kJHYM0qU'
  config.cdn_subdomain = true
  config.enhance_image_tag = true
  config.static_image_support = Rails.env.production?
end
