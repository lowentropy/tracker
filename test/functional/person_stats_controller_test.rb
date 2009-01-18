require 'test_helper'

class PersonStatsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:person_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person_stat" do
    assert_difference('PersonStat.count') do
      post :create, :person_stat => { }
    end

    assert_redirected_to person_stat_path(assigns(:person_stat))
  end

  test "should show person_stat" do
    get :show, :id => person_stats(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => person_stats(:one).id
    assert_response :success
  end

  test "should update person_stat" do
    put :update, :id => person_stats(:one).id, :person_stat => { }
    assert_redirected_to person_stat_path(assigns(:person_stat))
  end

  test "should destroy person_stat" do
    assert_difference('PersonStat.count', -1) do
      delete :destroy, :id => person_stats(:one).id
    end

    assert_redirected_to person_stats_path
  end
end
