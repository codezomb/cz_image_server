# TODO: Cleanup Temp file

require './lib/image_processor'

class ImageServer < Sinatra::Base

  get '/' do
    image = ImageProcessor.new(params[:url], parsed_options).process.store
    send_file(image.path, :type => "image/jpeg", :disposition => "inline")
  end

  protected

    def parsed_options
      allowed_actions = [:resize, :rotate, :quality, :crop]
      allowed_actions.inject({}) do |hsh, key|
        hsh[key] = params[key]
        hsh
      end
    end

end