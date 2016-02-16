class Panel::PostsController < Panel::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post
    @posts = @posts.where(content_type: params[:content_type].to_i) if params[:content_type].to_i > 1
    @posts = paginate(@posts)
    render("panel/#{Post.content_type_str(params[:content_type])}/index")
  end

  def show
    render("panel/#{@post.content_type_str}/show")
  end

  def new
    @post = Post.new(topic_id: params[:topic_id], content_type: params[:content_type])

    render("panel/#{@post.content_type_str}/new")
  end

  def edit
    render("panel/#{@post.content_type_str}/edit")
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html {
          redirect_to get_object_path, notice: t('panel.controllers.created', obj: 'Объект') # @post.readable_content_type
        }
      else
        format.html { render "panel/#{@post.content_type_str}/new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html {
          redirect_to get_object_path, notice: t('panel.controllers.updated', obj: 'Объект') # @post.readable_content_type
        }
      else
        format.html { render "panel/#{@post.content_type_str}/edit" }
      end
    end
  end

  def destroy
    redirect_path = [:panel, @post.content_type_str.to_sym]
    @post.destroy
    respond_to do |format|
      format.html {
        redirect_to redirect_path, notice: t('panel.controllers.deleted', obj: 'Объект') # @post.readable_content_type
      }
      format.json { head :no_content }
    end
  end

  private
    def get_object_path
      send "panel_#{@post.content_type_str.singularize}_path".to_sym, @post
    end

    def set_post
      redirect_to(:back, alert: t('panel.controllers.not_found', obj: 'Объект')) unless
          (@post = Post.find_by(id: params[:id].to_i))
    end

    def post_params
      params.require(:post).permit(
        :id, :name, :body, :topic_id, :disabled, :content_type
      )
    end
end
