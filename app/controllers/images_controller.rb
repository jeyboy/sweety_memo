class ImagesController < ApplicationController
  before_action :set_image, only: [:show]

  def index
    @images = paginate(Image)
  end

  def show; end

  private
    def set_image
      redirect_to :back unless (@image = Image.find_by(id: params[:id].to_i))
    end
end
