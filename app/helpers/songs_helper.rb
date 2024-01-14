module SongsHelper
  def song_classes(song, blurbs)
    { 
    songs: true, 
	empty: song.status == "open" && blurbs == 0, 
	blurbed: song.status == "open" && blurbs > 0 && blurbs < 11,
	full: song.status == "open" && blurbs > 11,
	closed: song.status == "closed",
	published: song.status == "published"
	}
  end 
end
