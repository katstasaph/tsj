class FormatterService
  # todo: remove styling from this and move it to the site css 
  
  def self.strip_subhead(subhead)
    subhead.body.to_s[34..-15]
  end
  
  def self.generate_post_frame(song, subhead, image_link)
    alt = song.alttext && song.alttext != "" ? song.alttext : "#{song.artist} - #{song.title}"
    score = song.score ? sprintf('%.2f', song.score) : "N/A" 
    controversy = song.controversy ? sprintf('%.2f', song.controversy) : "N/A" 
    post_html = "<p><i>#{subhead}</i></p><center><img src= '#{image_link}' alt = '#{alt}' border = 2><br><b>[<a href='#{song.video}'>Video</a>]"
    post_html += "<BR><a title='Controversy index: #{controversy}'>[#{score}]</a></b></center></p>"
  end

  def self.generate_review(review)
    stripped_blurb = review.content[5..-7]
    if review.url_present? then
      "<p><a href='#{review.url}' target='_blank'><strong>#{review.user.name}:</strong></a> #{stripped_blurb}<br>[#{review.score}]</p>"
    else
      "<p><strong>#{review.user.name}:</strong> #{stripped_blurb}<br>[#{review.score}]</p>"
    end
  end
end