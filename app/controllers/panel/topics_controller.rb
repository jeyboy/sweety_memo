class Panel::TopicsController < Panel::BaseController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = paginate(Topic)
  end

  def show
    @posts = paginate(@topic.posts)
  end

  def new
    @topic = Topic.new(category_id: params[:category_id])
  end

  def edit; end

  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html {
          redirect_to [:panel, @topic], notice: t('panel.controllers.created', obj: 'Объект')
        }
      else
        format.html { render 'panel/topics/new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html {
          redirect_to [:panel, @topic], notice: t('panel.controllers.updated', obj: 'Объект')
        }
      else
        format.html { render 'panel/topics/edit' }
      end
    end
  end

  def destroy
    @topic.destroy
    respond_to do |format|
      format.html {
        redirect_to [:panel, :topics], notice: t('panel.controllers.deleted', obj: 'Объект')
      }
      format.json { head :no_content }
    end
  end

  private
    def set_topic
      redirect_to(:back, alert: I18n.t('panel.controllers.not_found', obj: 'Объект')) unless
          (@topic = Topic.find_by(id: params[:id].to_i))
    end

    def topic_params
      params.require(:topic).permit(
        :id, :name, :category_id, :disabled,
        image_attributes: [:id, :file, :file_cache, :imageable_type, :imageable_id]
      )
    end
end
