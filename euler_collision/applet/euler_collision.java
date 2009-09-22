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

public class euler_collision extends PApplet {

float ra = 30;
float rb = 100;
float da = ra * 2;
float db = rb * 2;
PVector a, b, v, new_v;
boolean move = false;

public void setup() {
  size(800, 800, P3D);
  a = new PVector(-50, -100);
  v = new PVector(5, 5);
  b = new PVector(150, 0);
}

public void draw() {
  background(0);
  translate(width/2, height/2);

  if(move) {
    PVector mv = new PVector((mouseX - width/2), (mouseY - height/2));
    PVector dv = PVector.sub(mv, a);
    dv.mult(0.01f);
    v.add(dv);
  }

  v.mult(0.9f);

  fill(200, 200);
  stroke(255);
  ellipse(b.x, b.y, db, db);

  PVector c = PVector.sub(b, a);
  float r = ra + rb;
  float v_mag = v.mag();

   new_v = v;

  if((v_mag >= (c.mag() - r)) && (c.dot(v) > 0)) {
    PVector n = v.normalize(new PVector());
    float d = n.dot(c);
    float f = pow(c.mag(), 2) - pow(d, 2);
    float rsq = pow(r, 2);
    if (f <= rsq) {
      float t = rsq - f;
      float m = d - sqrt(t);
      if (m <= v_mag) {
        new_v = PVector.mult(n, m);
        if (m < 0.7f) {
          c.normalize();
          float qmag = v.dot(c);
          PVector q = PVector.mult(c, qmag);
          new_v = PVector.sub(v, q);
          q.mult(-(new_v.mag()*1));
          new_v.add(q);
        }
      }
    }
  }
  v = new_v;
  a.add(v);
  ellipse(a.x, a.y, da, da);
}

public void mousePressed() {
  move = true;
}

public void mouseReleased() {
  move = false;
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "euler_collision" });
  }
}
