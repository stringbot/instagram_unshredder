require 'unshred_support'

class UnshredApp < Processing::App
  include UnshredSupport

  def setup
    @image_file  = ARGV[0]
    @strip_width = ARGV[1].to_i

    puts "Unshredding #{@image_file} with strip width #{@strip_width}"

    if (@image_file)
      @image  = load_image(@image_file)
      @width  = @image.width
      @height = @image.height
    else
      raise "Please specify image filename"
    end

    puts "setup #{@height} #{@width}"
    size(@width,@height)
    no_loop
  end

  def draw
    strips = load_strips(@image).shuffle

    matches = Match.find_matches(strips)
    reassembled_image = reassemble(matches)
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

  def reassemble(matches)
    left_side_index = find_left_side_index(matches)
    compile_image(nil, left_side_index, matches).image
  end

  def compile_image(strip, left_index, matches)
    left_match = matches.find {|m| m.left.index == left_index }
    return strip if left_match.nil?

    strip ||= left_match.left

    right = left_match.right
    strip.join_right(right)

    next_left_index = right.index
    compile_image(strip, next_left_index, matches)
  end

  def find_left_side_index(matches)
    # we're finding the left edge by identifying the strip which appears
    # as a left side of a match but doesn't appear as a right side
    #
    # mathy shortcut: n + (n-1) + (n-2) ... + (n-n) => (n + 1) * (n/2)
    length = matches.length
    allsum = (length + 1) * (length * 0.5)

    # the sum of all the indices in the array minus the sum of
    # all the right indices reveals the one left_side index
    realsum = matches.inject(0) {|sum,m| sum + m.right.index}
    left_side_index = (allsum - realsum).floor
  end
end

image       = ARGV[0]
strip_width = ARGV[1]

UnshredApp.new :title => "Unshreddin", :image => image, :strip_width => strip_width
