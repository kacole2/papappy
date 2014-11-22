require 'test_helper'

class SiteDataControllerTest < ActionController::TestCase
  setup do
    @site_datum = site_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_datum" do
    assert_difference('SiteDatum.count') do
      post :create, site_datum: { inventory: @site_datum.inventory, pappy: @site_datum.pappy, pappyType: @site_datum.pappyType }
    end

    assert_redirected_to site_datum_path(assigns(:site_datum))
  end

  test "should show site_datum" do
    get :show, id: @site_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site_datum
    assert_response :success
  end

  test "should update site_datum" do
    patch :update, id: @site_datum, site_datum: { inventory: @site_datum.inventory, pappy: @site_datum.pappy, pappyType: @site_datum.pappyType }
    assert_redirected_to site_datum_path(assigns(:site_datum))
  end

  test "should destroy site_datum" do
    assert_difference('SiteDatum.count', -1) do
      delete :destroy, id: @site_datum
    end

    assert_redirected_to site_data_path
  end
end
