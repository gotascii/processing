// y = a(x-h)^2+c
// slope = 2a(x-h)

float theta = 0;
float c, a, h;
PVector start, end;
void setup() {
  size(400, 400, P3D);

  start = new PVector(0, 0);
  end = new PVector(50, 0);

  float sx = start.x;
  float sy = start.y;
  float ex = end.x;
  float ey = end.y;
  float sl = -1;

  c = ((4*sq(sy)) + sy*((-4*sl*sx) + (4*ex*sl) - (4*ey)) + (sq(sl)*sq(sx)) - (2*ex*sq(sl)*sx) + (sq(ex)*sq(sl))) / ((4*sy) - (4*sl*sx) + (4*ex*sl) - (4*ey));
  a = sq(sl) / ((4*sy) - (4*c));
  h = -(((2*sy) - (sl*sx) - (2*c)) / sl);
}

void draw() {
  background(208);
  translate(width/2, height/2);
  rotateY(theta);
  theta += 0.01;
  line(-10, 0, 10, 0);
  line(0, -10, 0, 10);
  for(float t = 0; t < end.x; t += 0.5) {
    float x = t;
    float y = (a*sq(x - h)) + c;
    point(x, y);
  }
}
