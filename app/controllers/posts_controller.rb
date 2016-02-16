class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = paginate(Post)
  end

  def show; end

  private
    def set_post
      redirect_to(:back, alert: t('panel.controllers.not_found', obj: 'Объект')) unless
          (@post = Post.enabled.find_by(id: params[:id].to_i))
    end
end
