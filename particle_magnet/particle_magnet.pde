import oscP5.*;
import netP5.*;
import peasy.*;
import javax.media.opengl.*;
import processing.opengl.*;
import com.sun.opengl.util.texture.*;

int count = 100;
PeasyCam cam;
OscP5 osc;
OscHandler handler;
Particles electrons;
Particles gravitons;
Particles gluiton;
Magnetism magnetism, gmagnetism;

Texture tparticle;
PGraphicsOpenGL pgl;
GL gl;

boolean [] coded = new boolean [200];
boolean [] keyed = new boolean [200];
boolean verlet = false;
float cam_rotateX = 0;
float cam_rotateY = 0;

void setup() {
  size(1000, 800, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  background(0);

  cam = new PeasyCam(this, 300);
  osc = new OscP5(this, 7005);
  handler = new OscHandler();

  try {
    tparticle = TextureIO.newTexture(new File(dataPath("particle.png")), true);
  } catch (IOException e) {
    println("Texture file is missing");
  }

  pgl = (PGraphicsOpenGL)g;
  gl = pgl.beginGL();
//  gl.glDepthMask(false);
  gl.glDepthMask(true);
  pgl.endGL();

  electrons = new Particles();
  gravitons = new Particles();
  gluiton = new Particles();
  magnetism = new Magnetism(electrons);
  gmagnetism = new Magnetism(gravitons);

  for(int i = 0; i < count; i++) {
    Particle p = new Particle(cam, 1, rand_vector(), -10, 10, color(200));
    electrons.add(p);
  }

  gravitons.add(new Gravity(cam, 1, new PVector(0, 50, 0), -7, 200, -80, electrons));
//  gravitons.add(new Gravity(cam, 1, new PVector(0, -50, 0), -7, 100, -80, electrons));
//  gravitons.add(new Gravity(cam, 1, new PVector(50, 0, 0), -7, 100, -80, electrons));
//  gravitons.add(new Gravity(cam, 1, new PVector(-50, 0, 0), -7, 100, -80, electrons));

//  gluiton.add(new Gravity(cam, 1, new PVector(-100, -100, 0), 1, 50, -20, gravitons));
//  gluiton.add(new Gravity(cam, 1, new PVector(100, -100, 0), 1, 30, -100, gravitons));
//  gluiton.add(new Gravity(cam, 1, new PVector(0, 100, 0), 1, 50, -200, gravitons));

  keyed['z'] = true;
}

void draw() {
  if (!keyed['b']) {
    background(0);
  }

  cam.rotateX(cam_rotateX);
  cam.rotateY(cam_rotateY);

  if (keyed['z']) {
    gluiton.act();
    gmagnetism.act();
    gmagnetism.constrain();
    gravitons.move();
  }

  if(mousePressed) {
    for(int i = 0; i < count; i++) {
      Movable p = (Movable)electrons.get(i);
      p.accelerate(new PVector(0, 0.2, 0));
    }

    PVector coords = new PVector(0, -80, 0);
    Particle p = new Particle(cam, 1, coords, -7, 10, color(200));

    float randx = random(-10, 10);
    float randy = random(-10, 10);
    float randz = random(1, 5);
    PVector f = new PVector(randx, randy, randz);
    p.accelerate(f);
    electrons.add(p);
    electrons.remove(0);
  }

  magnetism.act();
  gravitons.act();
  electrons.move();

//  if(verlet) {
//    gravitons.constrain();
//    gluiton.constrain();
//  }

  electrons.display();
//  magnetism.display();
  gravitons.display();
//  gluiton.display();
}

void keyPressed() {
  if (key == CODED) {
    coded[keyCode] = true;
  } else {
    keyed[key] = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    coded[keyCode] = false;
  } else {
    keyed[key] = false;
  }
}

void oscEvent(OscMessage msg) {
//  print(" addrpattern: " + msg.addrPattern());
//  println(" typetag: " + msg.typetag());
  handler.handle(msg);
}

void mousePressed() {
}

PVector rand_vector() {
  float randx = random(-400, 400);
  float randy = random(-400, 400);
  float randz = random(-300, 300);
  return new PVector(randx, randy, randz);
}
