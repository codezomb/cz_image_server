require 'mini_magick'
require 'securerandom'

class ImageProcessor

  attr_accessor :path

  #
  # Standard Initializer
  #
  def initialize(image, options={})
    @image   = MiniMagick::Image.open(image)
    @options = options
    @path    = "#{Dir.pwd}/tmp/"
  end

  #
  # Return the quality passed, or default to 100%
  #
  def quality
    @options[:quality] || '100%'
  end

  #
  # Return the orientation passed, or 0 as a string
  #
  def rotate
    if @options[:rotate]
      orientation = @options[:rotate].to_i
      if orientation.between?(-360, 360)
        rotation = orientation.to_s
      end
    end || '0'
  end

  #
  # Return the resize passed, or the existing image dimensions as a string
  #
  def dimensions
    @options[:resize] || @image[:dimensions].join('x')
  end

  #
  # If true, the image will be cropped to fit into the given resize as a string
  #
  def extent
    cols, rows = @image[:dimensions]
    width, height = dimensions.split('x')

    if @options[:crop]
      if width != cols || height != rows
        scale = [width.to_i/cols.to_f, height.to_i/rows.to_f].max
        cols = (scale * (cols + 0.5)).round
        rows = (scale * (rows + 0.5)).round
      end
    else
      cols, rows = [width, height]
    end

    "#{cols}x#{rows}"
  end

  #
  # Do the processing, and return the image
  #
  def process
    if @options.any?
      @image.combine_options do |c|
        c.strip
        c.filter  'box'
        c.gravity 'center'
        c.quality quality
        c.resize  extent
        c.rotate  rotate
        c.extent  dimensions if @options[:crop]
      end
    end
    @image.format("jpg2000")
    self
  end

  #
  # Create a new tempfile
  #
  def store
    begin
      filename = "#{SecureRandom.hex}.jpg"
    end while File.exists?("#{@path}#{filename}")
    @image.write(@path << filename)
    self
  end

end