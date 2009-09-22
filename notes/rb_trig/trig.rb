def dx(x, angle, radius)
  x + cos(radians(angle)) * radius
end

def dy(y, angle, radius)
  y + sin(radians(angle)) * radius
end

def draw_f
  stroke(200)
  f_angle = 0.0
  i = 0
  while f_angle < 360 do
    point(@x+@radius+i, dy(@y, f_angle, @radius))
    f_angle += @freq
    i += 1
  end
end

def draw_u
  noStroke
  fill(255)
  ellipse(@x, @y, @diameter, @diameter)
end

def draw_radius
  stroke(0)
  line(@x, @y, dx(@x, @u_angle, @radius), dy(@y, @u_angle, @radius))
  @u_angle += @freq
end

def draw_fx
  noStroke
  fill(0)
  @j = 0 if @u_angle%360 == 0
  ellipse(@x+@radius+@j, dy(@y, @u_angle, @radius), 5, 5)
  @j += @freq
end

def setup
  size(515, 150)
  smooth
  @u_angle = 0.0
  @x = 75.0
  @y = 75.0
  @radius = 50.0
  @diameter = @radius*2.0
  @freq = 1.0
  @j = 0.0
end

def draw
  background(127)
  draw_u
  draw_f
  draw_fx
  draw_radius
end