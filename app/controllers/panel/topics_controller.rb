class Panel::TopicsController < Panel::BaseController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.all
  end

  def show; end

  def new
    @topic = Topic.new
  end

  def edit; end

  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to [:panel, @topic], notice: 'Topic was successfully created.' }
      else
        format.html { render 'panel/topics/new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to [:panel, @topic], notice: 'Topic was successfully updated.' }
      else
        format.html { render 'panel/topics/edit' }
      end
    end
  end

  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:name)
    end
end
