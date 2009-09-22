require 'fractals/fractals'
require 'png'
include Fractals

mandelbrot = Mandelbrot.new(Complex(-0.65, 0.0), 2, 50)
mandelbrot.m = 2
mandelbrot.algorithm = Algorithms::EscapeTime
# mandelbrot.draw('mandelbrot_escape_time.png')
mandelbrot.algorithm = Algorithms::NormalizedIterationCount
#mandelbrot.draw('mandelbrot_normalized.png')

misiurewicz = Mandelbrot.new(Complex(-0.1011, 0.9563), 2, 50)
misiurewicz.m = 50
misiurewicz.algorithm = Algorithms::NormalizedIterationCount
#misiurewicz.draw('misiurewicz.png')

feigenbaum = Mandelbrot.new(Complex(-0.1528, 1.0397), 2, 50)
feigenbaum.m = 50
feigenbaum.algorithm = Algorithms::NormalizedIterationCount
feigenbaum.theme = Themes::Water
#feigenbaum.draw('feigenbaum.png')

seahorse_valley = Mandelbrot.new(Complex(-0.8759, 0.2046), 2, 50)
seahorse_valley.m = 6
seahorse_valley.algorithm = Algorithms::NormalizedIterationCount
seahorse_valley.theme = Themes::Water
#seahorse_valley.draw('seahorse_valley.png')

snowflakes = Julia.new(Complex(-0.3007, 0.6601), 5, 100)
snowflakes.width = 350
snowflakes.height = 350
snowflakes.m = 2
snowflakes.set_color = PNG::Color::White
snowflakes.algorithm = Algorithms::NormalizedIterationCount
snowflakes.theme = lambda { |index|
  r, g, b = 0, 0, 0      
  if index >= 510
    r = 0
    g = 255 % index
    b = 255
  elsif index >= 255
    r = 0
    g = index % 255
    b = 255
  else    
    b = index % 255
  end      
  return r, g, b
}
#snowflakes.draw('snowflakes.png')

# Don't draw antenna unless you've got a few minutes.
antenna = Mandelbrot.new(Complex(-0.743643135, 0.131825963), 2, 1500)
antenna.m = 210350
#antenna.draw('antenna.png')