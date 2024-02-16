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
    assert_response :success
  end

  test "admin can add new song" do
    sign_in users(:bob)
    get new_song_path
    assert_response :success

    post songs_path, params: { song: { artist: 'Patti Smith', title: 'Horses' } }
    follow_redirect!
    assert_response :success
    assert_select "p.notice", "Added song!"
  end

  test "writer cannot add new song" do
    sign_in users(:alice)
    get new_song_path
    assert_response :redirect
    follow_redirect!
    assert_select "p.alert", text: "You are not authorized to perform this action."
  end
end
