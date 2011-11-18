require 'unshred_support'

class UnshredApp < Processing::App
  include UnshredSupport

  def setup
    size(640,359)
    no_loop
    @strip_width = 32
    @strip_height = 359
  end

  def draw
    image  = load_image("TokyoPanoramaShredded.png")
    strips = load_strips(image)
    matches = find_matches(strips)

    reassembled_image = reassemble(nil, matches)
    image(reassembled_image, 0, 0)
  end

  def load_strips(image)
    nstrips = image.width / @strip_width
    strips = []
    for i in (0...nstrips)
      strips << Strip.new(image.get(@strip_width * i, 0, @strip_width, image.height), i)
    end
    strips
  end


  def find_matches(strips)
    matches = {}
    strips.each do |strip|
      match = strip.left_match(strips)
      if collision = matches[match.left]
        matches[match.left] = resolve_collision(collision, match)
      end
      puts match.inspect
      matches[match.left] = match
    end
    matches
  end

  # if the new distance is less than the old distance
  # replace the match with the new match and the other
  # match is the right_edge
  def resolve_collision(new, old)
    override = new.distance < old.distance
    if override
      return new
    else
      return old
    end
  end

  def reassemble(strip, matches)
    return strip if matches.empty?

    key, value = matches.first

  end
end

UnshredApp.new :title => "Unshreddin"
