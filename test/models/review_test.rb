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
    @previous_queue_size = Sidekiq::Worker.jobs.size # Depending on test order ActiveStorage::AnalyzeJob may be enqueued, we can't rely on the queue being empty
  end
  
  # Scope tests
  
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
  
  # Edit lock tests
  
  test "review should be editable if no one is currently editing it" do
    @review1.current_editor = nil
    assert @review1.can_edit?("Carly Rae Jepsen")
  end
  
  test "review should not be editable if being edited by someone else" do
    @review1.current_editor = "Carly Rae Jepsen"
    refute @review1.can_edit?("Selena Gomez")
  end
  
  test "review should be editable if being edited by oneself" do
    @review1.current_editor = "Carly Rae Jepsen"
    assert @review1.can_edit?("Carly Rae Jepsen")
  end
  
  test "locking a review should create an edit unlock job if nobody is editing" do
    @review1.edit_lock!("Carly Rae Jepsen")
    assert_equal(@previous_queue_size + 1, Sidekiq::Worker.jobs.size) 
  end
  
  test "locking a review should not create an edit unlock job if there is already someone editing" do
    @review1.current_editor = "Carly Rae Jepsen"
    @review1.edit_lock!("Carly Rae Jepsen")
    assert_equal(@previous_queue_size, Sidekiq::Worker.jobs.size) 
  end 
  
  def teardown
    # Todo: Is it possible for this to cause issues in another test if it clears ActiveStorage::AnalyzeJob? Have not gotten it to happen...
    Sidekiq::Worker.clear_all
  end

end
