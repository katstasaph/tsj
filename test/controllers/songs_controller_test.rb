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

  test "editor can add new song" do
    sign_in users(:carol)
    get new_song_path
    assert_response :success

    post songs_path, params: { song: { artist: 'The Editors', title: 'Dont Actually Know Any Editors Songs' } }
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

  test "unauthenticated user cannot add new song" do
    get new_song_path
    assert_redirected_to '/users/sign_in'
  end

  test "admin can see song details" do
    sign_in users(:bob)
    @song = Song.find_by(title: "Everything Is Embarrassing")
    assert @song.pic.attached?  # Fixture should have a corresponding sky.jpeg blob

    get song_path(@song.id)

    assert_response :success

    assert_select "h2", text: "Sky Ferreira - Everything Is Embarrassing"
    assert_select "button", text: "Reopen song", count: 1
    assert_select "button", text: "Edit song info", count: 1
    assert_select "img", count: 1
  end
end
