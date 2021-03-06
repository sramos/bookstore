require 'test_helper'

class EbooksControllerTest < ActionController::TestCase
  setup do
    @ebook = ebooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ebooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ebook" do
    assert_difference('Ebook.count') do
      post :create, ebook: { book_id: @ebook.book_id }
    end

    assert_redirected_to ebook_path(assigns(:ebook))
  end

  test "should show ebook" do
    get :show, id: @ebook
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ebook
    assert_response :success
  end

  test "should update ebook" do
    patch :update, id: @ebook, ebook: { book_id: @ebook.book_id }
    assert_redirected_to ebook_path(assigns(:ebook))
  end

  test "should destroy ebook" do
    assert_difference('Ebook.count', -1) do
      delete :destroy, id: @ebook
    end

    assert_redirected_to ebooks_path
  end
end
