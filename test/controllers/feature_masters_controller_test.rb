require "test_helper"

class FeatureMastersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get feature_masters_new_url
    assert_response :success
  end
end
