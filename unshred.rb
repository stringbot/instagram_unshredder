def setup
  size(640,359)
  @strip_width = 32
  @strip_height = 359

  @img = load_image("TokyoPanoramaShredded.png")
  @strips = load_strips(@img)
end

def draw
  assembled = assemble(@strips)
  image(assembled, 0, 0)
end

def load_strips(image)
  nstrips = image.width / @strip_width
  strips = []
  for i in (0...nstrips)
    strips << Strip.new(image.get(@strip_width * i, 0, @strip_width, image.height))
  end
  strips
end

def assemble(strips)
  # _width = strips.length * @strip_width
  # output = create_image(_width, @strip_height, RGB)

  # len = strips.length
  # for i in (0...len)
  #   output.set(i*@strip_width, 0, strips[len-i-1].image)
  # end

  # output

  Strip.join(strips[0], strips[1]).image
end




# def reassemble(strip, unordered)
#   return strip if unordered.empty?

#   for candidate in unordered.clone
#     strip.join_left(unordered.delete candidate) if strip.left_match(candidate)
#     strip.join_right(unordered.delete candidate) if strip.right_match(candidate)
#   end

#   reassemble(strip, unordered)
# end

class Strip
  attr_accessor :image

  def initialize(image)
    @image = image
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  def self.join(left_strip, right_strip)
    new_image = $app.create_image(left_strip.width*2, left_strip.height, RGB)
    new_image.set(0, 0, left_strip.image)
    new_image.set(left_strip.width, 0, right_strip.image)
    Strip.new(new_image)
  end
end

