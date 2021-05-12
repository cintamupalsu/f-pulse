require "test_helper"

class JobMastersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get job_masters_new_url
    assert_response :success
  end
end
