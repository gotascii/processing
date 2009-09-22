class Vector {
  float x, y, dx, dy, r;

  Vector(float x, float y, float d) {
    this.x = x;
    this.y = y;
    this.r = d/2;
  }

  void spin(float t) {
    float nv = noise(x*0.01, y*0.01, t);
    float theta = radians(nv * 360);
    dx = cos(theta)*r;
    dy = sin(theta)*r;
  }

  void display() {
    line(x - dx, y - dy, x + dx, y + dy);
  }
}
