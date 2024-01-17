json.extract! review, :id, :content, :rich_text, :score, :song_id, :users_id, :created_at, :updated_at
json.url review_url(review, format: :json)