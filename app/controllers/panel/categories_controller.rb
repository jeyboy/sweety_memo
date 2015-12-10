class Panel::CategoriesController < Panel::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = paginate(Category)
  end

  def show
    @topics = paginate(@category.topics)
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to [:panel, @category], notice: 'Category was successfully created.' }
      else
        format.html { render 'panel/categories/new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to [:panel, @category], notice: 'Category was successfully updated.' }
      else
        format.html { render 'panel/categories/edit' }
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to [:panel, :categories], notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_category
      redirect_to :back unless (@category = Category.find_by(id: params[:id].to_i))
    end

    def category_params
      params.require(:category).permit(:name, :disabled)
    end
end
