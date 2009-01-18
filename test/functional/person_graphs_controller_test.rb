require 'test_helper'

class PersonGraphsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:person_graphs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person_graph" do
    assert_difference('PersonGraph.count') do
      post :create, :person_graph => { }
    end

    assert_redirected_to person_graph_path(assigns(:person_graph))
  end

  test "should show person_graph" do
    get :show, :id => person_graphs(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => person_graphs(:one).id
    assert_response :success
  end

  test "should update person_graph" do
    put :update, :id => person_graphs(:one).id, :person_graph => { }
    assert_redirected_to person_graph_path(assigns(:person_graph))
  end

  test "should destroy person_graph" do
    assert_difference('PersonGraph.count', -1) do
      delete :destroy, :id => person_graphs(:one).id
    end

    assert_redirected_to person_graphs_path
  end
end
