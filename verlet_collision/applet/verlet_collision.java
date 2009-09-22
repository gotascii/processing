import processing.core.*; 
import processing.xml.*; 

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

public class verlet_collision extends PApplet {

PVector coords, pcoords, force, gravity;
float mass = 1;
float radius = 30;
float diameter = radius * 2;
float gradius = 100;
float gdiameter = gradius * 2;
boolean nudge = false;

public void setup() {
  size(800, 800, P3D);
  pcoords = new PVector(-50, -100);
  coords = new PVector(-45, -95);
  gravity = new PVector(150, 0);
  reset();
}

public void draw() {
  background(0);
  translate(width/2, height/2);

  if(nudge) {
    PVector mv = new PVector((mouseX - width/2), (mouseY - height/2));
    PVector dv = PVector.sub(mv, coords);
    dv.mult(0.01f);
    force.add(dv);
  }

  fill(200, 200);
  stroke(255);
  ellipse(gravity.x, gravity.y, gdiameter, gdiameter);

  bounce();
  move();
  constrain();

  fill(200, 200);
  ellipse(pcoords.x, pcoords.y, 20, 20);
  ellipse(coords.x, coords.y, diameter, diameter);
}

public void bounce() {
  float r = radius + gradius;
  PVector c = PVector.sub(gravity, coords);
  if (r <= c.mag()) {
    println("bounce");
  }
}

public void constrain() {
  PVector c = PVector.sub(gravity, pcoords);
  float r = radius + gradius;
  PVector dcoords = PVector.sub(coords, pcoords);
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
        c.normalize();
        float qmag = dcoords.dot(c);
        PVector q = PVector.mult(c, qmag);
        PVector poo = PVector.sub(dcoords, q);
        ndcoords = PVector.mult(n, m);
        ndcoords.add(poo);
        coords = PVector.add(pcoords, ndcoords);
      }
    }
  }
}

public void reset() {
  force = new PVector(0, 0, 0);
}

public PVector acceleration() {
  return PVector.div(force, mass);
}

public void move() {
    PVector a = acceleration();
    PVector ncoords = PVector.mult(coords, 1.9f);
    ncoords = PVector.sub(ncoords, PVector.mult(pcoords, 0.9f));
    ncoords = PVector.add(ncoords, a);
    pcoords = coords;
    coords = ncoords;
    reset();
}

public void mousePressed() {
  nudge = true;
}

public void mouseReleased() {
  nudge = false;
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "verlet_collision" });
  }
}
