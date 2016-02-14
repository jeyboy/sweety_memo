class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = paginate(Post)
    respond
  end

  def show
    respond
  end

  private
    def set_post
      respond_with_error unless (@post = find_obj(Post.enabled, params[:id]))
    end
end
