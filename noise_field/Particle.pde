class Particle {
  float x, y, vel;
  Field f;

  Particle(float x, float y, float vel, Field f) {
    this.x = x;
    this.y = y;
    this.vel = vel;
    this.f = f;
  }

  void move() {
    float nv = f.value(x, y);
    float deg = nv * 720;
    float theta = radians(deg);
    float dx = cos(theta)*vel;
    float dy = sin(theta)*vel;

    x += dx;
    y += dy;

    if (x < -50){
      x += width + 100;
    } else if (x > width + 50){
      x -= width + 100;
    }

    if (y < -50){
      y += height + 100;
    } else if (y > height + 50){
      y -= height + 100;
    }
  }

  void display() {
    stroke(200);
    point(x, y);
//    ellipse(x, y, 1, 1);
  }
}
