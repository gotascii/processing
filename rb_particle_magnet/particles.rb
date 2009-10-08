class Particles
  include Processing::Proxy

  attr_accessor :particles

  def initialize()
    @particles = []
  end

  def [](index)
    @particles[index]
  end

  def <<(particle)
    add(particle)
  end

  def add(particle)
    particles << particle
  end

  def display
    each {|p| p.display}
  end
  
  def act
    each {|p| p.act}
  end
  
  def move
    each {|p| p.move}
  end

  def constrain
    each {|p| p.constrain}
  end

  def each(&block)
    particles.each do |p|
      block.call(p)
    end
  end

  def nsquared(&block)
    particles.each do |pi|
      particles.each do |pj|
        block.call(pi, pj) if pi != pj
      end
    end
  end
end