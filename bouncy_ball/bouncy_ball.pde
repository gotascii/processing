int numBalls = 12;
float gravity = 0.1;
float friction = -0.9;
Ball b;

void setup() 
{
  size(640, 200);
  noStroke();
  smooth();
  b = new Ball(random(width), 0, 20);
}

void draw() 
{
  background(0);
  b.move();
  b.display();
}

class Ball {
  float x, y;
  float diameter;
  float radius;
  float vy = 0;
 
  Ball(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diameter = din;
    radius = diameter/2;
  } 

  void move() {
    vy += gravity;
    y += vy;
    if (y + radius > height) {
      y = height - radius;
      vy *= friction;
    }
  }
  
  void display() {
    fill(255, 204);
    ellipse(x, y, diameter, diameter);
  }
}
