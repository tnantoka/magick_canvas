# frozen_string_literal: true

module MagickCanvas
  class Base
    include Magick
    extend ::Forwardable

    delegate %i[
      app width height columns rows
      number_of_frames frame_steps iterations
      background_color
    ] => :options_with_defaults
    delegate %i[write] => :image_list

    class << self
      def descendants
        ObjectSpace.each_object(Class).select { |klass| klass < self }
      end
    end

    def initialize
      self.image_list = ImageList.new
      self.center = Point.new(width * 0.5, height * 0.5)
    end

    def save(path, &block)
      draw_frames(&block)
      image_list.iterations = iterations.to_i
      write(path)
      yield if block_given?
    end

    def radians(degrees)
      degrees * Math::PI / 180
    end

    def extname
      gif? ? 'gif' : 'png'
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
        frame_steps: 1,
        iterations: nil,
        background_color: 'black'
      }
    end

    def new_image
      bg_color = background_color
      image_list.new_image(columns, rows) { self.background_color = bg_color }
    end

    def gif?
      number_of_frames > 1
    end

    def update(frame_count); end

    def draw(image, frame_count); end

    def draw_frames
      number_of_frames.times do |i|
        update(i)
        draw(new_image, i) if (i % frame_steps).zero?
        yield(i) if block_given?
      end
    end
  end
end
