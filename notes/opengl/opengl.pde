import javax.media.opengl.*;
import processing.opengl.*;
import javax.media.opengl.glu.*;

PGraphicsOpenGL pgl;
GL gl;

void setup() {
  size(200, 200, OPENGL);
  pgl = (PGraphicsOpenGL)g;

  GL gl = pgl.gl;
  GLU glu = pgl.glu;
  gl.glViewport(0, 0, width, height);
  gl.glMatrixMode(GL.GL_PROJECTION);
  gl.glLoadIdentity();
  glu.gluPerspective(45.0, (float)width/(float)height, 1, 20.0);
  gl.glMatrixMode(GL.GL_MODELVIEW);
  gl.glLoadIdentity();

  gl.glShadeModel(GL.GL_SMOOTH);
  gl.glClearColor(0.0, 0.0, 0.0, 0.0);
  gl.glClearDepth(1.0);
  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glDepthFunc(GL.GL_LEQUAL);
  gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);
}

void draw() {
  GL gl = pgl.beginGL();
//  GL gl = pgl.gl;
  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
//  gl.glLoadIdentity();
//  gl.glTranslatef(-100, -100, 0);
//  gl.glRectf(10, 10, 100000, 100000);
  rtriangle(gl);
  pgl.endGL();
}

void rtriangle(GL gl) {
  gl.glBegin(GL.GL_TRIANGLES);
  gl.glColor3f(1, 0, 0);
  gl.glVertex3f(-width*0.25, height*0.25, 0);
  gl.glColor3f(0, 1, 0);
  gl.glVertex3f(0, -height*0.25, 0);
  gl.glColor3f(0, 0, 1);
  gl.glVertex3f(width*0.25, height*0.25, 0);
  gl.glEnd();
}
