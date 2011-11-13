require 'unshred_support'

class UnshredApp < Processing::App
  include UnshredSupport

  def setup

    size(640,359)
    no_loop
    @strip_width = 32
    @strip_height = 359

    @img = load_image("TokyoPanoramaShredded.png")
    @strips = load_strips(@img)
  end

  def draw
    # assembled = assemble(@strips)
    # image(assembled, 0, 0)

    # Strip.print_edge(@strips[1].right_diff(@strips[2]))
    # Strip.subdivide(@strips[0].right_edge)
    v1 = PVector.new(255,255,255)
    v2 = PVector.new(240,240,240)
    v2.sub(v1)
    puts "#{v2.x} #{v2.y} #{v2.z}"

    render = @strips[0].image
    image(render,50,0)
  end

  def load_strips(image)
    nstrips = image.width / @strip_width
    strips = []
    for i in (0...nstrips)
      strips << Strip.new(image.get(@strip_width * i, 0, @strip_width, image.height))
    end
    strips
  end

  # returns the assembled image
  def assemble(strips)
    _width = strips.length * @strip_width
    output = create_image(_width, @strip_height, RGB)

    len = strips.length
    for i in (0...len)
      output.set(i*@strip_width, 0, strips[len-i-1].image)
    end

    output
  end


  # def reassemble(strip, unordered)
  #   return strip if unordered.empty?

  #   for candidate in unordered.clone
  #     strip.join_left(unordered.delete candidate) if strip.left_match(candidate)
  #     strip.join_right(unordered.delete candidate) if strip.right_match(candidate)
  #   end

  #   reassemble(strip, unordered)
  # end
end

UnshredApp.new :title => "Unshreddin"
