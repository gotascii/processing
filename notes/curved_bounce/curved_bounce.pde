void setup() {
  fill(100, 100);
  stroke(255);
  size(400, 400);
}

void draw() {
  background(0);
  translate(width/2, height/2); 
  circles();
}

void circles() {
  // Gravity
  PVector c1 = new PVector(0, 0);
  float d1 = 100;
  float r1 = d1/2;

  // Particle
  PVector c2 = new PVector(0, -70);

  // v, red, velocity
  PVector v = new PVector(-100, 100);
  stroke(255, 0, 0);
  line(c2.x, c2.y, c2.x + v.x, c2.y + v.y);

  float d2 = 50;
  float r2 = d2/2;

  stroke(255);
  ellipse(c1.x, c1.y, d1, d1);
  ellipse(c2.x, c2.y, d2, d2);

  // n, green, difference
  PVector n = new PVector(c2.x - c1.x, c2.y - c1.y);
  stroke(0, 255, 0);
  line(c1.x, c1.y, c1.x + n.x, c1.y + n.y);

  // blue, reflection
  PVector reflection = reflect(n, v);
  stroke(0, 0, 255);
  line(c2.x, c2.y, c2.x + reflection.x, c2.y + reflection.y);
}

void lines() {
  PVector n = new PVector(0, -100);
  PVector v = new PVector(-100, 50);
  stroke(255, 0, 0);
  line(0, 0, n.x, n.y);

  stroke(0, 255, 0);
  line(0, 0, v.x, v.y);

  PVector reflection = reflect(n, v);

  stroke(0, 0, 255);
  line(0, 0, reflection.x, reflection.y);
}

PVector reflect(PVector n, PVector v) {
  //  2 * (v . n) * n - v
  n.normalize();
  float vdotn = v.dot(n);
  PVector twovdotnn = PVector.mult(n, 2*vdotn);
  return PVector.sub(v, twovdotnn);
}
