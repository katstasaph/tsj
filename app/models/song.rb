class Song < ApplicationRecord
  include Rails.application.routes.url_helpers
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
  
  # Temporarily we are direct linking to blurber image storage until the WordPress upgrade issue is resolved

  TEMP_IMAGE_HOST = 'https://blurber.onrender.com'
  
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

  def update_score!
    scores = reviews.map { |review| review.score }
    self.score = scores.sum(0.00) / scores.length
    self.controversy = Song.calculate_controversy(scores, self.score)
    self.save
  end
  
  def self.schedule_post!(song, time, current_user)
    time = time.to_time(:utc).iso8601
    stripped_subhead = FormatterService.strip_subhead(song.subhead)
    image_link = song.pic.attached? ? TEMP_IMAGE_HOST + Rails.application.routes.url_helpers.rails_blob_path(song.pic, only_path: true) : ""
    html = self.generate_html(song, stripped_subhead, image_link)
    title = "#{song.artist} - #{song.title}"
    unless self.schedule_wp(time, title, stripped_subhead, html, current_user)
      return false
    end
	true
  end

  private  
  
  def self.generate_html(song, subhead, image_link)
    post_html = FormatterService.generate_post_frame(song, subhead, image_link)
    song.reviews.each { |review| post_html += FormatterService.generate_review(review)  }
    post_html
  end

  def self.schedule_wp(time, title, subhead, html, current_user)
      #true
      res = WordpressService.create_post(time, title, subhead, html, current_user)
	  p res
	  p res.code
      res && res.code == "201"
  end 
end
