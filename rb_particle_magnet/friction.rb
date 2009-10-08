class Friction
  attr_accessor :particles, :mu
  
  def initialize(particles, mu)
    @particles = particles
    @mu = mu
  end

  def act
    particles.each do |p|
      p.velocity.mult(mu)
    end
  end
end