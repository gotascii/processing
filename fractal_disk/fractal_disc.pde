float theta, r;

void setup() {
  size(400, 400);
  smooth();
  theta = 0;
}

void draw() {
  background(100);
  r = (sin(theta) + 1) * width/2;
  translate(width/2, height/2);
  circle(r);
  theta += 0.01;
}

void circle(float r) {
  ellipse(0, 0, r, r);
//  rotate(PI/4);
  if (r > 1) {
    circle(r -= 5);
  }
}
