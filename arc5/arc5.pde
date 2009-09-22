import javax.media.opengl.*;
import processing.opengl.*;
import com.sun.opengl.util.texture.*;

int count = 1;
float theta = 0;
Arc [] arcs;
PImage ground;

void setup() {
  size(700, 600, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  smooth();
  PVector gravity = new PVector(0, 1);
  arcs = new Arc[count];
  for(int i = 0; i < count; i++) {
    float rot = random(0, 360);
    float vx = random(10, 30);
    float vy = -random(15, 30);
    float radius = random(20, 40);
    PVector vel = new PVector(vx, vy);
    arcs[i] = new Arc(80, radius, rot, vel, gravity);
  }
  ground = loadImage("ground.png");
  textureMode(NORMALIZED);
}

void draw() {
  camera(1500, -300, 500, width/2, height/2, 0, 0, 1, 0);
  background(208);
  translate(width/2, height/2);

  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, 0, 0, -1);
  specular(255, 255, 255);
  shininess(70);

  rotateY(theta);
  theta += 0.01;
  draw_floor();
  for(int i = 0; i < count; i++) {
    arcs[i].draw();
  }
}

void draw_floor() {
  pushMatrix();
  beginShape();
  tint(255, 100);
  texture(ground);
  vertex(-2000, 0, -2000, 0, 0);
  vertex(2000, 0, -2000, 1, 0);
  vertex(2000, 0, 2000, 1, 1);
  vertex(-2000, 0, 2000, 0, 1);
  endShape();
  popMatrix();
}

class Arc {
  PVector g, n, u, v;
  PVector [] verts;
  ArrayList coords;
  PVector vel;
  int step, steps, points;
  float rot, radius;

  Arc(int points, float radius, float rot, PVector vel, PVector g) {
    this.points = points;
    this.g = g;
    this.vel = vel;
    this.radius = radius;
    this.rot = rot;
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
    fill(50);
    pushMatrix();
    rotateY(radians(rot));
    for(int i = 0; i < step; i++) {
      float angle = 45;
      float ra = map(i, 0, step - 1, 0, 180);
      float mod_radius = sin(radians(ra))*radius;
      beginShape(TRIANGLE_STRIP);
      for(int j = 0; j <= points; j++) {
        if(i > 0) {
          vertex(verts[j].x, verts[j].y, verts[j].z);
        }
        PVector tu = PVector.mult(u, cos(radians(angle)));
        PVector tv = PVector.mult(v, sin(radians(angle)));
        PVector tutv = PVector.add(tu, tv);
        PVector rtutv = PVector.mult(tutv, mod_radius);  
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
