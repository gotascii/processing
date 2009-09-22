
class Vector {
  float x, y, dx, dy, r;
  Field f;

  Vector(float x, float y, float d, Field f) {
    this.x = x;
    this.y = y;
    this.r = d/2;
    this.f = f;
  }

  void spin() {
    float nv = f.value(x, y);
    float theta = radians(nv * 720);
    dx = cos(theta)*r;
    dy = sin(theta)*r;
  }

  void display() {
    stroke(100);
//    line(x - dx, y - dy, x + dx, y + dy);
    line(x - dx, y - dy, x, y);
  }
}
