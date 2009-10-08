import processing.core.*; 
import processing.xml.*; 

import oscP5.*; 
import netP5.*; 
import damkjer.ocd.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class particle_magnet extends PApplet {





int count = 100;
Camera cam;
OscP5 osc;
Particles electrons;
Particles gravitons;
Magnetism magnetism, gmagnetism;
PVector coords;
boolean [] coded;
boolean [] keyed;

public void setup() {
  size(1000, 800, P3D);
  background(0);

  coded = new boolean [200];
  keyed = new boolean [200];

  cam = new Camera(this, 0, 0, 600, 0, 0, 0);
  osc = new OscP5(this, 7005);

  electrons = new Particles();
  gravitons = new Particles();
  magnetism = new Magnetism(electrons);
  gmagnetism = new Magnetism(gravitons);

  for(int i = 0; i < count; i++) {
    Particle p = new Particle(cam, 1, rand_vector(), -7, 6, color(200));
    electrons.add(p);
  }

  gravitons.add(new Gravity(cam, 1, new PVector(0, 50, 0), -300, 300, -200, electrons));
  gravitons.add(new Gravity(cam, 1, new PVector(-50, 0, 0), 100, 300, -200, electrons));
  gravitons.add(new Gravity(cam, 1, new PVector(50, 0, 0), 100, 300, -200, electrons));
}

public void draw() {
  cam.feed();
  background(0);

  if (coded[RIGHT]) { cam.circle(0.09f); }
  if (coded[LEFT]) { cam.circle(-0.09f); }

  if (keyed['z']) {
    gmagnetism.act();
    gravitons.move();
  }

//  if (keyed['x']) {
//    gmagnetism.constrain();
//  }


  gravitons.act();
  magnetism.act();
//  gravitons.bounce();
  electrons.move();
  gravitons.constrain();
  electrons.display();
  magnetism.display();
  gravitons.display();
}

public void keyPressed() {
  if (key == CODED) {
    coded[keyCode] = true;
  } else {
    keyed[key] = true;
  }

  if (key == ' ') {
    Gravity g = (Gravity)gravitons.get(0);
    g.diameter *= 1.3f;
  }
}

public void oscEvent(OscMessage msg) {
//  print(" addrpattern: " + msg.addrPattern());
//  println(" typetag: " + msg.typetag());
  int i = msg.get(0).intValue();
  Gravity g = (Gravity)gravitons.get(i);
  float val = msg.get(1).floatValue();

  if (msg.checkAddrPattern("/bounce")) {
    g.bounce = val;
  } else if (msg.checkAddrPattern("/diameter")) {
    g.diameter = val;
  }
}

public void keyReleased() {
  if (key == CODED) {
    coded[keyCode] = false;
  } else {
    keyed[key] = false;
  }

  if (key == ' ') {
    Gravity g = (Gravity)gravitons.get(0);
    g.diameter /= 1.3f;
  }
}

public PVector rand_vector() {
  float randx = random(-400, 400);
  float randy = random(-400, 400);
  float randz = random(-300, 300);
  return new PVector(randx, randy, randz);
}
class Gravity extends Movable implements IDisplayable, IActable, IConstrainable {
  Particles particles;
  float fcharge, bounce;

  Gravity(Camera cam, float mass, PVector coords, float charge, float diameter, float fcharge, Particles particles) {
    initialize(cam, mass, coords, charge, diameter);
    this.particles = particles;
    this.fcharge = fcharge;
    this.bounce = 1;
  }

  public void act() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      Movable p = (Movable)particles.get(i);
      pull(p);
    }
  }

  public void pull(Movable from) {
    float distance = from.dist((Movable)this);
    float f = fcharge / distance;
    PVector direction = PVector.sub(from.coords, coords);
    direction.normalize();
    PVector force = PVector.mult(direction, f);
    from.accelerate(force);
  }

  public void constrain() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      Movable p = (Movable)particles.get(i);
      constrain(p);
    }
  }

  public void constrain(Movable p) {
    PVector c = PVector.sub(coords, p.pcoords);
    float r = p.radius() + radius();
    PVector dcoords = PVector.sub(p.coords, p.pcoords);
    float dcoords_mag = dcoords.mag();
    if((dcoords_mag >= (c.mag() - r)) && (c.dot(dcoords) > 0)) {
      PVector n = dcoords.normalize(new PVector());
      float d = n.dot(c);
      float f = pow(c.mag(), 2) - pow(d, 2);
      float rsq = pow(r, 2);
      if (f <= rsq) {
        float t = rsq - f;
        float m = d - sqrt(t);
        PVector ndcoords;
        if (m <= dcoords_mag) {

          ndcoords = PVector.mult(n, m);
          PVector npcoords = PVector.add(p.pcoords, ndcoords);




          PVector q = PVector.sub(p.pcoords, npcoords);

          c.normalize();
          float qmag = c.dot(q);

          PVector poo = PVector.mult(c, qmag);

          q.sub(poo);

          npcoords.sub(q);

          p.coords = npcoords;
        }
      }
    }
  }

  public void display() {
    noStroke();
    pushMatrix();
    translate(coords.x, coords.y, coords.z);
    face_cam();
    fill(15, 250);
    ellipse(0, 0, diameter, diameter);
    popMatrix();
  }
}
interface IActable {
  public void act();
}
interface IBounceable {
  public void bounce();
}
interface IConstrainable {
  public void constrain();
}
interface IDisplayable {
  public void display();
}
interface IMovable {
  public void move();
}
class Magnetism implements IDisplayable, IActable {

