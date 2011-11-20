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

    matches.each do |match|
      puts match.inspect
    end

    reassembled_image = reassemble(matches)
    image(reassembled_image.image, 0, 0)
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
      matches[match.left] = match
    end
    matches.values
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

  def reassemble(matches)
    # we're finding the left edge by identifying the strip which appears
    # as a left side of a match but doesn't appear as a right side
    #
    # mathy shortcut: n + (n-1) + (n-2) ... + (n-n) => (n + 1) * (n/2)
    length = matches.length
    allsum = (length + 1) * (length * 0.5)

    # the sum of all the indices in the array minus the sum of
    # all the right indices reveals the one missing index
    realsum = matches.inject(0) {|sum,m| sum + m.right.index}
    missing_index = (allsum - realsum).floor


    left_match = matches.find {|m| m.left.index == missing_index }
    matches.delete left_match

    reassemble2(left_match.left, left_match, matches)
  end

  def reassemble2(strip, left_match, matches)
    return strip if matches.empty?

    right = left_match.right
    next_left_index = right.index
    strip.join_right(right)

    next_left = matches.find { |m| m.left.index == next_left_index }
    matches.delete next_left
    puts "Next left index: %s" % next_left.left.index
    reassemble2(strip, next_left, matches)
  end

end

UnshredApp.new :title => "Unshreddin"
