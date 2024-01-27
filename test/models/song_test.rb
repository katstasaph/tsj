require "test_helper"

class SongTest < ActiveSupport::TestCase
  test "song is valid with only title and artist" do
    song = Song.new(title: "Connection", artist: "Elastica")
    assert song.valid?
  end

  test "song is invalid without title or artist" do
    song = Song.new(title: "Connection")
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
end
