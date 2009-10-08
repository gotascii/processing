class Gravity
  include Processing::Proxy
  include Billboardable
  include Movable
  include Chargable

  attr_accessor :particles, :field

  def initialize(cam, mass, coords, charge, particles, field)
    billboardable(cam)
    movable(mass, coords)
    chargable(charge)
    @particles = particles
    @field = field
  end

  def act
    particles.each do |from|
      pull(from)
    end
  end

  def pull(from)
    distance = from.dist(self)
    f = charge / distance
    direction = PVector.sub(from.coords, coords)
    direction.normalize
    force = PVector.mult(direction, f)
    from.accelerate(force)
  end

  def constrain
    particles.each do |p|
      dist = coords.dist(p.coords)
      if dist < field
        diff_v = PVector.sub(p.coords, coords)
        offset = field - dist
        diff_v.normalize
        diff_v.mult(offset)
        p.coords.add(diff_v)
      end
    end
  end

  def display
    no_stroke
    push_matrix
    translate(coords.x, coords.y, coords.z)
    face_cam
    fill(15, 250)
    ellipse(0, 0, field*2, field*2)
    pop_matrix
  end
end