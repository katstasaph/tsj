module SongsHelper
  def song_classes(song, blurbs)
    { 
    songs: true, 
	empty: song.status == "open" && blurbs == 0, 
	blurbed: song.status == "open" && blurbs > 0 && blurbs < 6,
	ready: song.status == "open" && blurbs  >= 6 && blurbs < 11,
	full: song.status == "open" && blurbs >= 11,
	closed: song.status == "closed",
	published: song.status == "published"
	}
  end 
  
  def song_scores(score, controversy)
    precise_score = !score || score.nan? ? "N/A" : number_with_precision(score, precision: 2) 
	precise_controversy = number_with_precision(controversy, precision: 2) 
    "<strong>[#{precise_score}]</strong> <em>(Controversy index: #{precise_controversy})</em>".html_safe
  end
end
