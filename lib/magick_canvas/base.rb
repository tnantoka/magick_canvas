module MagickCanvas
  class Base
    include Magick
    extend Forwardable

    delegate %i[
      app width height columns rows
      number_of_frames background_color directory
    ] => :options_with_defaults

    def initialize
      self.image_list = ImageList.new
      self.center = Point.new(width * 0.5, height * 0.5)
    end

    def open
      write
      `hash open > /dev/null 2>&1 && open -a #{app} #{path}`
    end

    def write
      draw_frames
      image_list.write(path)
    end

    def radians(degrees)
      degrees * Math::PI / 180
    end

    private

    attr_accessor :image_list, :center

    def options
      {}
    end

    def options_with_defaults
      OpenStruct.new(default_options.merge(options)).tap do |merged|
        merged.columns = merged.width
        merged.rows = merged.height
      end
    end

    def default_options
      {
        app: 'Safari',
        width: 300,
        height: 300,
        number_of_frames: 1,
        background_color: 'black',
        directory: Dir.tmpdir
      }
    end

    def new_image
      bg_color = background_color
      image_list.new_image(columns, rows) { self.background_color = bg_color }
    end

    def gif?
      number_of_frames > 1
    end

    def filename
      extname = gif? ? 'gif' : 'png'
      "magick_canvas.#{extname}"
    end

    def path
      "#{directory}/#{filename}"
    end

    def draw(image, frame_count); end

    def draw_frames
      number_of_frames.times do |i|
        draw(new_image, i)
      end
    end
  end
end
