class GalleryTopicsController < ApplicationController
  def index
    @gallery_topics = paginate(GalleryTopic.enabled)
  end

  def show
    id = params[:id].to_i
    if id == 0
      @gallery_items = paginate(GalleryItem.global.enabled)
    else
      (redirect_to(:back, alert: 'Object is not existed') and return) unless (@gallery_topic = GalleryTopic.enabled.find_by(id: id))
      @gallery_items = paginate(@gallery_topic.gallery_items.enabled)
    end
  end
end
