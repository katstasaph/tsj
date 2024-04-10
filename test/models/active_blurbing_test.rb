require "test_helper"

class ActiveBlurbingTest < ActiveSupport::TestCase

  def setup
    @previous_queue_size = Sidekiq::Worker.jobs.size # we can't rely on the queue being empty because ActiveStorage enqueues some jobs
    @user1 = User.create!(username: "Redfoo", name: "redfoo", url: "", password_confirmation: "partyrock") 
    @song1 = Song.create!(title: "Party Rock Anthem", artist: "LMFAO", status: "open", video: "", score: 0, controversy: 0)
  end
  
  test "by_song scope should include the correct number of results for a song with active blurbings" do
    @user2 = User.create!(username: "Skyblu", name: "skyblu", url: "", password_confirmation: "partyrock")     
    @song2 = Song.create!(title: "Like a G6", artist: "Far East Movement ft. The Cataracs and Dev", status: "open", video: "", score: 0, controversy: 0)
    @blurbing1 = ActiveBlurbing.create!(blurber: @user1, song: @song1)
    @blurbing2 = ActiveBlurbing.create!(blurber: @user2, song: @song1)
    @blurbing3 = ActiveBlurbing.create!(blurber: @user1, song: @song2)
    test_blurbings = ActiveBlurbing.where(id: [@song1.id, @song2.id])
    blurbings = ActiveBlurbing.by_song(@song1.id)
    assert_equal(2, blurbings.count)  
  end

  test "by_song scope should include no results for a song with no active blurbings" do
    blurbings  = ActiveBlurbing.by_song(@song1.id)
    assert_equal(0, blurbings.count)  
  end
  
  test "successfully creating a blurbing session should schedule an expire job" do
    @blurbing = ActiveBlurbing.create!(blurber: @user1, song: @song1)
    assert_equal(@previous_queue_size + 1, Sidekiq::Worker.jobs.size) 
  end
 
   def teardown
    # todo: as before look into whether clearing the whole queue here causes issues in other tests
    Sidekiq::Worker.clear_all
  end
 
end
