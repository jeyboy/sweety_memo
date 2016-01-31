class Panel::GalleryTopicsController < Panel::BaseController
  before_action :set_gallery_topic, only: [:show, :edit, :update, :destroy]

  def unclassified
    @gallery_items = paginate(GalleryItem.global)
  end

  def index
    @gallery_topics = paginate(GalleryTopic)
  end

  def show; end

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
    redirect_to(:back, alert: 'Object is not existed') unless (@gallery_topic = GalleryTopic.find_by(id: params[:id].to_i))
  end

  def gallery_topic_params
    params.require(:gallery_topic).permit(:id, :name, :disabled)
  end











  # before_action :set_gallery_topic, only: [:show, :edit, :update, :destroy]
  #
  # # GET /gallery_topics
  # # GET /gallery_topics.json
  # def index
  #   @gallery_topics = GalleryTopic.all
  # end
  #
  # # GET /gallery_topics/1
  # # GET /gallery_topics/1.json
  # def show
  # end
  #
  # # GET /gallery_topics/new
  # def new
  #   @gallery_topic = GalleryTopic.new
  # end
  #
  # # GET /gallery_topics/1/edit
  # def edit
  # end
  #
  # # POST /gallery_topics
  # # POST /gallery_topics.json
  # def create
  #   @gallery_topic = GalleryTopic.new(gallery_topic_params)
  #
  #   respond_to do |format|
  #     if @gallery_topic.save
  #       format.html { redirect_to @gallery_topic, notice: 'Gallery topic was successfully created.' }
  #       format.json { render :show, status: :created, location: @gallery_topic }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @gallery_topic.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # PATCH/PUT /gallery_topics/1
  # # PATCH/PUT /gallery_topics/1.json
  # def update
  #   respond_to do |format|
  #     if @gallery_topic.update(gallery_topic_params)
  #       format.html { redirect_to @gallery_topic, notice: 'Gallery topic was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @gallery_topic }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @gallery_topic.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # DELETE /gallery_topics/1
  # # DELETE /gallery_topics/1.json
  # def destroy
  #   @gallery_topic.destroy
  #   respond_to do |format|
  #     format.html { redirect_to gallery_topics_url, notice: 'Gallery topic was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end
  #
  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_gallery_topic
  #     @gallery_topic = GalleryTopic.find(params[:id])
  #   end
  #
  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def gallery_topic_params
  #     params.require(:gallery_topic).permit(:name)
  #   end
end
