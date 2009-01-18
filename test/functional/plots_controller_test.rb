require 'test_helper'

class PlotsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plot" do
    assert_difference('Plot.count') do
      post :create, :plot => { }
    end

    assert_redirected_to plot_path(assigns(:plot))
  end

  test "should show plot" do
    get :show, :id => plots(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => plots(:one).id
    assert_response :success
  end

  test "should update plot" do
    put :update, :id => plots(:one).id, :plot => { }
    assert_redirected_to plot_path(assigns(:plot))
  end

  test "should destroy plot" do
    assert_difference('Plot.count', -1) do
      delete :destroy, :id => plots(:one).id
    end

    assert_redirected_to plots_path
  end
end
