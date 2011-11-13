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
    @i = 0
  end

  def draw
    assembled = reassemble(@strips[0], @strips[1...@strips.length])
    image(assembled.image, 0, 0)
  end

  def load_strips(image)
    nstrips = image.width / @strip_width
    strips = []
    for i in (0...nstrips)
      strips << Strip.new(image.get(@strip_width * i, 0, @strip_width, image.height))
    end
    strips
  end

  def reassemble(strip, unordered)
    return strip if unordered.empty?

    # find the best candidates for match
    right_match = strip.best_right_match(unordered)
    left_match  = strip.best_left_match(unordered)

    # attach them
    strip.join_right(right_match)
    strip.join_left(left_match)

    # remove the matches from the candidate pool
    unordered.delete(right_match)
    unordered.delete(left_match)

    reassemble(strip, unordered)
  end
end

UnshredApp.new :title => "Unshreddin"
