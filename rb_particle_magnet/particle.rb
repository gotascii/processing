class Particle
  include Processing::Proxy
  include Billboardable
  include Movable
  include Chargable

  attr_accessor :diameter, :fill_color

  def initialize(cam, mass, coords, charge, fill_color = nil)
    billboardable(cam)
    movable(mass, coords)
    chargable(charge)
    @diameter = 10
    @fill_color = fill_color || color(200)
  end

  def radius
    diameter/2
  end

  def display
    no_stroke
    fill(@fill_color)
    push_matrix
    translate(coords.x, coords.y, coords.z)
    face_cam
    ellipse(0, 0, diameter, diameter)
    pop_matrix
  end
end