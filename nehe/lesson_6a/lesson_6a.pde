import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.texture.*;

float xrot;
float yrot;
float zrot;
int [] textures;

void setup() {
  size(600, 500, OPENGL);
  initGL();
}

void draw() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.gl;

  initPerspective(pgl, gl);

  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glLoadIdentity();
  gl.glTranslatef(0, 0, -5);

  gl.glRotatef(xrot, 1, 0, 0);
  gl.glRotatef(yrot, 0, 1, 0);
  gl.glRotatef(zrot, 0, 0, 1);

  gl.glBindTexture(GL.GL_TEXTURE_2D, textures[0]);

  gl.glBegin(GL.GL_QUADS);

  // front
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, 1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, 1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, 1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, 1);

  // right
  gl.glTexCoord2f(0, 1); gl.glVertex3f(1, 1, 1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(1, -1, 1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, -1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, -1);

  // back
  gl.glTexCoord2f(0, 1); gl.glVertex3f(1, 1, -1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(-1, 1, -1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(-1, -1, -1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(1, -1, -1);

  // left
  gl.glTexCoord2f(1, 1); gl.glVertex3f(-1, 1, 1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, -1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, -1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(-1, -1, 1);

  // top
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, -1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, -1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, 1, 1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, 1, 1);

  // bottom
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, -1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, -1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, -1, 1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, -1, 1);

  gl.glEnd();

  xrot += 0.3;
  yrot += 0.2;
  zrot += 0.4;
}

void initPerspective(PGraphicsOpenGL pgl, GL gl) {
  GLU glu = pgl.glu;
  gl.glMatrixMode(GL.GL_PROJECTION);
  gl.glLoadIdentity();
  glu.gluPerspective(45, (float)width/(float)height, 0.1, 100);
  gl.glMatrixMode(GL.GL_MODELVIEW);
  gl.glLoadIdentity();
}

void loadGLTextures(GL gl) {
  try {
    textures = new int[1];
    gl.glGenTextures(1, textures, 0);
    gl.glBindTexture(GL.GL_TEXTURE_2D, textures[0]);
    File f = new File(dataPath("texture.jpg"));
    TextureData td = TextureIO.newTextureData(f, true, null);
    gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, 3, td.getWidth(), td.getHeight(), 0, GL.GL_RGB, GL.GL_UNSIGNED_BYTE, td.getBuffer());
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
  } catch (IOException e) {
    println("Texture file is missing");
  }
}

boolean initGL() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.gl;
  gl.glViewport(0, 0, width, height);
  loadGLTextures(gl);
  gl.glEnable(GL.GL_TEXTURE_2D);
  gl.glShadeModel(GL.GL_SMOOTH);
  gl.glClearColor(0, 0, 0, 0);
  gl.glClearDepth(1);
  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glDepthFunc(GL.GL_LEQUAL);
  gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);
  return true;
}
