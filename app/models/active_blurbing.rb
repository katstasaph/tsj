class ActiveBlurbing < ApplicationRecord
  belongs_to :song
  after_create :set_timeout
  
  scope :by_song, -> id { includes(:song).where(song_id: id) }
  
  WARNING_NOTIFICATION_TIMEOUT = 30
  
  def self.currently_blurbing?(blurber, song)
    self.exists?(:blurber => blurber, :song => song)
  end

  def self.create_blurbing_session(blurber, song)
    unless self.currently_blurbing?(blurber, song)
      ActiveBlurbing.create(blurber: blurber, song: song)
    end
  end
  
  # todo: this does not account for multiple blurbing sessions by a writer on a song (shouldn't happen, but...)
  def self.end_blurbing_session(blurber, song)
    session = self.find_by(:blurber => blurber, :song => song)
    if session 
      session.destroy
    end
  end
  
  private
  
  def set_timeout
    ExpireBlurbingSessionJob.set(wait: WARNING_NOTIFICATION_TIMEOUT.minutes).perform_later(self.id)
  end
end
