require "test_helper"

class SongTest < ActiveSupport::TestCase
  test "song is valid with only title and artist" do
    song = Song.new(title: "Connection", artist: "Elastica")
    assert song.valid?
  end

  test "song is invalid without title or artist" do
    song = Song.create(title: "Connection")
    assert_not song.valid?

    song = Song.new(artist: "Elastica")
    assert_not song.valid?
  end

  test "song requires status before being saved" do
    song = Song.create(title: "Car Song", artist: "Elastica", status: "open")
    assert song.valid?
    song.save
    assert_equal(song.status, "open")
  end

  test "uploading image attaches image to song" do
    song = Song.create(title: "Everything Is Embarrassing", artist: "Sky Ferreira", status: "open")
    pic = file_fixture("sky.jpeg")
    song.pic.attach(pic)
    assert song.pic.attached?
  end

end

class ControversyTest < ActiveSupport::TestCase
  test "controversy index for equal scores is 0" do
    scores = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    mean = 1
    controversy_index = Song.calculate_controversy(scores, mean)
    assert_equal(0, controversy_index.round(2))
  end

  test "controversy index for over 8 reviews increases multiplier by 1.02" do
    scores = [1, 2, 4, 2, 1, 4, 7, 3]
    mean = 3
    controversy_index = Song.calculate_controversy(scores, mean)
    assert_equal(1.5, controversy_index.round(2))
    scores.append(3) # Mean is still 3
    controversy_index = Song.calculate_controversy(scores, mean)
    assert_equal(1.36, controversy_index.round(2))
  end

# Picking a couple of recent actual songs because I'm too lazy to work out the sums myself
  test "calculating basic controversy from mean and 7 scores" do
    # Say Now - Not A Lot Left To Say
    scores1 = [9, 8, 9, 7, 8, 5, 7]
    mean1 = 7.57
    controversy_index1 = Song.calculate_controversy(scores1, mean1)
    # The method doesn't round to 2 decimal places so I've done it here
    assert_equal(1.06, controversy_index1.round(2))
  end

  test "calculating controversy from mean and over 8 scores" do
    # Pound Town - Sexyy Red
    scores2 = [8, 7, 5, 9, 7, 2, 0, 6, 7, 7, 2, 7, 0, 8, 8, 8]
    mean2 = 5.69
    controversy_index2 = Song.calculate_controversy(scores2, mean2)
    assert_equal(2.82, controversy_index2.round(2))

    # "My Barn My Rules" - Horsegirl
    scores3 = [9, 6, 4, 4, 7, 4, 3, 4, 5, 7, 9, 8, 3, 5, 4, 6, 5, 6, 8, 6, 10, 10] # 22 reviews
    mean3 = 6.05
    controversy_index3 = Song.calculate_controversy(scores3, mean3)
    # Published post sez 2.28 (rounding error somewhere - prob my test)
    assert_equal(2.29, controversy_index3.round(2))
  end
end

# todo: simplify these since much of the html formatting has been moved out of the song model?
class CollateBlurbTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  test "song with no reviews or image just has an html post with the header" do
    song = Song.create(title: "India In Me", artist: "Cobblestone Jazz", status: "open", video: "https://youtube.com", score: 0, controversy: 0, reviews: [])
    subhead = "Banger from Ellen Allien Fabric mix"
    image_link = ""l

    expected_header = "<p><i>Banger from Ellen Allien Fabric mix</i></p><center><img src= '' alt = 'Cobblestone Jazz - India In Me' border = 2><br><b>[<a href='https://youtube.com'>Video</a>]<BR><a title='Controversy index: 0.00'>[0.00]</a></b></center></p>"
    assert_equal(expected_header, Song.generate_html(song, subhead, image_link))
  end

  test "song with reviews generates html blurb" do
    song = Song.create(title: "Line Up", artist: "Elastica", status: "open", video: "https://youtube.com", score: 6.50, controversy: 0.23)
    user1 = User.create!(username: "oscarwilde", name: "Oscar Wilde", url: "readinggaol.com", password_confirmation: "whatevs")
    review1 = Review.create(song_id: song.id, user_id: user1.id, score: 5, content: "<div>Lorem ipsum</div>")
    # User Jane doesn't have a website
    user2 = User.create!(username: "janeausten", name: "Jane Austen", password_confirmation: "whatevs")
    review2 = Review.create(song_id: song.id, user_id: user2.id, score: 8, content: "<div>Love it</div>")
    subhead = "In which Justine fixes her laundry hanger"
    song.reviews = [review1, review2]
    image_link = ""

    expected_header = "<p><i>In which Justine fixes her laundry hanger</i></p><center><img src= '' alt = 'Elastica - Line Up' border = 2><br><b>[<a href='https://youtube.com'>Video</a>]<BR><a title='Controversy index: 0.23'>[6.50]</a></b></center></p>"
    expected_blurb1 = "<p><a href='readinggaol.com' target='_blank'><strong>Oscar Wilde:</strong></a> Lorem ipsum<br>[5]</p>"
    expected_blurb2 = "<p><strong>Jane Austen:</strong> Love it<br>[8]</p>"

    expected_post = expected_header + expected_blurb1 + expected_blurb2
    assert_equal(expected_post, Song.generate_html(song, subhead, image_link))
  end
end
