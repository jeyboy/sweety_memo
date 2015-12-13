class GalleryItemsController < ApplicationController
  def index
    @gallery_items = paginate(GalleryItem)
  end
end
