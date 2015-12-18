class Panel::PostsController < Panel::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post
    @posts = @posts.where(content_type: params[:content_type].to_i) if params[:content_type].to_i > 1
    @posts = paginate(@posts)
    render("panel/#{get_path_part}/index")
  end

  def show
    render("panel/#{get_path_part}/show")
  end

  def new
    @post = Post.new(topic_id: params[:topic_id], content_type: params[:content_type])

    render("panel/#{get_path_part}/new")
  end

  def edit
    render("panel/#{get_path_part}/edit")
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to get_object_path, notice: "#{get_path_part.singularize.humanize} was successfully created." }
      else
        format.html { render "panel/#{get_path_part}/new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to get_object_path, notice: "#{get_path_part.singularize.humanize} was successfully updated." }
      else
        format.html { render "panel/#{get_path_part}/edit" }
      end
    end
  end

  def destroy
    redirect_path = [:panel, get_path_part.symbolize]
    @post.destroy
    respond_to do |format|
      format.html { redirect_to redirect_path, notice: "#{get_path_part.singularize.humanize} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def get_object_path
      case @post.content_type
        when POST_VIDEO_CONTENT
          panel_video_path(@post)
        else
          panel_post_path(@post)
      end
    end

    def get_path_part
      case @post.content_type
        when POST_VIDEO_CONTENT
          'videos'
        else
          'posts'
      end
    end

    def set_post
      redirect_to(:back, alert: 'Object is not existed') unless (@post = Post.find_by(id: params[:id].to_i))
    end

    def post_params
      params.require(:post).permit(:id, :name, :body, :topic_id, :disabled, :content_type)
    end
end