  Particles particles;

  Magnetism(Particles particles) {
    this.particles = particles;
  }

  public void act() {
    int count = particles.size();
    boolean [][] visited = new boolean[count][count];
    for(int i = 0; i < count; i++) {
      Movable pi = (Movable)particles.get(i);
      for(int j = 0; j < count; j++) {
        Movable pj = (Movable)particles.get(j);
        if ((pi != pj) && !visited[i][j]) {
          pull(pi, pj);
          visited[j][i] = true;
        }
      }
    }
  }

  public void pull(Movable to, Movable from) {
    float distance = from.dist(to);
    float e = to.charge / pow(distance, 2);
    float f = from.charge * e;
    PVector direction = PVector.sub(from.coords, to.coords);
    direction.normalize();
    PVector force = PVector.mult(direction, f);
    if (force.mag() < 20) {
      from.accelerate(force);
      force.mult(-1);
      to.accelerate(force);
    }
  }

//  void constrain() {
//    int count = particles.size();
//    boolean [][] visited = new boolean[count][count];
//    for(int i = 0; i < count; i++) {
//      Movable pi = (Movable)particles.get(i);
//      for(int j = 0; j < count; j++) {
//        Movable pj = (Movable)particles.get(j);
//        if ((pi != pj) && !visited[i][j]) {
//          float r = pi.radius() + pj.radius();
//          float d = pi.dist(pj);
//          if (d < r) {
//            PVector dv = PVector.sub(pj.coords, pi.coords);
//            dv.normalize();
//            pj.coords.add(PVector.mult(dv, 5));
//            pi.coords.add(PVector.mult(dv, -5));
//            pi.reset();
//            pi.pcoords = pi.coords;
//            pj.reset();
//            pj.pcoords = pj.coords;
//          }
//          visited[j][i] = true;
//        }
//      }
//    }
//  }

  public void display() {
    int count = particles.size();
    boolean [][] visited = new boolean[count][count];
    for(int i = 0; i < count; i++) {
      Movable pi = (Movable)particles.get(i);
      for(int j = 0; j < count; j++) {
        Movable pj = (Movable)particles.get(j);
        if ((pi != pj) && !visited[i][j]) {
          float distance = pi.dist(pj);
          float len = (distance/2);
          float len1 = len - 2;
          float len2 = len1 + 4;
          if (distance < 30) {
            PVector dv = PVector.sub(pj.coords, pi.coords);
            dv.normalize();

            PVector v1 = PVector.mult(dv, len1);
            v1.add(pi.coords);

            PVector v2 = PVector.mult(dv, len2);
            v2.add(pi.coords);

            PVector v3 = PVector.mult(dv, distance);
            v3.add(pi.coords);

            stroke(255, 100);
            line(pi.coords.x, pi.coords.y, pi.coords.z, v1.x, v1.y, v1.z);
            line(v2.x, v2.y, v2.z, v3.x, v3.y, v3.z);

            stroke(128, 0, 0);
            line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);

            visited[j][i] = true;
          }
        }
      }
    }
  }
}


class Movable implements IMovable {
  Camera cam;
  float mass, charge, diameter;
  PVector pcoords;
  PVector coords, force;

