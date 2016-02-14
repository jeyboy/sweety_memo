class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  around_action

  def index
    @categories = paginate(Category)
    respond
  end

  def show
    @topics = paginate(@category.topics.enabled)
    respond
  end

  private
    def set_category
      respond_with_error unless (@category = find_obj(Category.enabled, params[:id].to_i))
    end
end
