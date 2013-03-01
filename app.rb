require './lib/image_processor'

class ImageServer < Sinatra::Base

  get '/' do
    image = ImageProcessor.new(params[:url], parsed_options).process
    send_file(image.store.path, :type => image.type, :disposition => "inline")
  end

  protected

    def parsed_options
      allowed_actions = [:url, :resize, :rotate, :quality, :crop]
      params.reject { |k| !allowed_actions.include?(k.to_sym) }
    end

end