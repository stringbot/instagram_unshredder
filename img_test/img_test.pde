void setup() {
  size(200,100);
  noLoop();
}

void draw() { 
  PImage img = loadImage("10x10.png");
  image(img,0,0,100,100);
  
  PImage img2 = createImage(10,10,ARGB);
  img2.copy(img,0,0,10,10,0,0,10,10);
  image(img2,100,0,100,100);
}
  
