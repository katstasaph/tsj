class Review < ApplicationRecord
  belongs_to :song
  belongs_to :user
  delegate  :name, :url, to: :user
  validates :score, :content, presence: true
  validates :user_id, uniqueness: { scope: [:song_id]}
  acts_as_list scope: :song
  
  default_scope { order(position: :asc) }
  scope :all_unpublished, -> { includes(:song, :user).where("songs.status != 2").references(:songs).by_created }
  scope :by_created, -> { reorder(created_at: :asc) }

  def url_present?
    return self.url.present?
  end

  def self.format(review)
    FormatterService.generate_review(review)
  end

  def by_user?(id) 
    self.user_id == id
  end
  
end
