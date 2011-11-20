module UnshredSupport

  MAX_INT = (2**(0.size * 8 -2) -1)

  class Match
    attr_accessor :left, :right, :distance

    def initialize(left, right, distance)
      @left     = left
      @right    = right
      @distance = distance
    end

    def inspect
      "left:%4s right:%4s distance:%6s" % [@left.index, @right.index, @distance]
    end

    def self.find_matches(strips)
      matches = {}
      strips.each do |strip|
        match = strip.left_match(strips)
        if collision = matches[match.left]
          matches[match.left] = resolve_collision(collision, match)
        else
          matches[match.left] = match
        end
      end
      matches.values
    end

    # if the new distance is less than the old distance
    # replace the match with the new match and the other
    # match is the right_edge
    def self.resolve_collision(new, old)
      override = new.distance < old.distance
      if override
        return new
      else
        return old
      end
    end
  end

  class Strip
    attr_accessor :image, :index

    # === Getters ===

    # initialize with a slice of the image
    def initialize(image, index)
      @image = image
      @index = index
    end

    # width of this slice
    def width
      @image.width
    end

    # height of this slice
    def height
      @image.height
    end

    # the array of pixels making up the left edge of this strip
    def left_edge
      @image.get(0,0,1,height).pixels
    end

    # the array of pixels making up the right edge of this strip
    def right_edge
      x = width-1
      @image.get(x,0,x,height).pixels
    end



    # === Operations ===

    # attach another strip to the left side of this one
    def join_left(left_strip)
      @image = Strip.join(left_strip, self)
      return self
    end

    # attach another strip to the right side of this one
    def join_right(right_strip)
      @image = Strip.join(self, right_strip)
      return self
    end

    def match(left, strips)
      min = MAX_INT
      min_idx = -1
      edge = left ? self.left_edge : self.right_edge

      strips.each_with_index do |strip, idx|
        next if strip == self
        other = left ? strip.right_edge : strip.left_edge
        dist = Strip.edge_distance(edge, other).floor

        if dist < min
          min = dist
          min_idx = idx
        end
      end

      match_args = [self, strips[min_idx]]
      if left # if we're doing a left match we want self on the right
        match_args.reverse!
      end

      left, right = match_args
      Match.new(left, right, min)
    end


    def left_match(strips)
      match(true, strips)
    end

    def right_match(strips)
      match(false, strips)
    end


    # === Class Methods ===

    # joins two strips together. currently this returns a new PImage instead of
    # a new Strip FIXME make the API symmetrical by returning a Strip
    def self.join(left_strip, right_strip)
      new_image = $app.create_image(left_strip.width+right_strip.width, left_strip.height, RGB)

      new_image.copy(left_strip.image, 0, 0,
                                       left_strip.width, left_strip.height,
                                       0, 0,
                                       left_strip.width, left_strip.height)


      new_image.copy(right_strip.image, 0, 0,
                                        right_strip.width, right_strip.height,
                                        left_strip.width, 0,
                                        right_strip.width, right_strip.height)
      new_image
    end

    # creates a PVector corresponding to the specified color
    def self.color_vector(color)
      red   = (color >> 16) & 0xFF
      green = (color >> 8) & 0xFF
      blue  = color & 0xFF

      PVector.new(red, green, blue)
    end

    # euclidean distance between colors
    def self.color_distance(color1, color2)
      v1 = color_vector color1
      v2 = color_vector color2
      v1.dist(v2)
    end

    def self.edge_distance(left, right)
      dists = []
      left.each_with_index do |lcolor, idx|
        dists << color_distance(lcolor, right[idx])
      end

      # mean = dists.inject(:+) / dists.length
      # stdev = Math::sqrt(dists.inject(0) {|sum,dist| sum + ((dist-mean)**2)} / dists.length)
      # mean
      dists.inject(:+)
    end
  end

end
