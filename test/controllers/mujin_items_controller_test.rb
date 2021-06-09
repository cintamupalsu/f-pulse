require "test_helper"

class MujinItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mujin_items_new_url
    assert_response :success
  end
end
