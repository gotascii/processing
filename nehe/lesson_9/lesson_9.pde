import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.texture.*;

boolean twinkle;
int num = 50;
Star [] stars = new Star[num];
float zoom = -15;
float tilt = 90;
float spin;
float dd = 0.02;
int [] textures = new int[1];

void setup() {
  size(600, 500, OPENGL);
  initGL();
  for (int i = 0;i < num; i++) {
    stars[i] = new Star();
    stars[i].angle = 0;
    float uhh = float(i)/num;
    stars[i].d = uhh*5.0;
    stars[i].r = random(1);
    stars[i].g = random(1);
    stars[i].b = random(1);
  }
}

void draw() {
  GL gl = gl();
  initPerspective();

  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glBindTexture(GL.GL_TEXTURE_2D, textures[0]);
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);

  for (int i = 0; i < num; i++) {
    gl.glLoadIdentity();
    gl.glTranslatef(0, 0, zoom);
    gl.glRotatef(tilt, 1, 0, 0);

    gl.glRotatef(stars[i].angle , 0, 1, 0);
    gl.glTranslatef(stars[i].d, 0, 0);

    gl.glRotatef(-stars[i].angle, 0, 1, 0);
    gl.glRotatef(-tilt, 1, 0, 0);

    if (twinkle) {
      gl.glColor4f(stars[(num - i) - 1].r, stars[(num - i) - 1].g, stars[(num - i) - 1].b, 1);
      gl.glBegin(GL.GL_QUADS);
      gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, 0);
      gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, 0);
      gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, 0);
      gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, 0);
      gl.glEnd();
    }

    gl.glRotatef(spin, 0, 0, 1);
    gl.glColor4f(stars[i].r, stars[i].g, stars[i].b, 1);
    gl.glBegin(GL.GL_QUADS);
    gl.glTexCoord2f(0, 0); gl.glVertex3f(-1, -1, 0);
    gl.glTexCoord2f(1, 0); gl.glVertex3f(1, -1, 0);
    gl.glTexCoord2f(1, 1); gl.glVertex3f(1, 1, 0);
    gl.glTexCoord2f(0, 1); gl.glVertex3f(-1, 1, 0);
    gl.glEnd();

    spin += 0.01;
    stars[i].angle += float(i)/num;
    stars[i].d -= dd;

    if (stars[i].d < 0) {
      stars[i].d += 5;
      stars[i].r = random(1);
      stars[i].g = random(1);
      stars[i].b = random(1);
    }
  }
}

void initPerspective() {
  GL gl = gl();
  GLU glu = glu();
  gl.glMatrixMode(GL.GL_PROJECTION);
  gl.glLoadIdentity();
  glu.gluPerspective(45, (float)width/(float)height, 0.1, 100);
  gl.glMatrixMode(GL.GL_MODELVIEW);
  gl.glLoadIdentity();
}

void loadGLTextures() {
  try {
    GL gl = gl();
    File f = new File(dataPath("star.png"));
    Texture t = TextureIO.newTexture(f, true);
    TextureData td = TextureIO.newTextureData(f, true, null);
    gl.glGenTextures(1, textures, 0);
    gl.glBindTexture(GL.GL_TEXTURE_2D, textures[0]);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
    gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, 3, td.getWidth(), td.getHeight(), 0, GL.GL_RGB, GL.GL_UNSIGNED_BYTE, td.getBuffer());
  }
  catch (IOException e) {
    println("Texture file is missing");
  }
}

boolean initGL() {
  GL gl = gl();
  gl.glViewport(0, 0, width, height);
  loadGLTextures();
  gl.glEnable(GL.GL_TEXTURE_2D);
  gl.glShadeModel(GL.GL_SMOOTH);
  gl.glClearColor(0, 0, 0, 0);
  gl.glClearDepth(1);
  gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST);
  return true;
}

PGraphicsOpenGL pgl() {
  return (PGraphicsOpenGL)g;
}

GL gl() {
  return pgl().gl;
}

GLU glu() {
  return pgl().glu;
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == KeyEvent.VK_PAGE_UP) {
      zoom -= 0.2;
    }
    if(keyCode == KeyEvent.VK_PAGE_DOWN) {
      zoom += 0.2;
    }
    if(keyCode == UP) {
      tilt -= 0.5;
    }
    if(keyCode == DOWN) {
      tilt += 0.5;
    }
    if(keyCode == LEFT) {
      dd -= 0.02;
    }
    if(keyCode == RIGHT) {
      dd += 0.02;
    }
  }
}

void keyReleased() {
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.gl;
  if (key == 't') {
    twinkle = !twinkle;
  }
}

class Star {
  Star(){}
  float r, g, b, d, angle;
}

