class ExpireEditLockJob < ApplicationJob
  queue_as :default

  def perform(review_id)
    review = Review.find(review_id)
    if review.locked?
      review.unlock!
    end
  end
end
