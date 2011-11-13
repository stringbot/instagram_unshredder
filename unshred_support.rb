module UnshredSupport

  MAX_INT = (2**(0.size * 8 -2) -1)

  class Strip
    attr_accessor :image

    # === Getters ===

    # initialize with a slice of the image
    def initialize(image)
      @image = image
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

    def best_left_match(strips)
      min = MAX_INT
      min_idx = -1
      ledge = self.left_edge

      strips.each_with_index do |strip, idx|
        dist = Strip.edge_distance(ledge, strip.right_edge).floor
        next if dist == 0

        if dist < min
          min = dist
          min_idx = idx
        end
      end

      strips[min_idx]
    end

    def best_right_match(strips)
      min = MAX_INT
      min_idx = -1
      ledge = self.right_edge

      strips.each_with_index do |strip, idx|
        dist = Strip.edge_distance(ledge, strip.left_edge).floor
        next if dist == 0

        if dist < min
          min = dist
          min_idx = idx
        end
      end

      strips[min_idx]
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
      dists.inject(:+)
    end

    # print an edge's values to STDOUT
    def self.print_edge(edge)
      out = ""
      for i in edge
        out << color_string(i)
        out << " "
      end
      puts out
    end

    def self.color_string(color)
      r = (color >> 16) & 0xFF
      g = (color >> 8)  & 0xFF
      b =  color        & 0xFF
      "|#{r} #{g} #{b}|"
    end

    def self.image_string(image)
      w = image.width
      h = image.height
      "w:#{w} h:#{h}"
    end
  end
end
