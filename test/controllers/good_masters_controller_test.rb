require "test_helper"

class GoodMastersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get good_masters_new_url
    assert_response :success
  end
end
