class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @categories = paginate(Category)
  end

  def show
    if @category.tag == Category::ALL_VIDEOS
      @topic = @category
      @posts = paginate(Post.where(content_type: POST_VIDEO_CONTENT))
      render('topics/show') and return
    else
      @topics = paginate(@category.topics.enabled)
    end
  end

  private
    def set_category
      redirect_to(:back, alert: t('panel.controllers.not_found', obj: 'Объект')) unless
          (@category = Category.enabled.find_by(id: params[:id].to_i))
    end
end
