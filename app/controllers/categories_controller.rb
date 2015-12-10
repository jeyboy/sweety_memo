class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @categories = paginate(Category)
  end

  def show
    @topics = paginate(@category.topics)
  end

  private
    def set_category
      redirect_to :back unless (@category = Category.enabled.find_by(id: params[:id].to_i))
    end
end
