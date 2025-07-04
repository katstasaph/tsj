class WordpressService
  MEDIA_URI = 'https://www.thesinglesjukebox.com/index.php?rest_route=/wp/v2/media'
  POST_URI = 'https://thesinglesjukebox.com/wp-json/wp/v2/posts'

  def self.create_post(time, title, subhead, post, user)
     #res = self.upload_image(title, pic, user)
     #p res, res.body
     #if !res || res.code != '201' then return res end
    self.post_song(time, title, subhead, post, user)
  end

  private

  # Does not work due to WordPress image upload issue 
  # todo: implement workaround if necessary
  def self.upload_image(title, pic, user)
    uri = URI(MEDIA_URI)
    file = File.open(ActiveStorage::Blob.service.path_for(pic.key))
    req = Net::HTTP::Post.new(uri)
    req.basic_auth user.wp_username, user.wp_password
    req.set_form([['attachment', file]],  'multipart/form-data')
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(req)
    end
  end

  def self.post_song(time, title, subhead, post, user)  
    wp_username = user.wp_username
    wp_password = user.wp_password
    # Workaround for editors without correct credentials, I would rather not have this in here but circumstances are demanding it
    if user.editor_or_above? && (!wp_username || !wp_password)
      k = User.find_by(username: "katstasaph")
      wp_username = k.wp_username
      wp_password = k.wp_password
    end
    uri = URI(POST_URI)
    req = Net::HTTP::Post.new(uri)
    req.basic_auth wp_username, wp_password
    req['Content-Type'] = 'application/json'
    body = {
      status: "publish",
        title: title,
        date_gmt: time,
        excerpt: subhead,
        content: post
    }.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(req, body)
    end
  end
end