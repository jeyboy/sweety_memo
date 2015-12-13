class GalleryItemsController < ApplicationController
  before_action :set_gallery_item, only: [:show, :edit, :update, :destroy]

  def index
    @gallery_items = GalleryItem.all
  end

  def show
  end

  def new
    @gallery_item = GalleryItem.new
  end

  def edit; end

  def create
    @gallery_item = GalleryItem.new(gallery_item_params)

    respond_to do |format|
      if @gallery_item.save
        format.html { redirect_to @gallery_item, notice: 'Gallery item was successfully created.' }
        format.json { render :show, status: :created, location: @gallery_item }
      else
        format.html { render :new }
        format.json { render json: @gallery_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @gallery_item.update(gallery_item_params)
        format.html { redirect_to @gallery_item, notice: 'Gallery item was successfully updated.' }
        format.json { render :show, status: :ok, location: @gallery_item }
      else
        format.html { render :edit }
        format.json { render json: @gallery_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @gallery_item.destroy
    respond_to do |format|
      format.html { redirect_to gallery_items_url, notice: 'Gallery item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_gallery_item
      @gallery_item = GalleryItem.find(params[:id])
    end

    def gallery_item_params
      params.require(:gallery_item).permit(:name, :description, :disabled)
    end
end
