int count = 50;
Node [] nodes = new Node[count];
float rot = random(TWO_PI * 2.0);
float drot = random(-0.3, 0.3);

void setup() {
  size(400, 400, P3D);
  for(int i = 0; i < count; i++) {
    nodes[i] = new Node(i*5 + 80, i+100, i, i);
  }
}

void draw() {
  background(100);
  fill(255, 50);
  beginShape(QUAD_STRIP);

  for (int i = 0; i < count; i++) {
    nodes[i].orbit.spin();
    vertex(nodes[i].x, nodes[i].y, nodes[i].z);
    vertex(nodes[i].orbit.x, nodes[i].orbit.y, nodes[i].orbit.z);
  }
  endShape();
}

class Node {
  float x, y, z, i;
  Orbit orbit;

  Node(float x, float y, float z, float i) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.i = i;
    this.orbit = new Orbit(30, this);
  }
}

class Orbit {
  float x, y, z, r;
  Node n;
  float theta;

  Orbit(float r, Node n) {
    this.r = r;
    this.n = n;
    this.theta = rot + n.i / 8.0; // ?
  }

  void spin() {
    float jitter = noise(x/500.0, y/500.0, z/500.0) * 15.0 + rot;
    x = n.x + cos(jitter) * (r - n.i/50.0);
    y = n.y + sin(jitter) * (r - n.i/50.0);
    z = n.z + (sin(theta) * (r - n.i/50.0));
    theta += drot;
  }
}
