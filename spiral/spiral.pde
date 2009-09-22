float x, y, theta;
float angle = 0;
float r = 0;
float d = 0;
void setup() {
  size(300, 300);
  background(255);
  smooth();
  noStroke();
  fill(0);
}

void draw() {
  theta = radians(angle);
  y = sin(theta) * r;
  x = cos(theta) * r;
  d += 0.005;
  ellipse(x + width/2, y + height/2, d, d);
  r += 0.05;
  angle += 1;
  angle %= 360;
}
