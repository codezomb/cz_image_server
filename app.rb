require 'sinatra/base'
require 'mini_magick'

class ImageServer < Sinatra::Base

  get '/' do
    "CodeZombie Labs - Image Server"
  end

  get '/:operation/:dimensions/*' do |operation, dimensions, url|
    return "Missing URL" if url.empty?

    url = URI.parse(url)
    image = MiniMagick::Image.open("#{url.scheme}:/#{url.path}")
    image.combine_options do |i|
      i.filter    'box'
      i.resize    dimensions + "^^"
      i.gravity   'center'
      i.extent    dimensions
      i.quality   '80'
    end
    image.format("jpg")
    send_file(image.path, :type => "image/jpeg", :disposition => "inline")
  end

end