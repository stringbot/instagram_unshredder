module UnshredSupport

  WINDOW_SIZE = 60

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

    # returns true if the supplied strip matches this strips's left edge
    def left_match(left_strip)
    end

    # returns true if the supplied strip matches this strips's right edge
    def right_match(right_strip)
    end

    # returns the difference between our left edge and the other strip's right edge
    def left_diff(other_strip)
      Strip.diff(left_edge, other_strip.right_edge)
    end

    # returns the difference between our right edge and the other strip's left edge
    def right_diff(other_strip)
      Strip.diff(right_edge, other_strip.left_edge)
    end



    # === Class Methods ===

    # joins two strips together. currently this returns a new PImage instead of
    # a new Strip FIXME make the API symmetrical by returning a Strip
    def self.join(left_strip, right_strip)
      new_image = $app.create_image(left_strip.width+right_strip.width, left_strip.height, RGB)
      new_image.copy(left_strip.image, 0, 0, left_strip.width, left_strip.height,
                                       0, 0, left_strip.width, left_strip.height)


      new_image.copy(right_strip.image, 0, 0, right_strip.width, right_strip.height,
                                        left_strip.width, 0, right_strip.width, right_strip.height)
      new_image
    end

    # compares two edges and returns a value representing the degree of difference
    def self.diff(edge1, edge2)
      diff = []
      #divide into windows
      windows1 = subdivide(edge1)
      windows2 = subdivide(edge2)

      #reduce to averages for each window
      avg_win1 = windows1.map do |w|
        average_color(w)
      end

      avg_win2 = windows2.map do |w|
        average_color(w)
      end

      puts "avg_win1: #{avg_win1.inspect} avg_win2: #{avg_win2.inspect}"

      #diff the averages
      avgs = []
      for i in (0...avg_win1.length)
        avgs << color_diff(avg_win1[i], avg_win2[i])
      end
      avgs
    end

    # divides an edge into n_divisions windows of WINDOW_SIZE size
    def self.subdivide(edge)
      n_divisions = edge.length / WINDOW_SIZE
      windows = []
      for i in (0...n_divisions)
        start = i * WINDOW_SIZE
        windows << edge[start...start+WINDOW_SIZE]
      end
      windows
    end

    # returns a color representing the difference of two given colors
    def self.color_diff(color1, color2)
      red   = $app.red(color1)   - $app.red(color2)
      green = $app.green(color1) - $app.green(color2)
      blue  = $app.blue(color1)  - $app.blue(color2)
      $app.color(red,green,blue)
    end

    # calculates the average of a list of colors
    def self.average_color(colors)
      reds   = colors.map { |c| (c >> 16) & 0xFF }
      greens = colors.map { |c| (c >> 8) & 0xFF }
      blues  = colors.map { |c|  c & 0xFF }

      avg_red   = reds.inject(:+).to_f / reds.size
      avg_green = greens.inject(:+).to_f / greens.size
      avg_blue  = blues.inject(:+).to_f / blues.size

      $app.color(avg_red.floor, avg_green.floor, avg_blue.floor)
    end

    # print an edge's values to STDOUT
    def self.print_edge(edge)
      out = ""
      for i in edge
        out << i.to_s
        out << " "
      end
      puts out
    end
  end
end
