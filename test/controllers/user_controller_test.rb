require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "all reviews shown for a user by default" do
    sign_in users(:alice)
    @user = User.first

    get user_path(@user.id)
    assert_response :success

    assert_select "p.show_unpublished_link", "Show unpublished reviews only"
    # Both reviews should be visible
    assert_select "strong", text: "Boney M - Rasputin"
    assert_select "strong", text: "Wombo - Slab"
  end

  test "unpublished reviews only if query param present " do
    sign_in users(:alice)
    @user = User.first

    get user_path(@user.id, unpublished_only: "true")
    assert_response :success

    assert_select "p.show_unpublished_link", "Show all reviews"
    # Should only be 1 review visible as Slab is 'closed'
    assert_select "strong", text: "Boney M - Rasputin"
    assert_select "strong", text: "Wombo - Slab", count: 0
  end
end
