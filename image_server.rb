require './image_processor'

class ImageServer < Sinatra::Base

  #
  # Image Options
  # Allowed domain defines what domain we're allowed to pull images from
  # Allowed actions defines what options we pass to the processor
  #
  # Gravity - Set the point from which the image should crop                (default: center)
  # Quality - Set the returned image Quality                                (default: 100   )
  # Resize  - Resolution for the returned image                             (default: none  )
  # Strip   - Strip all meta data from the returned image                   (default: false )
  # Crop    - Boolean, set to true when to crop the image, instead of scale (default: false )
  #
  configure do
    set :allowed_domain,  ''
    set :allowed_actions, [:gravity, :quality, :resize, :rotate, :strip, :crop]
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
  # Throws an ImageProcessor::ImageNotFound, if the image doesn't exist
  # TODO: Add more exceptions for various possible errors.
  #
  get "/i/:path" do |path|
    begin
      @image = ImageProcessor.new(parsed_url(path), parsed_options).process.store
      send_file(@image.path, :type => @image.type, :disposition => "inline")
    rescue ImageProcessor::ImageNotFound
      not_found { "That image could not be located." }
    end
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