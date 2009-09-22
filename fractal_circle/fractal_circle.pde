float ma = 0;
float mt = 1;

void setup() {
  size(400, 400);
  smooth();
  noStroke();
  ma = 0;
}

void draw() {
  background(100);
  circle(width/2, height/2, 300, mt, ma);
  ma += 0.1;
  mt += 0.01;
}

void circle(float x, float y, float d, float t, float a) {
  fill(noise(t)*255);
  ellipse(x, y, d, d);
  if (d > 4) {
    float dnext = d/1.5;
    a += 45;
    a = a%180;
    float rad1 = radians(a);
    float rad2 = radians(a + 180);
    float r = d/2;
    float x1 = (cos(rad1) * r) + x;
    float x2 = (cos(rad2) * r) + x;
    float y1 = (sin(rad1) * r) + y;
    float y2 = (sin(rad2) * r) + y;
    circle(x1, y1, dnext, t + 0.1, a + 5);
    circle(x2, y2, dnext, t + 0.2, a + 10);
  }
}
