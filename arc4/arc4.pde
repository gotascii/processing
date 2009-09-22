int count = 1;
float theta = 0;
Arc [] arcs;

void setup() {
  size(700, 600, P3D);
  PVector gravity = new PVector(0, 1);
  arcs = new Arc[count];
  for(int i = 0; i < count; i++) {
    float rot = random(0, 360);
    float vx = random(10, 30);
    float vy = -random(10, 20);
    PVector vel = new PVector(vx, vy);
    arcs[i] = new Arc(20, 0.5, rot, vel, gravity);
  }
}

void draw() {
  camera(1500, -300, 500, width/2, height/2, 0, 0, 1, 0);
  background(208);
  translate(width/2, height/2);

  lights();
  rotateY(theta);
  theta += 0.01;
  draw_floor();
  for(int i = 0; i < count; i++) {
    arcs[i].draw();
  }
}

void draw_floor() {
  pushMatrix();
  rotateX(radians(90));
  rectMode(CENTER);
  fill(100);
  rect(0, 0, 800, 800);
  popMatrix();
}

class Arc {
  PVector g, n, u, v;
  PVector [] verts;
  ArrayList coords;
  PVector vel;
  int step, steps, points;
  float ratio, rot;
  boolean drawing;

  Arc(int points, float ratio, float rot, PVector vel, PVector g) {
    this.points = points;
    this.g = g;
    this.vel = vel;
    this.ratio = ratio;
    this.rot = rot;
    drawing = false;
    n = new PVector(1, 0);
    u = new PVector(0, 1);
    v = new PVector(0, 0, 1);
    steps = step = 0;
    coords = new ArrayList();
    coords.add(new PVector(0, 0));
    generate();
  }

  PVector coord(int i) {
    return (PVector)coords.get(i);
  }

  void generate() {
    while (coord(steps).y <= 0) {
      drawing = true;
      steps++;
      PVector ncoord = PVector.add(coord(steps - 1), vel);
      coords.add(ncoord);
      vel.add(g);
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
    pushMatrix();
    rotateY(radians(rot));
    for(int i = 0; i <= step; i++) {
      float angle = 45;
      float radius = coord(i).y/ratio;
      beginShape(QUAD_STRIP);
      for(int j = 0; j <= points; j++) {
        if(i > 0) {
          vertex(verts[j].x, verts[j].y, verts[j].z);
        }
        PVector tu = PVector.mult(u, cos(radians(angle)));
        PVector tv = PVector.mult(v, sin(radians(angle)));
        PVector tutv = PVector.add(tu, tv);
        PVector rtutv = PVector.mult(tutv, radius);  
        PVector p = PVector.add(coord(i), rtutv);
        verts[j] = new PVector(p.x, p.y, p.z);
        vertex(verts[j].x, verts[j].y, verts[j].z);
        angle += 360.0/points;
      }
      endShape();
    }
    popMatrix();
  }
}
