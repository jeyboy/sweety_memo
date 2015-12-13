require 'test_helper'

class GalleryItemsControllerTest < ActionController::TestCase
  setup do
    @gallery_item = gallery_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gallery_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gallery_item" do
    assert_difference('GalleryItem.count') do
      post :create, gallery_item: { description: @gallery_item.description, disabled: @gallery_item.disabled, name: @gallery_item.name }
    end

    assert_redirected_to gallery_item_path(assigns(:gallery_item))
  end

  test "should show gallery_item" do
    get :show, id: @gallery_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gallery_item
    assert_response :success
  end

  test "should update gallery_item" do
    patch :update, id: @gallery_item, gallery_item: { description: @gallery_item.description, disabled: @gallery_item.disabled, name: @gallery_item.name }
    assert_redirected_to gallery_item_path(assigns(:gallery_item))
  end

  test "should destroy gallery_item" do
    assert_difference('GalleryItem.count', -1) do
      delete :destroy, id: @gallery_item
    end

    assert_redirected_to gallery_items_path
  end
end
