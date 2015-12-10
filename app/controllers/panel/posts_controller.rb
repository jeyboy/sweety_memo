class Panel::PostsController < Panel::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = paginate(Post)
  end

  def show; end

  def new
    @post = Post.new(topic_id: params[:topic_id])
  end

  def edit; end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to [:panel, @post], notice: 'Post was successfully created.' }
      else
        format.html { render 'panel/posts/new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to [:panel, @post], notice: 'Post was successfully updated.' }
      else
        format.html { render 'panel/posts/edit' }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to [:panel, :posts], notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      redirect_to(:back, alert: 'Object is not existed') unless (@post = Post.find_by(id: params[:id].to_i))
    end

    def post_params
      params.require(:post).permit(:id, :name, :body, :topic_id, :disabled)
    end
end
