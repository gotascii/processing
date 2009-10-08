# require 'path/to/mycode.jar'
# makes the resources in mycode.jar discoverable by commands like import and include_package
# Java: org.foo.department.Widget
# Ruby: Java::OrgFooDepartment::Widget

# import org.foo.department.Widget
# after requiring, makes the Java class available only by its name
# only works with either Java-style names or strings, but not with the Java::PackagePath::Class variant
# importing a package name pulls all classes in like .* in java

# include_class, include_package
# used as an alternative to import to include a java class or entire package into module

# load_libraries
# require's java or ruby libraries that are in:
# SKETCH_ROOT/library
# RP5_ROOT/library

require 'ruby-processing'
require 'movable'
require 'billboardable'
require 'chargable'
require 'particles'
require 'particle'
require 'magnetism'
require 'gravity'
require 'friction'

class ParticleMagnet < Processing::App
  load_libraries :ocd
  import 'damkjer.ocd'

  def setup
    size(1000, 800, P3D)
    background(0)
    @key = {}
    @coded = {}
    @theta = 0
    @cam = Camera.new(self, 0, 0, 1000, 0, 0, 0)
    @electrons = Particles.new
    @magnetism = Magnetism.new(@electrons)

    100.times do |i|
      @electrons << Particle.new(@cam, 1, random_vector, -10)
    end

    # @electrons << Particle.new(@cam, 1, PVector.new(80, 80, 0), -200, color(255, 0, 0))
    # @electrons << Particle.new(@cam, 1, PVector.new(-80, -80, 0), 200, color(0, 255, 0))

    @gravitons = Particles.new
    @gravitons << Gravity.new(@cam, 1, PVector.new(0, 0, 0), -500, @electrons, 200)
    @gravitons << Gravity.new(@cam, 1, PVector.new(100, 0, 0), -500, @electrons, 200)
  end

  def draw
    @cam.feed
    background(0)

    @cam.circle(0.05) if @coded[RIGHT]
    @cam.circle(-0.05) if @coded[LEFT]

    @magnetism.act
    @gravitons.act
    @electrons.move
    @gravitons.constrain
    @electrons.display
    @gravitons.display
    puts frame_rate.to_s
  end

  def mouse_clicked
  end

  def key_pressed
    @key[key] = true
    @coded[key_code] = true if key == CODED

    @gravitons[0].field *= 4 if key == ' '
  end

  def key_released
    @key[key] = false
    @coded[key_code] = false if key == CODED

    @gravitons[0].field /= 4 if key == ' '
  end

  def random_vector
    randx = random(-400, 400)
    randy = random(-400, 400)
    randz = random(-300, 300)
    # randx = random(-100, 100)
    # randy = random(-100, 100)
    # randz = 0
    PVector.new(randx, randy, randz)
  end
end