import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;

float rtri;
float rquad;

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

  gl.glRotatef(rtri, 0, 1, 0);
  gl.glBegin(GL.GL_TRIANGLES);

  // vertices defined in counterclockwise order
  gl.glColor3f(1, 0, 0);
  gl.glVertex3f(0, 1, 0);
  gl.glColor3f(0, 1, 0);
  gl.glVertex3f(-1, -1, 1);
  gl.glColor3f(0, 0, 1);
  gl.glVertex3f(1, -1, 1);

  gl.glColor3f(1, 0, 0);
  gl.glVertex3f(0, 1, 0);
  gl.glColor3f(0, 0, 1);
  gl.glVertex3f(1, -1, 1);
  gl.glColor3f(0, 1, 0);
  gl.glVertex3f(1, -1, -1);

  gl.glColor3f(1, 0, 0);
  gl.glVertex3f(0, 1, 0);
  gl.glColor3f(0, 1, 0);
  gl.glVertex3f(1, -1, -1);
  gl.glColor3f(0, 0, 1);
  gl.glVertex3f(-1, -1, -1);

  gl.glColor3f(1, 0, 0);
  gl.glVertex3f(0, 1, 0);
  gl.glColor3f(0, 0, 1);
  gl.glVertex3f(-1, -1, -1);
  gl.glColor3f(0, 1, 0);
  gl.glVertex3f(-1, -1, 1);
  gl.glEnd();

  gl.glLoadIdentity();
  gl.glTranslatef(1.5, 0, -7);
  gl.glRotatef(rquad, 1, 1, 1);

  gl.glBegin(GL.GL_QUADS);

  gl.glColor3f(0, 1, 0);
  gl.glVertex3f(1, 1, -1);
  gl.glVertex3f(-1, 1, -1);
  gl.glVertex3f(-1, 1, 1);
  gl.glVertex3f(1, 1, 1);

  gl.glColor3f(1, 0.5, 0);
  gl.glVertex3f(1, -1, -1);
  gl.glVertex3f(-1, -1, -1);
  gl.glVertex3f(-1, -1, 1);
  gl.glVertex3f(1, -1, 1);

  gl.glColor3f(1, 0, 0);
  gl.glVertex3f(1, 1, 1);
  gl.glVertex3f(-1, 1, 1);
  gl.glVertex3f(-1, -1, 1);
  gl.glVertex3f(1, -1, 1);

  gl.glColor3f(1, 1, 0);
  gl.glVertex3f(1, 1, -1);
  gl.glVertex3f(-1, 1, -1);
  gl.glVertex3f(-1, -1, -1);
  gl.glVertex3f(1, -1, -1);

  gl.glColor3f(0, 0, 1);
  gl.glVertex3f(-1, 1, 1);
  gl.glVertex3f(-1, 1, -1);
  gl.glVertex3f(-1, -1, -1);
  gl.glVertex3f(-1, -1, 1);

  gl.glColor3f(1, 0, 1);
  gl.glVertex3f(1, 1, 1);
  gl.glVertex3f(1, -1, 1);
  gl.glVertex3f(1, -1, -1);
  gl.glVertex3f(1, 1, -1);

  gl.glEnd();

  rtri += 0.2;
  rquad -= 0.15;
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
