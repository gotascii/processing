class Orbit {
  float x, y, z;
  Ribbon r;
  Node n;
  float theta;

  Orbit(Node n) {
    this.n = n;
    this.r = n.ribbon;
    this.theta = r.rot + n.i / 8.0; // ?
  }

  void exist() {
    float jitter = noise(x/500.0, y/500.0, z/500.0) * 15.0 + r.rot;
    x = n.x + cos(jitter) * (r.radius - n.i/50.0);
    y = n.y + sin(jitter) * (r.radius - n.i/50.0);
    z = n.z + (sin(theta) * (r.radius - n.i/50.0));
    theta += r.drot;
  }
}
