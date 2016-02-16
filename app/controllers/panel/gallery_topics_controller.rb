class Panel::GalleryTopicsController < Panel::BaseController
  before_action :set_gallery_topic, only: [:show, :edit, :update, :destroy]

  def unclassified
    @gallery_items = paginate(GalleryItem.global)
  end

  def index
    @gallery_topics = paginate(GalleryTopic)
  end

  def show
    @gallery_items = paginate(@gallery_topic.gallery_items)
  end

  def new
    @gallery_topic = GalleryTopic.new
  end

  def edit; end

  def create
    @gallery_topic = GalleryTopic.new(gallery_topic_params)

    respond_to do |format|
      if @gallery_topic.save
        format.html { redirect_to [:panel, @gallery_topic], notice: 'Gallery topic was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @gallery_topic.update(gallery_topic_params)
        format.html { redirect_to [:panel, @gallery_topic], notice: 'Gallery topic was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @gallery_topic.destroy
    respond_to do |format|
      format.html { redirect_to [:panel, :gallery_topics], notice: 'Gallery topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_gallery_topic
    redirect_to(:back, alert: I18n.t('panel.controllers.not_found', obj: 'Объект')) unless
        (@gallery_topic = GalleryTopic.find_by(id: params[:id].to_i))
  end

  def gallery_topic_params
    params.require(:gallery_topic).permit(
      :id, :name, :disabled,
      image_attributes: [:id, :file, :file_cache, :imageable_type, :imageable_id]
    )
  end
end
