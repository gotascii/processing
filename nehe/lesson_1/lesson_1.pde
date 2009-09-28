import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;

PGraphicsOpenGL pgl;
GL gl;
GLU glu;

void setup() {
  size(400, 400, OPENGL);
  pgl = (PGraphicsOpenGL)g;
  gl = pgl.gl;
  glu = pgl.glu;
  resizeGLScene();
  initGL();
}

void draw() {
  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glLoadIdentity();
}

void resizeGLScene() {
  gl.glViewport(0, 0, width, height);
  gl.glMatrixMode(GL.GL_PROJECTION);
  gl.glLoadIdentity();
  glu.gluPerspective(45.0, (float)width/(float)height, 0.1, 100.0);
  gl.glMatrixMode(GL.GL_MODELVIEW);
  gl.glLoadIdentity();
}

boolean initGL() {
  gl.glShadeModel(GL.GL_SMOOTH);
  gl.glClearColor(0.0, 0.0, 0.0, 0.0);
  gl.glClearDepth(1.0);
  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glDepthFunc(GL.GL_LEQUAL);
  gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);
  return true;
}
