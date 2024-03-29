require "test_helper"

class FormatterTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  
  test "divs are stripped from subhead correctly" do
    song = Song.create(title: "4 Ever", artist: "The Veronicas", video: "https://youtube.com", score: 8, controversy: 0.55, status: "closed")
    song.subhead = "<div>so much html</div>"
    expected_subhead = "so much html"
    assert_equal(expected_subhead, FormatterService.strip_subhead(song.subhead))
  end
  
  test "standard post frame is generated correctly" do
    song = Song.create(title: "4 Ever", artist: "The Veronicas", alttext: "a real image", video: "https://youtube.com", score: 8, controversy: 0.55, status: "closed")
    stripped_subhead = "we did this already"
    image_link = "some url"
    expected_frame = "<p><i>we did this already</i></p><center><img src= 'some url' alt = 'a real image' border = 2><br><b>[<a href='https://youtube.com'>Video</a>]<BR><a title='Controversy index: 0.55'>[8.00]</a></b></center></p>"
    assert_equal(expected_frame, FormatterService.generate_post_frame(song, stripped_subhead, image_link))
  end  

  test "post frame for song without alt text is generated with default alt text" do
    song = Song.create(title: "4 Ever", artist: "The Veronicas", video: "https://youtube.com", score: 8, controversy: 0.55, status: "closed")
    stripped_subhead = "we did this already"
    image_link = "some url"
    expected_frame = "<p><i>we did this already</i></p><center><img src= 'some url' alt = 'The Veronicas - 4 Ever' border = 2><br><b>[<a href='https://youtube.com'>Video</a>]<BR><a title='Controversy index: 0.55'>[8.00]</a></b></center></p>"
    assert_equal(expected_frame, FormatterService.generate_post_frame(song, stripped_subhead, image_link))
  end  
  
  test "review without user url is formatted correctly" do
    user = User.create(username: "xcx", name: "Charli XCX", password_confirmation: "noleaks")
    review = Review.create(song_id: 1, user_id: user.id, score: 7, content: "<div>Obnoxious!</div>")
    expected_review = "<p><strong>Charli XCX:</strong> Obnoxious!<br>[7]</p>"
    assert_equal(expected_review, FormatterService.generate_review(review))
  end
  
  test "review with user url is formatted correctly" do
    user = User.create(username: "xcx2", name: "Charli XCX", url: "https://youtube.com", password_confirmation: "srslynoleaks")
    review = Review.create(song_id: 1, user_id: user.id, score: 3, content: "<div>Competent!</div>")
    expected_review = "<p><a href='https://youtube.com' target='_blank'><strong>Charli XCX:</strong></a> Competent!<br>[3]</p>"
    assert_equal(expected_review, FormatterService.generate_review(review))
  end

end
