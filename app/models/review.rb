class Review < ApplicationRecord
  belongs_to :song
  belongs_to :user
  validates :score, :content, presence: true
  validates :user_id, uniqueness: { scope: [:song_id]}
  acts_as_list
  
  default_scope { order(position: :asc) }
  scope :by_created, -> { reorder(created_at: :asc) }


  def self.format(review)
    "<p><a href='#{review.user.url}' target='_blank'><strong>#{review.user.name}:</strong></a> #{review.content}<br>[#{review.score}]</p>"
  end
  
end
