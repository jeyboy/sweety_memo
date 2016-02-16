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
        format.html {
          redirect_to [:panel, @category], notice: t('panel.controllers.created', obj: 'Объект')
        }
      else
        format.html { render 'panel/categories/new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html {
          redirect_to [:panel, @category], notice: t('panel.controllers.updated', obj: 'Объект')
        }
      else
        format.html { render 'panel/categories/edit' }
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html {
        redirect_to [:panel, :categories], notice: t('panel.controllers.deleted', obj: 'Объект')
      }
      format.json { head :no_content }
    end
  end

  private
    def set_category
      redirect_to(:back, alert: t('panel.controllers.not_found', obj: 'Объект')) unless
          (@category = Category.find_by(id: params[:id].to_i))
    end

    def category_params
      params.require(:category).permit(
        :id, :name, :order_pos, :disabled,
        image_attributes: [:id, :file, :file_cache, :imageable_type, :imageable_id]
      )
    end
end
