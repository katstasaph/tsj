class Song < ApplicationRecord
  enum :status, [ :open, :closed, :published ]
  has_rich_text :subhead
  has_many :reviews
    accepts_nested_attributes_for :reviews, allow_destroy: true
  has_one_attached :pic
  
  validates :artist, :title, presence: true
  validates :audio, :uniqueness => {:allow_blank => true}
  validates :video, :uniqueness => {:allow_blank => true}

  attribute :user_written
  attribute :user_review_id	
  attribute :score
  attribute :controversy
	
  def self.list_available(songs, current_user)
	songs.map do |song|
	  written = false
	  song.reviews.each do |review|
	    if review.user_id == current_user.id
		  written = true
		  song[:user_review_id] = review.id
          break		
		end
	  end
	  song[:user_written] = written
	  song
	end
  end
  
  def self.calculate_scores(reviews)
	scores = reviews.map { |review| review.score }
	mean = scores.sum(0.00) / scores.length
	distances = scores.map { |score| (score - mean).abs }
    avedev = distances.sum(0.00) / distances.length
	multiplier = 1 + ([0, 0.2 * (scores.length - 8)].max)
	controversy = {
	  avedev: avedev,
	  multiplier: multiplier
	}
	[mean, controversy]
  end
	
  def self.collate_blurbs(subhead, video, score, controversy, reviews)
    post_html = "<p><i>#{subhead}</i></p><center><p><img src= '' border = 2><b>[<a href='#{video}'>Video</a>]<BR><a title='Controversy index: #{sprintf('%.2f', controversy[:avedev] * controversy[:multiplier])}'>[#{sprintf('%.2f', score)}]</a></b></center></p>"
	reviews.each do |review|
      post_html += Review.format(review)	  
	end
	p post_html
	post_html
  end
 
end
