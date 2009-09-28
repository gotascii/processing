import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.texture.*;

float xrot;
float yrot;
float zrot;
Texture tex;

void setup() {
  size(600, 500, OPENGL);
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  loadGLTextures();
  initGL(pgl);
}

void draw() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.gl;

  initPerspective(pgl, gl);

  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glLoadIdentity();
  gl.glTranslatef(0, 0, -5);

//  gl.glRotatef(xrot, 1, 0, 0);
  gl.glRotatef(yrot, 0, 1, 0);
//  gl.glRotatef(zrot, 0, 0, 1);

  tex.bind();

  gl.glBegin(GL.GL_QUADS);

  // front
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, 1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, 1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, 1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, 1);

  // back
  gl.glTexCoord2f(0, 1); gl.glVertex3f(1, 1, -1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(-1, 1, -1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(-1, -1, -1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(1, -1, -1);

  // top
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, -1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, -1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, 1, 1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, 1, 1);

//  gl.glVertex3f(1, -1, -1);
//  gl.glVertex3f(-1, -1, -1);
//  gl.glVertex3f(-1, -1, 1);
//  gl.glVertex3f(1, -1, 1);
//
//  gl.glVertex3f(1, 1, 1);
//  gl.glVertex3f(-1, 1, 1);
//  gl.glVertex3f(-1, -1, 1);
//  gl.glVertex3f(1, -1, 1);
//
//  gl.glVertex3f(-1, 1, 1);
//  gl.glVertex3f(-1, 1, -1);
//  gl.glVertex3f(-1, -1, -1);
//  gl.glVertex3f(-1, -1, 1);
//
//  gl.glVertex3f(1, 1, 1);
//  gl.glVertex3f(1, -1, 1);
//  gl.glVertex3f(1, -1, -1);
//  gl.glVertex3f(1, 1, -1);

  gl.glEnd();

  xrot += 0.3;
  yrot += 0.2;
  zrot += 0.4;
}

void loadGLTextures() {
  try {
    tex = TextureIO.newTexture(new File(dataPath("texture.jpg")), true);
  } catch (IOException e) {
    println("Texture file is missing");
  }
  tex.setTexParameteri(GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
  tex.setTexParameteri(GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
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
  tex.enable();
  gl.glShadeModel(GL.GL_SMOOTH);
  gl.glClearColor(0, 0, 0, 0);
  gl.glClearDepth(1);
  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glDepthFunc(GL.GL_LEQUAL);
  gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);
  return true;
}
