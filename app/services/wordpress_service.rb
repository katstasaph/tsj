class WordpressService

def self.call(time, title, subhead, post, user)  
  uri = URI('https://www.thesinglesjukebox.com/index.php?rest_route=/wp/v2/posts')
  req = Net::HTTP::Post.new(uri)
  req.basic_auth user.wp_username, user.wp_password
  req['Content-Type'] = 'application/json'
  body = {
    status: "pending",
	date_gmt: time,
	title: title,
    excerpt: subhead,
	content: post
  }.to_json
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
    http.request(req, body)
  end
end
 
end

# VLyl bljL Vu63 mdVT wzla RvJi

