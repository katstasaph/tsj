class Song < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Schedulable
  
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
  
  before_create do |song| 
    song.status ||= 0
    song.month_year = Schedulable.next_posting_month
  end
  
  def self.list_available(songs, current_user)
    songs.where(["month_year = ?", Schedulable.current_posting_month]).map do |song|
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
  
  def generate_html
    stripped_subhead = FormatterService.strip_subhead(self.subhead)
    image_link = self.image_url
    post_html = FormatterService.generate_post_frame(self, stripped_subhead, image_link)
    self.reviews.each { |review| post_html += FormatterService.generate_review(review)  }
    post_html
  end
  
  def self.schedule_post!(song, time, current_user)
    time = time.to_time(:utc).iso8601
    stripped_subhead = FormatterService.strip_subhead(song.subhead)
    html = song.generate_html
    title = "#{song.artist} - #{song.title}"
    unless self.schedule_wp(time, title, stripped_subhead, html, current_user)
      return false
    end
    true
  end
  
  def register_blurbing_session(blurber)
    ActiveBlurbing.create_blurbing_session(blurber.name, self)
  end
  
  def end_blurbing_session(blurber)
    ActiveBlurbing.end_blurbing_session(blurber.name, self)
  end
  
  def current_blurbers
    ActiveBlurbing.by_song(self.id).pluck(:blurber).join(", ")
  end

  private  
  
  def image_url
    self.pic.attached? ? TEMP_IMAGE_HOST + Rails.application.routes.url_helpers.rails_blob_path(self.pic, only_path: true) : ""
  end

  def self.schedule_wp(time, title, subhead, html, current_user)
    #true
    res = WordpressService.create_post(time, title, subhead, html, current_user)
    p res
    res && res.code == "201"
  end 
end
