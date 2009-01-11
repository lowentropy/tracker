require 'test_helper'

class UnitPrefsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unit_prefs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unit_pref" do
    assert_difference('UnitPref.count') do
      post :create, :unit_pref => { }
    end

    assert_redirected_to unit_pref_path(assigns(:unit_pref))
  end

  test "should show unit_pref" do
    get :show, :id => unit_prefs(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => unit_prefs(:one).id
    assert_response :success
  end

  test "should update unit_pref" do
    put :update, :id => unit_prefs(:one).id, :unit_pref => { }
    assert_redirected_to unit_pref_path(assigns(:unit_pref))
  end

  test "should destroy unit_pref" do
    assert_difference('UnitPref.count', -1) do
      delete :destroy, :id => unit_prefs(:one).id
    end

    assert_redirected_to unit_prefs_path
  end
end
