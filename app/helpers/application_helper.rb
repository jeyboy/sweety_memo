module ApplicationHelper
  def image(obj)
    image_tag((obj.image.file.thumbnail.url rescue ImageUploader::default_url), height: '100', class: 'img-rounded').html_safe
  end

  def async_image(obj)
    image_tag('loading.gif', class: 'img-rounded async_img', data: {src: (obj.image.file.standard.url rescue ImageUploader::default_url)}).html_safe
  end
end
