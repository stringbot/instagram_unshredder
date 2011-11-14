def setup
  size(200,100);
  no_loop
end

def draw
  ig = load_image("10x10.png")
  image(ig,0,0,100,100)

  ig2 = create_image(10,10,RGB)
  ig2.copy(ig,0,0,10,10,0,0,10,10)
  image(ig2,100,0,100,100)
end
