float theta = 0;
boolean rY = false;
Arc a;
void setup() {
  size(700, 600, P3D);
  PVector gravity = new PVector(0, 2);
  PVector velocity = new PVector(9, -30);
  a = new Arc(22, 10, velocity, gravity);
}

void draw() {
  background(208);
  translate(width/2, height/2);
  lights();
  rotateY(theta);
  theta += 0.01;
  translate(-170, 150);
  a.draw();
  a.points = int(map(sin(theta), -1, 1, 20, 90));
  a.ratio = map(-sin(theta), -1, 1, 0.7, 20);
}

class Arc {
  PVector g, n, u, v;
  PVector [] verts;
  PVector [] coords;
  PVector vel;
  int step, steps, points;
  float ratio;

  Arc(int points, float ratio, PVector vel, PVector g) {
    this.points = points;
    this.g = g;
    this.vel = vel;
    this.ratio = ratio;
    n = new PVector(1, 0);
    u = new PVector(0, 1);
    v = n.cross(u);
    steps = step = 0;
    coords = new PVector[1000];
    coords[0] = new PVector(0, 0);
    generate();

  }

  void generate() {
    while(coords[steps].y <= 0) {
      coords[steps + 1] = PVector.add(coords[steps], vel);
      vel.add(g);
      steps++;
    }
  }

  void draw() {
    verts = new PVector[points + 1];
    draw_strips();
    if (step < steps) {
      step++;
    }
  }

  void draw_strips() {
    noStroke();
    fill(200);
    for(int i = 0; i < step; i++) {
      beginShape(QUAD_STRIP);
      float angle = 45;
      float radius = coords[i].y/ratio;
      for(int j = 0; j <= points; j++) {
        if(i > 0) {
          vertex(verts[j].x, verts[j].y, verts[j].z);
        }
        PVector tu = PVector.mult(u, cos(radians(angle)));
        PVector tv = PVector.mult(v, sin(radians(angle)));
        PVector tutv = PVector.add(tu, tv);
        PVector rtutv = PVector.mult(tutv, radius);  
        PVector p = PVector.add(coords[i], rtutv);
        verts[j] = new PVector(p.x, p.y, p.z);
        vertex(verts[j].x, verts[j].y, verts[j].z);
        angle += 360.0/points;
      }
      endShape();
    }
  }
}
