class ExpireEditLockJob < ApplicationJob
  queue_as :default

  def perform(review_id)
    review = Review.find(review_id)
    if review.edit_locked?
      review.edit_unlock!
    end
  end
end
