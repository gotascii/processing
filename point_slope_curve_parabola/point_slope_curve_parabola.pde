//y=a(x-h)^2+c
void setup() {
  size(400, 400, P3D);
  translate(width/2, height/2);
  line(-10, 0, 10, 0);
  line(0, -10, 0, 10);

  PVector p = new PVector(0, 0);
  float cur = 0.01;
  float slope = -0.9;

  float a = cur/2;
  float h = -((slope/(2*(cur/2))) - p.x);
  float c = p.y - (a*sq(p.x-h));

  for(float t = -1000; t < 1000; t += 0.01) {
    float x = t;
    float y = (a*sq(x - h)) + c;
    if (y <= 0) {
      point(x, y, z);
    }
  }
}
