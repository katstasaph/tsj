require "test_helper"

class SongsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "unauthenticated user going to index should be redirected to login" do
    get root_path
    assert_redirected_to '/users/sign_in'
  end

  test "authenticated user should see index" do
    sign_in users(:bob)
    get root_path
    assert_response :success  # This will fail until I set up an announcement fixture
  end
end
