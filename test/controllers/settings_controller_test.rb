require "test_helper"

class SettingsControllerTest < ActionController::TestCase

  setup do
    @setting = FactoryGirl.create(:setting)
  end

  should "be on new setting url" do
    get :new
    assert_response :success
  end

  should "be on edit setting url" do
    get :edit, id: @setting 
    assert_response :success
  end

  should "delete setting and get back to index" do
    get :index 
    assert_response 200

    assert assigns(:settings)
    assert_equal 1, assigns(:settings).size

    delete :destroy, id: @setting 
    assert_response 302
    assert_redirected_to '/settings'
    assert [], assigns(:settings)
  end
end
