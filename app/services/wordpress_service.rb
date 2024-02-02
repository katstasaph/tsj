class WordpressService
  MEDIA_URI = 'https://www.thesinglesjukebox.com/index.php?rest_route=/wp/v2/media'
  POST_URI = 'https://www.thesinglesjukebox.com/index.php?rest_route=/wp/v2/posts'

  def self.create_post(time, title, subhead, post, user)
    # res = self.upload_image(title, pic, user)
    # p res, res.body
    # if !res || res.code != '201' then return res end
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
    uri = URI(POST_URI)
    req = Net::HTTP::Post.new(uri)
    req.basic_auth user.wp_username, user.wp_password
    req['Content-Type'] = 'application/json'
    body = {
      status: "pending",
          title: title,
        date: time,
      excerpt: subhead,
        content: post
    }.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(req, body)
    end
  end
end