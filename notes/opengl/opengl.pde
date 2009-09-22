import javax.media.opengl.*;
import processing.opengl.*;
import com.sun.opengl.util.texture.*;

PGraphicsOpenGL pgl;
GL gl;
Texture tex;
float theta = 0;

void setup() {
  size(200, 200, OPENGL);
  colorMode(RGB, 1.0);

  try {
    tex = TextureIO.newTexture(new File(dataPath("particle.png")), true);
  } catch (IOException e) {
    println("Texture file is missing");
  }

  pgl = (PGraphicsOpenGL)g;
  gl = pgl.beginGL();
  gl.glDepthMask(false);
  gl.glEnable(GL.GL_BLEND);
  gl.glEnable(GL.GL_TEXTURE_2D);
  pgl.endGL();
}

void draw() {
  background(0);

//  rtriangle();
  rsquare(width/2, height/2, 10);
  rsquare(width/2 + 10, height/2 + 10, -10);
  theta += 0.05;
}

void rsquare(float x, float y, float z) {
  pushMatrix();
  translate(x, y, z);
  rotateY(theta);
  pgl.beginGL();
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);

  tex.enable();
  tex.bind();

  gl.glColor4f(1, 1, 1, 1);
  gl.glScalef(300, 300, 300);

  gl.glBegin(GL.GL_POLYGON);
  gl.glTexCoord2f(0, 0);
  gl.glVertex2f(-.5, -.5);
  gl.glTexCoord2f(1, 0);
  gl.glVertex2f( .5, -.5);
  gl.glTexCoord2f(1, 1);
  gl.glVertex2f( .5,  .5);
  gl.glTexCoord2f(0, 1);
  gl.glVertex2f(-.5,  .5);
  gl.glEnd();

  tex.disable();
  pgl.endGL();
  popMatrix();
}

void rtriangle() {
  gl.glBegin(GL.GL_TRIANGLES);
  gl.glColor3f(1, 0, 0);
  gl.glVertex3f(-width*0.25, height*0.25, 0);
  gl.glColor3f(0, 1, 0);
  gl.glVertex3f(0, -height*0.25, 0);
  gl.glColor3f(0, 0, 1);
  gl.glVertex3f(width*0.25, height*0.25, 0);
  gl.glEnd();
}
