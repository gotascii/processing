int count = 5000;
int diam = 2;
Rotater [] rots = new Rotater[count];

void setup() {
  size(800, 600, P3D);
  noStroke();
  float t = 0;
  for(int i = 0; i < count; i++) {
    float x = random(width);
    float y = random(height);
    float dtheta = noise(t)*0.1;
    float rdiam = random(diam);
    rots[i] = new Rotater(x, y, rdiam, dtheta);
    t += 0.01;
  }
  background(0);
}

void draw() {
  background(0);
  for(int i = 0; i < count; i++) {
    rots[i].spin();
    rots[i].display();
  }
}

class Rotater {
  float theta, dtheta, x, y, diam, ox, oy, oz, a, f, doy;

  Rotater(float x, float y, float diam, float dtheta) {
    this.x = x;
    this.y = y;
    this.diam = diam;
    this.dtheta = dtheta;
    this.theta = 0;
    this.ox = random(100);
    this.oy = random(100);
    this.oz = random(100);
    this.f = random(255);
    this.a = random(255);
    this.doy = random(100);
  }

  void spin() {
    theta += dtheta;
  }

  void display() {
    pushMatrix();
    translate(x, y, oz);
    rotateY(theta);
    fill(a, f);
    ellipse(ox, oy+(doy*noise(theta*0.6)), diam, diam);
    popMatrix();
  }
}
