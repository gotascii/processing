module Movable
  include Processing::Proxy

  def self.included(base)
    base.class_eval do
      attr_accessor :mass, :coords, :pcoords
    end
  end

  def movable(mass, coords)
    @mass = mass
    @coords = coords
    @pcoords = coords
    reset
  end

  def reset
    @force = PVector.new(0, 0, 0)
  end

  def dist(p)
    coords.dist(p.coords)
  end

  def accelerate(force)
    @force.add(force)
  end

  def acceleration
    PVector.div(@force, mass)
  end

  def move
    a = acceleration
    ncoords = PVector.mult(coords, 1.9)
    ncoords = PVector.sub(ncoords, PVector.mult(pcoords, 0.9))
    ncoords = PVector.add(ncoords, a)
    self.pcoords = coords
    self.coords = ncoords
    reset
  end
end