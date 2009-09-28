import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;

void setup() {
  size(600, 500, OPENGL);
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  initGL(pgl);
}

void draw() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.gl;

  initPerspective(pgl, gl);

  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glLoadIdentity();
  gl.glTranslatef(-1.5, 0, -6);
  gl.glBegin(GL.GL_TRIANGLES);
  gl.glVertex3f(0, 1, 0);
  gl.glVertex3f(-1, -1, 0);
  gl.glVertex3f(1, -1, 0);
  gl.glEnd();

  gl.glTranslatef(3, 0, 0);
  gl.glBegin(GL.GL_QUADS);
  gl.glVertex3f(-1, 1, 0);
  gl.glVertex3f(1, 1, 0);
  gl.glVertex3f(1, -1, 0);
  gl.glVertex3f(-1, -1, 0);
  gl.glEnd();
}

void initPerspective(PGraphicsOpenGL pgl, GL gl) {
  GLU glu = pgl.glu;
  gl.glMatrixMode(GL.GL_PROJECTION);
  gl.glLoadIdentity();
  glu.gluPerspective(45, (float)width/(float)height, 0.1, 100);
  gl.glMatrixMode(GL.GL_MODELVIEW);
  gl.glLoadIdentity();
}

boolean initGL(PGraphicsOpenGL pgl) {
  GL gl = pgl.gl;
  gl.glViewport(0, 0, width, height);
  gl.glShadeModel(GL.GL_SMOOTH);
  gl.glClearColor(0, 0, 0, 0);
  gl.glClearDepth(1);
  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glDepthFunc(GL.GL_LEQUAL);
  gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);
  return true;
}
