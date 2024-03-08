require "test_helper"

class ReviewTest < ActiveSupport::TestCase

  def setup
    @user1 = User.create!(username: "selena", name: "Selena Gomez", url: "thesinglesjukebox.com", password_confirmation: "badliar")
    @user2 = User.create!(username: "carly", name: "Carly Rae Jepsen", url: "", password_confirmation: "tinylittlebows") 
    @song1 = Song.create!(title: "Training Season", artist: "Dua Lipa", status: "open", video: "", score: 0, controversy: 0)
    @song2 = Song.create!(title: "Houdini", artist: "Dua Lipa", status: "closed", video: "", score: 0, controversy: 0)
    @song3 = Song.create!(title: "New Rules", artist: "Dua Lipa", status: "published", video: "", score: 0, controversy: 0)
    @review1 = Review.create!(song_id: @song1.id, user_id: @user1.id, score: 0, content: "<div>i ended training season, it was me</div>")    
    @review2 = Review.create!(song_id: @song2.id, user_id: @user1.id, score: 10, content: "<div>it's [10] season now</div>")    
    @review3 = Review.create!(song_id: @song3.id, user_id: @user1.id, score: 1, content: "<div>don't pick up the phone</div>")
    @review4 = Review.create!(song_id: @song1.id, user_id: @user2.id, score: 9, content: "<div>so relatable</div>")    
  end
  
  test "unpublished review scope only includes reviews for open and closed songs" do
    test_reviews = Review.where(id: [@review1.id, @review2.id, @review3.id])
    reviews = test_reviews.all_unpublished
    assert_equal(2, reviews.count)
  end

  test "open review scope only includes reviews for open songs" do
    test_reviews = Review.where(id: [@review1.id, @review2.id, @review3.id])
    reviews = test_reviews.all_open
    assert_equal(1, reviews.count)
  end
  
  test "reviews by user scope only includes reviews by specified user" do
    test_reviews = Review.where(id: [@review1.id, @review4.id])
    reviews = test_reviews.by_user(@user2.id)
    assert_equal(1, reviews.count)
  end

end
