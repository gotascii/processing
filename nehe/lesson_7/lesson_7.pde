import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.texture.*;

boolean light;

float xrot;
float yrot;
float xspeed;
float yspeed;
float z = -5;

float [] lightAmbient = {0.2, 0.2, 0.2, 1};
float [] lightDiffuse = {1, 1, 1, 1};
float [] lightPosition = {0, 0, 2, 1};

int filt;
int [] textures = new int[3];

void setup() {
  size(600, 500, OPENGL);
  initGL();
}

void draw() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.gl;

  initPerspective(pgl, gl);

  if(light) {
    enableLights(gl);
  }

  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glLoadIdentity();

  gl.glTranslatef(0, 0, z);

  gl.glRotatef(xrot, 1, 0, 0);
  gl.glRotatef(yrot, 0, 1, 0);

  gl.glBindTexture(GL.GL_TEXTURE_2D, textures[filt]);

  gl.glBegin(GL.GL_QUADS);

  // front
  gl.glNormal3f(0, 0, 1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, 1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, 1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, 1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, 1);

  // back
  gl.glNormal3f(0, 0, -1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(-1, -1, -1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(-1, 1, -1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(1, 1, -1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(1, -1, -1);

  // top
  gl.glNormal3f(0, 1, 0);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, -1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, 1, 1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, 1, 1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, -1);

  // bottom
  gl.glNormal3f(0, -1, 0);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, -1, 1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, -1, 1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, -1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, -1);

  // right
  gl.glNormal3f(1, 0, 0);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, -1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, -1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(1, 1, 1);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(1, -1, 1);

  // left
  gl.glNormal3f(-1, 0, 0);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, -1);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(-1, -1, 1);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(-1, 1, 1);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, -1);

  gl.glEnd();

  xrot += xspeed;
  yrot += yspeed;
}

void enableLights(GL gl) {
  gl.glLightfv(GL.GL_LIGHT1, GL.GL_AMBIENT, lightAmbient, 0);
  gl.glLightfv(GL.GL_LIGHT1, GL.GL_DIFFUSE, lightDiffuse, 0);
  gl.glLightfv(GL.GL_LIGHT1, GL.GL_POSITION, lightPosition, 0);
  gl.glEnable(GL.GL_LIGHT1);
  gl.glEnable(GL.GL_LIGHTING);
}

void initPerspective(PGraphicsOpenGL pgl, GL gl) {
  GLU glu = pgl.glu;
  gl.glMatrixMode(GL.GL_PROJECTION);
  gl.glLoadIdentity();
  glu.gluPerspective(45, (float)width/(float)height, 0.1, 100);
  gl.glMatrixMode(GL.GL_MODELVIEW);
  gl.glLoadIdentity();
}

void loadGLTextures(PGraphicsOpenGL pgl, GL gl) {
  try {
    GLU glu = pgl.glu;
    File f = new File(dataPath("texture.jpg"));
    TextureData td = TextureIO.newTextureData(f, true, null);
    gl.glGenTextures(3, textures, 0);

    gl.glBindTexture(GL.GL_TEXTURE_2D, textures[0]);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_NEAREST);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_NEAREST);
    gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, 3, td.getWidth(), td.getHeight(), 0, GL.GL_RGB, GL.GL_UNSIGNED_BYTE, td.getBuffer());

    gl.glBindTexture(GL.GL_TEXTURE_2D, textures[1]);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
    gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, 3, td.getWidth(), td.getHeight(), 0, GL.GL_RGB, GL.GL_UNSIGNED_BYTE, td.getBuffer());

    gl.glBindTexture(GL.GL_TEXTURE_2D, textures[2]);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR_MIPMAP_NEAREST);
    glu.gluBuild2DMipmaps(GL.GL_TEXTURE_2D, 3, td.getWidth(), td.getHeight(), GL.GL_RGB, GL.GL_UNSIGNED_BYTE, td.getBuffer());
  } catch (IOException e) {
    println("Texture file is missing");
  }
}

boolean initGL() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.gl;
  gl.glViewport(0, 0, width, height);
  loadGLTextures(pgl, gl);
  gl.glEnable(GL.GL_TEXTURE_2D);
  gl.glShadeModel(GL.GL_SMOOTH);
  gl.glClearColor(0, 0, 0, 0);
  gl.glClearDepth(1);
  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glDepthFunc(GL.GL_LEQUAL);
  gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);
  return true;
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == KeyEvent.VK_PAGE_UP) {
      z -= 0.02;
    }
    if(keyCode == KeyEvent.VK_PAGE_DOWN) {
      z += 0.02;
    }
    if(keyCode == UP) {
      xspeed -= 0.01;
    }
    if(keyCode == DOWN) {
      xspeed += 0.01;
    }
    if(keyCode == RIGHT) {
      yspeed += 0.01;
    }
    if(keyCode == LEFT) {
      yspeed -= 0.01;
    }
  }
}

void keyReleased() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.gl;
  if (key == 'l') {
    light = !light;
  }

  if(key == 'f') {
    filt++;
    filt = filt%3;
  }
}
