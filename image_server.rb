require './image_processor'

class ImageServer < Sinatra::Base

  configure do
    set :allowed_domain,  'https://aperture-store.s3.amazonaws.com'
    set :allowed_actions, [:resize, :rotate, :quality, :crop]
  end

  #
  # Redirect to codezombie.org
  #
  get "/" do
    redirect "http://codezombie.org"
  end

  #
  # Example
  # /i/IMG_3821.JPG?resize=300x300&rotate=90&crop=true&quality=80
  #
  get "/i/:path" do |path|
    image = ImageProcessor.new(parsed_url(path), parsed_options)
    send_file(image.process.store.path, :type => image.type, :disposition => "inline")
  end

  protected

    #
    # Filter out any unwanted params
    #
    def parsed_options
      params.reject { |k| !settings.allowed_actions.include?(k.to_sym) }
    end

    #
    # Append the path to the allowed_domain
    #
    def parsed_url(path)
      "#{settings.allowed_domain}/#{path}"
    end

end