class Review < ApplicationRecord
  belongs_to :song
  belongs_to :user
  delegate  :name, :url, to: :user
  validates :score, :content, presence: true
  validates :user_id, uniqueness: { scope: [:song_id]}
  acts_as_list scope: :song
  
  default_scope { order(position: :asc) }
  scope :all_unpublished, -> { includes(:song, :user).where("songs.status != 2").references(:songs).by_created }
  scope :all_open, -> { includes(:song, :user).where("songs.status = 0").references(:songs).by_created }
  scope :by_created, -> { reorder(created_at: :asc) }
  scope :by_user, -> id { includes(:song, :user).where(user_id: id) }

  EDIT_LOCK_TIMEOUT = 30

  def url_present?
    return self.url.present?
  end

  def self.format(review)
    FormatterService.generate_review(review)
  end

  def by_user?(id) 
    self.user_id == id
  end
  
  def can_edit?(name)
    !self.locked? || self.current_editor == name
  end
  
  def locked?
    !!self.current_editor
  end
  
  def lock!(name)
    unless self.current_editor == name
      self.current_editor = name
      self.save
      ExpireEditLockJob.set(wait: EDIT_LOCK_TIMEOUT.minutes).perform_later(self.id)
    end    
  end
  
  def unlock!
    self.current_editor = nil
    self.save
  end

end
