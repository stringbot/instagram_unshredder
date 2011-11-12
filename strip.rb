module UnshredSupport

  WINDOW_SIZE = 60

  class Strip
    attr_accessor :image

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
      
    end

    # returns a color representing the difference of two given colors
    def self.color_diff(color1, color2)
      red   = red(color1)   - red(color2)
      green = green(color1) - green(color2)
      blue  = blue(color1)  - blue(color2)
      color(red,green,blue)
    end

    # calculates the average of a list of colors
    def self.average_color(colors)
      
    end

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
      @image.get(0,0,0,height).pixels
    end

    # the array of pixels making up the right edge of this strip
    def right_edge
      @image.get(x=width-1,0,x,height).pixels
    end

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
      Strip.diff(left_edge, other.right_edge)
    end

    # returns the difference between our right edge and the other strip's left edge
    def right_diff(other_strip)
      Strip.diff(right_edge, other.left_edge)
    end

    def print_edge(edge)
      out = ""
      for i in edge
        out << i
        out << " "
      end
    end
  end
end
