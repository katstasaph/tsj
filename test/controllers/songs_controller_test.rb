require "test_helper"

class SongsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(username: "tommy_pynchon", password_confirmation: "whatevs")
    @user2 = User.create!(username: "gagatha_christie", password_confirmation: "whatevs")
  end

  test "going to index without logging in gives a redirect" do
    @song = Song.create(title: "Technique", artist: "New Order", status: "open")
    get root_url
    assert_redirected_to "/users/sign_in"
  end

  test "should get index" do
    @song = Song.create(title: "Technique", artist: "New Order", status: "open")
    sign_in @user
    get root_url
    assert_response :success
    assert_select "title", "The Singles Blurber"
    assert_select "h1", /The Singles Blurber v \d.\d.\d/
  end

  test "show number of reviews on song index" do
    @song = Song.create(title: "Technique", artist: "New Order", status: "open")
    sign_in @user
    get root_url

    # should be 5 cells in each blurber table row (artist/title, audio, video, action, blurb_count)
    assert_select "tr.songs" do |trs|
      trs.each do |tr|
        assert_select tr, "td", 5
      end
    end

    # We should only have 1 song with no blurbs
    assert_select "tr.empty", 1
    assert_select "td.artist_and_title", "New Order - Technique"
    assert_select "td.audio", ""
    assert_select "td.video", ""
    assert_select "td.action", "Write review"  # This user hasn't written a review yet
    assert_select "td.blurb_count", "(0)"

    # Let's add a review - the action and count should change
    review = Review.create(user_id: @user.id, song_id: @song.id, score: 10, content: "I love Technique")

    get root_url

    # 2 songs with reviews from my other tests haven't been torn down and
    # I don't know why Rails would do that to me :(
    assert_select "tr.blurbed", 3
    assert_select "td.artist_and_title", "New Order - Technique"
    assert_select "td.audio", ""
    assert_select "td.video", ""
    assert_select "td.action", "Edit review"
    assert_select "td.blurb_count", "(1)"

    # Add a third review from another reviewer
    review = Review.create(user_id: @user2.id, song_id: @song.id, score: 5, content: "I am ambivalent about Technique")

    get root_url

    assert_select "td.artist_and_title", "New Order - Technique"
    assert_select "td.audio", ""
    assert_select "td.video", ""
    assert_select "td.action", "Edit review"
    assert_select "td.blurb_count", "(2)"
  end
end
