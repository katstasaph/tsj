require "test_helper"

class ReviewTest < ActiveSupport::TestCase

  setup do
    @user = User.create!(username: "georgeeliot", name: "George Eliot", password_confirmation: "whatevs")
    @song = Song.create(title: "Bad Romance", artist: "Lady Gaga", status: "open")
  end

  test "review creation happy path" do
    review = Review.new(song_id: @song.id, user_id: @user.id, score: 10, content: "I don't wanna be French")
    assert review.valid?
  end

  test "review is invalid without song ID" do
    review = Review.new(score: 10, content: "I don't wanna be French")
    assert_not review.valid?
  end

  test "review is invalid without user ID" do
    review = Review.new(song_id: @song.id, score: 10, content: "I don't wanna be French")
    assert_not review.valid?
  end

  test "review is invalid without content" do
    review = Review.new(user_id: @user.id, song_id: @song.id, score: 10)
    assert_not review.valid?
  end

  test "review is invalid without score" do
    review = Review.new(user_id: @user.id, song_id: @song.id, content: "I don't wanna be French")
    assert_not review.valid?
  end

  test "review format produces html with user url if present" do
    @user.url = "http://example.com"
    @user.save
    review = Review.create(user_id: @user.id, song_id: @song.id, score: 10, content: "I don't wanna be French")
    assert_equal(
        "<p><a href='http://example.com' target='_blank'><strong>George Eliot:</strong></a> I don't wanna be French<br>[10]</p>",
        Review.format(review)
    )
  end

  test "review format produces html without user url if not present" do
    review = Review.create(user_id: @user.id, song_id: @song.id, score: 10, content: "I don't wanna be French")
    assert_equal(
        "<p><strong>George Eliot:</strong> I don't wanna be French<br>[10]</p>",
        Review.format(review)
    )
  end

  test "by_user method returns true if review by given user id" do
    review = Review.create(user_id: @user.id, song_id: @song.id, score: 10, content: "I don't wanna be French")
    assert review.by_user?(@user.id)
  end

  test "by_user method returns false if review not by given user id" do
    review = Review.create(user_id: @user.id, song_id: @song.id, score: 10, content: "I don't wanna be French")
    user2 = User.create!(username: "hgwells", name: "HG Wells", password_confirmation: "whatevs")
    assert_not review.by_user?(user2.id)
  end
end
