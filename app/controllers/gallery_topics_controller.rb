class GalleryTopicsController < ApplicationController
  def index
    @gallery_topics = paginate(GalleryTopic.enabled)
    respond
  end

  def show
    id = params[:id].to_i
    if id == 0
      @gallery_items = paginate(GalleryItem.global.enabled)
    else
      @gallery_topic = find_obj(GalleryTopic.enabled, id)
      (respond_with_error and return) unless @gallery_topic
      @gallery_items = paginate(@gallery_topic.gallery_items.enabled)
    end

    respond
  end
end
