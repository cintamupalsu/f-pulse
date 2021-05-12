require "test_helper"

class RoleMastersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get role_masters_new_url
    assert_response :success
  end
end
