import processing.core.*; 
import processing.xml.*; 

import javax.media.opengl.*; 
import processing.opengl.*; 

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

public class opengl extends PApplet {




PGraphicsOpenGL pgl;
GL gl;

public void setup() {
  size(400, 400, OPENGL);
  pgl = (PGraphicsOpenGL)g;
  gl = pgl.gl;
  gl.glShadeModel(GL.GL_SMOOTH);
}

public void draw() {
  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glLoadIdentity();
  gl.glTranslatef(-1.5f, 0, -6);

  gl.glBegin(GL.GL_TRIANGLES);
  gl.glVertex3f(width, height, 0);				// Top
  gl.glVertex3f(-1.0f,-1.0f, 0.0f);				// Bottom Left
  gl.glVertex3f( 1.0f,-1.0f, 0.0f);				// Bottom Right
  gl.glEnd();

  beginShape(TRIANGLES);
  vertex(30, 75);
  vertex(40, 20);
  vertex(50, 75);
  endShape();

  ellipse(10, 10, 20, 20);
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "opengl" });
  }
}
