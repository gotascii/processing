class Magnetism
  include Processing::Proxy

  attr_accessor :particles

  def initialize(particles)
    @particles = particles
  end

  def act
    ps = particles.particles
    len = ps.length
    visited = Java::boolean[len][len].new
    for i in 0...len
      for j in 0...len
        pi = ps[i]
        pj = ps[j]
        if pi != pj && !visited[i][j]
          force = pull(pi, pj)
          force.mult(-1)
          pi.accelerate(force)
          visited[j][i] = true
        end
      end
    end
  end

  def pull(to, from)
    distance = from.dist(to)
    e = to.charge / distance**2
    f = from.charge * e
    direction = PVector.sub(from.coords, to.coords)
    direction.normalize
    force = PVector.mult(direction, f)
    from.accelerate(force)
    force
  end

  def constrain
    # particles.nsquared do |pi, pj|
    #   distance = PVector.sub(pj.coords, pi.pcoords)
    #   change = PVector.sub(pi.coords, pi.pcoords)
    #   param = distance.dot(change) / change.mag**2
    # 
    #   if param < 0
    #     ncoords = pi.pcoords
    #   elsif param > 1
    #     ncoords = pi.coords
    #   else
    #     cp = PVector.mult(change, param)
    #     ncoords = PVector.add(pi.pcoords, cp)
    #   end
    # 
    #   radius = pi.radius + pj.radius
    # 
    #   if ncoords.mag < radius
    #     ncoords.normalize
    #     ncoords.mult(radius)
    #     pi.coords = ncoords
    #   end
    # end
  end

  def display
    particles.nsquared do |pi, pj|
      display_lines(pi, pj)
    end
  end

  def display_lines(pi, pj)
    distance = pi.dist(pj)
    len = (distance/2)
    if distance < 150
      dv = PVector.sub(pj.coords, pi.coords)
      dv.normalize
      len.to_i.times do |x|
        if x > (len - 5)
          stroke(128, 0, 0)
        elsif x > (len - 10)
          no_stroke
        else
          stroke(30, 10);
        end
        cv = PVector.mult(dv, x)
        cv.add(pi.coords)
        point(cv.x, cv.y, cv.z)
      end
    end
  end
end