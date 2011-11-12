PImage img;
Strip[] strips;
int stripWidth = 32;
  
void setup() {
  size(640,359);
  img = loadImage("TokyoPanoramaShredded.png");
  
  strips = loadStrips(img, stripWidth);
}


void draw() {
  PImage assembled = assembleStrips(strips, stripWidth);
  image(assembled, 0, 0);
}

// disassemble the image into an array of strips of known width
Strip[] loadStrips(PImage img, int stripWidth) {
  int nStrips = img.width / stripWidth;
  Strip[] strips = new Strip[nStrips];
  for(int i=0;i < nStrips;i++) {
    strips[i] = new Strip(img.get(stripWidth * i, 0, stripWidth, img.height));
  }
  return strips; 
}

PImage assembleStrips(Strip[] strips, int stripWidth) {
  int _width = strips.length * stripWidth;
  PImage output = createImage(_width, img.height, RGB);
  
  // for starters we'll just reverse the strips
  int j = 0;
  for(int i=strips.length-1;i>=0;i--) {
    output.set(i*stripWidth, 0, strips[j].getImage());
    
    
    j++;
  }
  
  return output;
}

void printEdge(int[] edge) { 
  StringBuffer buf = new StringBuffer("");
  for(int i=0;i<edge.length;i++) {
    buf.append(edge[i].toString());
  }
  println(buf.toString());
}

class Strip {
  PImage img;
  
  public Strip(PImage _img) {
    this.img = _img;
  }
  
  public int[] leftEdge() {
    return this.img.get(0,0,0,img.height-1).pixels; 
  }
  
  public int[] rightEdge() {
    int x = img.width-1;
    return this.img.get(x,0,x,img.height-1).pixels;
  }
  
  public static int[] diff(int[] edge1, int[] edge2) {
    int len = edge1.length;
    diff = new int[len];
    for(int i=0;i<len;i++) {
      diff[i] = edge1[i] - edge2[i];
    }
    return diff;
  }
  
  public static PImage join(Strip left, Strip right) {
  }
  
  public int[] leftDiff(Strip other) {
    return Strip.diff(this.leftEdge(), other.rightEdge());
  }
  
  public int[] rightDiff(Strip other) {
    return Strip.diff(this.rightEdge(), other.leftEdge());
  }
  
  public void joinLeft(Strip left) {
    
  }
 
  public PImage getImage() {
    return this.img;
  }
}


