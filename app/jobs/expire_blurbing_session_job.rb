class ExpireBlurbingSessionJob < ApplicationJob
  queue_as :default

  def perform(session_id)
    session = ActiveBlurbing.find_by(id: session_id)
    if session
      session.destroy
    end
  end
end