  public void initialize(Camera cam, float mass, PVector coords, float charge, float diameter) {
    this.cam = cam;
    this.mass = mass;
    this.coords = coords;
    this.pcoords = coords;
    this.charge = charge;
    this.diameter = diameter;
    reset();
  }

  public float radius() {
    return diameter / 2;
  }

  public void reset() {
    this.force = new PVector(0, 0, 0);
  }

  public float dist(Movable p) {
    return coords.dist(p.coords);
  }

  public void accelerate(PVector force) {
    this.force.add(force);
  }

  public PVector acceleration() {
    return PVector.div(force, mass);
  }

  public void move() {
    PVector a = acceleration();
    PVector ncoords = PVector.mult(coords, 1.9f);
    ncoords = PVector.sub(ncoords, PVector.mult(pcoords, 0.9f));
    ncoords = PVector.add(ncoords, a);
    this.pcoords = coords;
    this.coords = ncoords;
    reset();
  }

  public void face_cam() {
    float dx = cam.position()[0] - coords.x;
    float dy = cam.position()[1] - coords.y;
    float dz = cam.position()[2] - coords.z;
    float angle_z = atan2(dy, dx);
    float hyp = sqrt(sq(dx) + sq(dy));
    float angle_y = atan2(hyp, dz);
    rotateZ(angle_z);
    rotateY(angle_y);
  }
}
class Particle extends Movable implements IDisplayable {
  int fill_color;

  Particle(Camera cam, float mass, PVector coords, float charge, float diameter, int fill_color) {
    initialize(cam, mass, coords, charge, diameter);
    this.fill_color = fill_color;
  }

  public void display() {
    noStroke();
    fill(fill_color);
    pushMatrix();
    translate(coords.x, coords.y, coords.z);
    face_cam();
    ellipse(0, 0, diameter, diameter);
    popMatrix();
  }
}

// class Particle {
//   PVector coords;
//   PVector velocity;
// 
//   float mass = 1;
//   float diameter = 5;
//   float charge = 7;
// 
//   color fillc;
// 
//   Particle() {
//     init(new PVector(0, 0, 0));
//   }
// 
//   Particle(PVector coords) {
//     init(coords);
//   }
// 
//   Particle(PVector coords, float mass, float charge) {
//     this.mass = mass;
//     this.charge = charge;
//     init(coords);
//   }
// 
//   void init(PVector coords) {
//     this.coords = coords;
//     this.velocity = new PVector(0, 0);
//     this.fillc = color(200);
//   }
// 
//   float radius() {
//     return diameter/2;
//   }
// 
//   float dist(Particle p) {
//     return coords.dist(p.coords);
//   }
// 
//   void stop() {
//     velocity.limit(0);
//   }
// 
//   void accelerate(PVector force) {
//     force.div(mass);
//     velocity.add(force);
//   }
// 
//   void move() {
//     coords.add(velocity);
//   }
// 
//   void display() {
// //    stroke(200, 100);
//     noStroke();
//     fill(fillc, 128);
//     pushMatrix();
//     translate(coords.x, coords.y, coords.z);
//     rotateY(cam.attitude()[0]);
//     rotateX(-cam.attitude()[1]);
// //    sphere(radius());
// //    ellipse(coords.x, coords.y, diameter, diameter);
//     ellipse(0, 0, diameter/2, diameter/2);
// //    line(coords.x, coords.y, coords.z, coords.x + velocity.x*3, coords.y + velocity.y*3, coords.z + velocity.z*3);
// //    line(0, 0, 0, velocity.x*2, velocity.y*2, velocity.z*2);
//     popMatrix();
//   }
// }
class Particles {
  ArrayList particles;

  Particles() {
    this.particles = new ArrayList();
  }

  public int size() {
    return particles.size();
  }

  public void add(Object obj) {
    particles.add(obj);
  }

  public Object get(int i) {
    return particles.get(i);
  }

  public void act() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IActable actor = (IActable)particles.get(i);
      actor.act();
    }
  }

  public void display() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IDisplayable displayer = (IDisplayable)particles.get(i);
      displayer.display();
    }
  }

  public void move() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IMovable mover = (IMovable)particles.get(i);
      mover.move();
    }
  }

  public void constrain() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IConstrainable constrainer = (IConstrainable)particles.get(i);
      constrainer.constrain();
    }
  }

  public void bounce() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IBounceable bouncer = (IBounceable)particles.get(i);
      bouncer.bounce();
    }
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "particle_magnet" });
  }
}
