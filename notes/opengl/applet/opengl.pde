import javax.media.opengl.*;
import processing.opengl.*;

PGraphicsOpenGL pgl;
GL gl;

void setup() {
  size(400, 400, OPENGL);
  pgl = (PGraphicsOpenGL)g;
  gl = pgl.gl;
  gl.glShadeModel(GL.GL_SMOOTH);
}

void draw() {
  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glLoadIdentity();
  gl.glTranslatef(-1.5, 0, -6);

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
