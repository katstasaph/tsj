module ReviewsHelper
  def inline_review_edit?
    referrer = Rails.application.routes.recognize_path(request.referrer) 
	referrer[:controller] == "songs" && referrer[:action] == "show"
  end
end
