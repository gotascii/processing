def setup
  size 400, 400

  @graviton_coords = PVector.new(0, 0)
  @particle_pcoords = PVector.new(-50, -50)
  @graviton_radius = 50
  @particle_radius = 10

  # background(208)
  # translate(width/2, height/2)
  # d1 = 100
  # d2 = 120
  # 
  # v1 = PVector.new(10, 50)
  # v2 = PVector.new(60, 10)
  # 
  # fill(255, 200)
  # stroke(255, 0, 0)
  # ellipse(v1.x, v1.y, d1, d1)
  # ellipse(v2.x, v2.y, d2, d2)
  # 
  # r = d1/2 + d2/2
  # dist = v1.dist(v2)
  # 
  # if dist < r
  #   offset = r - dist
  #   offset /= 2
  #   dv = PVector.sub(v2, v1)
  #   dv.normalize
  #   dv.mult(offset)
  #   v2.add(dv)
  #   dv.mult(-1)
  #   v1.add(dv)
  #   stroke(0, 255, 0)
  #   ellipse(v1.x, v1.y, d1, d1)
  #   ellipse(v2.x, v2.y, d2, d2)
  # end
end

def draw
  background(208)
  translate(width/2, height/2)

  @particle_coords = PVector.new(mouse_x - width/2, mouse_y - height/2)

  stroke(0)
  ellipse(0, 0, @graviton_radius*2, @graviton_radius*2)
  ellipse(@particle_pcoords.x, @particle_pcoords.y, @particle_radius*2, @particle_radius*2)
  ellipse(@particle_coords.x, @particle_coords.y, @particle_radius*2, @particle_radius*2)

  g_distance = PVector.sub(@graviton_coords, @particle_pcoords)
  c_distance = PVector.sub(@particle_coords, @particle_pcoords)

  param = g_distance.dot(c_distance) / c_distance.mag**2

  if param < 0
    new_particle_coords = @particle_pcoords
  elsif param > 1
    new_particle_coords = @particle_coords
  else
    cp = PVector.mult(c_distance, param)
    new_particle_coords = PVector.add(@particle_pcoords, cp)
  end

  r = @graviton_radius + @particle_radius
  if new_particle_coords.mag < r
    new_particle_coords.normalize
    new_particle_coords.mult(r)
    stroke(255, 0, 0)
    ellipse(new_particle_coords.x, new_particle_coords.y, @particle_radius*2, @particle_radius*2)
  end
end