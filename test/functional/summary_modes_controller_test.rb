require 'test_helper'

class SummaryModesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:summary_modes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create summary_mode" do
    assert_difference('SummaryMode.count') do
      post :create, :summary_mode => { }
    end

    assert_redirected_to summary_mode_path(assigns(:summary_mode))
  end

  test "should show summary_mode" do
    get :show, :id => summary_modes(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => summary_modes(:one).id
    assert_response :success
  end

  test "should update summary_mode" do
    put :update, :id => summary_modes(:one).id, :summary_mode => { }
    assert_redirected_to summary_mode_path(assigns(:summary_mode))
  end

  test "should destroy summary_mode" do
    assert_difference('SummaryMode.count', -1) do
      delete :destroy, :id => summary_modes(:one).id
    end

    assert_redirected_to summary_modes_path
  end
end
