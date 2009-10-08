import oscP5.*;
import netP5.*;
import damkjer.ocd.*;

int count = 100;
Camera cam;
OscP5 osc;
Particles electrons;
Particles gravitons;
Magnetism magnetism, gmagnetism;
PVector coords;
boolean [] coded;
boolean [] keyed;

void setup() {
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

void draw() {
  cam.feed();
  background(0);

  if (coded[RIGHT]) { cam.circle(0.09); }
  if (coded[LEFT]) { cam.circle(-0.09); }

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

void keyPressed() {
  if (key == CODED) {
    coded[keyCode] = true;
  } else {
    keyed[key] = true;
  }

  if (key == ' ') {
    Gravity g = (Gravity)gravitons.get(0);
    g.diameter *= 1.3;
  }
}

void oscEvent(OscMessage msg) {
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

void keyReleased() {
  if (key == CODED) {
    coded[keyCode] = false;
  } else {
    keyed[key] = false;
  }

  if (key == ' ') {
    Gravity g = (Gravity)gravitons.get(0);
    g.diameter /= 1.3;
  }
}

PVector rand_vector() {
  float randx = random(-400, 400);
  float randy = random(-400, 400);
  float randz = random(-300, 300);
  return new PVector(randx, randy, randz);
}
