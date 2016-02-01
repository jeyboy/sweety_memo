class Panel::GalleryItemsController < Panel::BaseController
  before_action :set_gallery_item, only: [:show, :edit, :update, :destroy]

  def index
    @gallery_items = paginate(GalleryItem)
  end

  def show; end

  def new
    @gallery_item = GalleryItem.new(gallery_topic_id: params[:gallery_topic_id])
  end

  def edit; end

  def create
    @gallery_item = GalleryItem.new(gallery_item_params)

    respond_to do |format|
      if @gallery_item.save
        format.html { redirect_to [:panel, @gallery_item], notice: 'Gallery item was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @gallery_item.update(gallery_item_params)
        format.html { redirect_to [:panel, @gallery_item], notice: 'Gallery item was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @gallery_item.destroy
    respond_to do |format|
      format.html { redirect_to [:panel, :gallery_topics], notice: 'Gallery item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_gallery_item
      redirect_to(:back, alert: 'Object is not existed') unless (@gallery_item = GalleryItem.find_by(id: params[:id].to_i))
    end

    def gallery_item_params
      params.require(:gallery_item).permit(:id, :name, :gallery_topic_id, :description, :disabled, image_attributes: [:id, :file, :file_cache, :imageable_type, :imageable_id])
    end
end
