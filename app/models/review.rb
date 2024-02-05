class Review < ApplicationRecord
  belongs_to :song
  belongs_to :user
  validates :score, :content, presence: true
  validates :user_id, uniqueness: { scope: [:song_id]}
  acts_as_list scope: :song
  
  default_scope { order(position: :asc) }
  scope :all_unpublished, -> { includes(:song, :user).where("songs.status != 2").references(:songs).by_created }
  scope :by_created, -> { reorder(created_at: :asc) }

  def self.format(review)
    stripped_blurb = review.content[5..-7]
    if review.user.url.present? then
      "<p><a href='#{review.user.url}' target='_blank'><strong>#{review.user.name}:</strong></a> #{stripped_blurb}<br>[#{review.score}]</p>"
    else
      "<p><strong>#{review.user.name}:</strong> #{stripped_blurb}<br>[#{review.score}]</p>"
    end
  end

  def by_user?(id) 
    self.user_id == id
  end
  
end
