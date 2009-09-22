# RB

require 'rubygems'
require 'complex'
require 'png'

module Fractals
  include Math 
  
  class Fractal    
    attr_accessor :z, :c, :width, :height, :m, :set_color, :algorithm, :theme    
    
    def initialize(c)      
      @c = c
      @width, @height, @m = 300, 300, 1.0 
      @set_color = PNG::Color::Black
      @algorithm = Algorithms::EscapeTime
      @theme = Themes::Fire        
    end
    
    def draw(file_name='fractal.png')      
      canvas = PNG::Canvas.new(@width, @height)
      0.upto(@width - 1) { |x|
        0.upto(@height - 1) { |y|          
          if in_set?(where_is?(x, y)) then            
            canvas[x, y] = @set_color
          else            
            r, g, b = *@theme.call(@algorithm.call(self))
            canvas[x, y] = PNG::Color.new(r, g, b, 255)         
          end
        }
      }   
      png = PNG.new(canvas)
      png.save(file_name)
    end   

    # @c is at the center of the screen
    # @width/2, @height/2 is the center point in the screen plane
    # 1/2 of the complex plane x axis == 1/2 the screen distance scaled: @width/2 * scale
    # to determine x location in complex plane start from the center complex point and move left
    # 1/2 the total x axis distance to the edge of the plane: @c.real - @width/2 * scale
    # then move right the x distance scaled: + (x * scale)
    def where_is?(x, y)
      r = @c.real - (@width / 2 * scale(@width)) + (x * scale(@width))
      i = @c.image - (@height / 2 * scale(@height)) + (y * scale(@height))      
      return Complex(r, i)
    end    
    
    private
    def scale(length)
      return (0.01 / @m) * (300.0 / length)
    end   
  end

  class Julia < Fractal    
    attr_accessor :bailout, :last_iteration, :max_iterations
    
    def initialize(c=Complex(0.36, 0.1), bailout=2, max_iterations=50)    
      super(c)
      @bailout, @max_iterations = bailout, max_iterations
    end

    def in_set?(z)
      @z = z
      @max_iterations.times { |i|
        @z = @z**2 + @c
        if @z.abs > @bailout then
          @last_iteration = i
          return false
        end      
      }      
      return true
    end
  end

  class Mandelbrot < Fractal    
    attr_accessor :bailout, :last_iteration, :max_iterations        
    
    def initialize(c=Complex(-0.65, 0.0), bailout=2, max_iterations=50)
      super(c)
      @bailout, @max_iterations = bailout, max_iterations
    end

    def in_set?(c)
      @z = 0
      @max_iterations.times { |i|
        @z = @z**2 + c
        if @z.abs > @bailout then       
          @last_iteration = i
          return false
        end            
      }      
      return true
    end
  end

  module Algorithms  
    EscapeTime = lambda { |fractal| (765 * fractal.last_iteration / fractal.max_iterations).abs }    
    
    NormalizedIterationCount = lambda { |fractal|   
      fractal.z = fractal.z**2 + fractal.c; fractal.last_iteration += 1
      fractal.z = fractal.z**2 + fractal.c; fractal.last_iteration += 1
    
      modulus = sqrt(fractal.z.real**2 + fractal.z.image**2).abs
      mu = fractal.last_iteration + log(2 * log(fractal.bailout)) - log(log(modulus)) / log(2)
    
      (mu / fractal.max_iterations * 765).to_i
    }   
  end
  
  module Themes
    Fire = lambda { |index|
      r, g, b = 0, 0, 0      
      if index >= 510
        r = 255
        g = 255
        b = index % 255
      elsif index >= 255
        r = 255
        g = index % 255   
      else
        r = index % 255
      end      
      return r, g, b
    }    
    
    Water = lambda { |index|      
      r, g, b = 0, 0, 0  
      if index >= 510
        r = index % 255
        g = 255 - r
      elsif index >= 255
        g = index - 255
        b = 255 - g       
      else
        b = index
      end       
      return r, g, b
    }
    
    None = lambda { |index| return 255, 255, 255 }
  end
end
