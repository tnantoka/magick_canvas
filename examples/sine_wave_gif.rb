# frozen_string_literal: true

class Canvas < MagickCanvas::Base
  FREQUENCY = 5

  def options
    {
      width: 400,
      height: 200,
      number_of_frames: 60
    }
  end

  def draw(image, frame_count)
    range = -30.step(30, 2).to_a
    amplitude = (range + range.reverse)[frame_count]

    gc = Draw.new
    gc.stroke('white').stroke_width(1)
    gc.polyline(*points(amplitude))
    gc.draw(image)
  end

  private

  def points(amplitude)
    (0..width).flat_map do |x|
      [
        x,
        center.y + Math.sin(radians(x) * FREQUENCY) * amplitude
      ]
    end
  end
end
