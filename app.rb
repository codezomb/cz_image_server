require 'bundler/setup'
require 'sinatra/base'
require 'mini_magick'
require 'yaml'

class ImageServer < Sinatra::Base

  get '/:operation/:dimensions/*' do |operation, dimensions, url|
    url = sanitize_url(url)
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

  protected

    #
    # encode spaces and brackets
    #
    def sanitize_url(url)
      URI.parse(url)
    end

end

ImageServer.run!