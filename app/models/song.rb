class Song < ApplicationRecord
  enum :status, [ :open, :closed, :published ]
  has_rich_text :subhead
  has_many :reviews, dependent: :destroy
    accepts_nested_attributes_for :reviews, allow_destroy: true
  has_one_attached :pic
  
  validates :artist, :title, presence: true
  validates :audio, :uniqueness => {:allow_blank => true}
  validates :video, :uniqueness => {:allow_blank => true}

  attribute :user_written
  attribute :user_review_id  
  attribute :score
  attribute :controversy
  
  scope :with_reviews_and_users, -> { includes(reviews: :user) }
  scope :by_created, -> { includes(:reviews).order('created_at ASC') }
  
  # todo: this should probably be not here
  
  def self.list_available(songs, current_user)
    songs.map do |song|
      written = false
      song.reviews.each do |review|
	    if review.by_user?(current_user.id)
          written = true
          song[:user_review_id] = review.id
          break    
        end
      end
      song[:user_written] = written
      song
    end
  end
  
  def self.calculate_controversy(scores, mean)
    distances = scores.map { |score| (score - mean).abs }
    avedev = distances.sum(0.00) / distances.length
    multiplier = 1 + ([0, 0.02 * (scores.length - 8)].max)
	avedev * multiplier
  end
  
  def self.collate_blurbs(subhead, video, score, controversy, reviews)
    post_html = "<p><i>#{subhead}</i></p><center><p><img src= '' border = 2><b>[<a href='#{video}'>Video</a>]<BR><a title='Controversy index: #{sprintf('%.2f', controversy)}'>[#{sprintf('%.2f', score)}]</a></b></center></p>"
    reviews.each { |review| post_html += Review.format(review)  }
    post_html
  end
  
  def update_score!
    scores = reviews.map { |review| review.score }
    self.score = scores.sum(0.00) / scores.length
	self.controversy = Song.calculate_controversy(scores, self.score)
	self.save
  end
 
end
