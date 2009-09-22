import javax.media.opengl.*;
import processing.opengl.*;
import vitamin.*;
import vitamin.math.*;
import vitamin.fx.*;

int WIDTH = 1280;
int HEIGHT = 720;
float aspectRatio = WIDTH/(float)HEIGHT;

VTimer timer;
VGL vgl;
EffectManager fxMan;
CustomScene scene;

VCamera cam;
Vector4 lightPos;

VTexture2D overlayTex;

boolean offlineRenderSequence = false;

final int MAX_DEPTH = 1;
final boolean DO_CHILD = false;

void setup() {
  size(WIDTH, HEIGHT, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  smooth();
  frameRate(60);
  aspectRatio = width / (float)height;

  vgl = new VGL(this);
  vgl.setVSync(true);

  lightPos = new Vector4(200, 2000, 0, 1);

  cam = new VCamera(this, 600, 300, 500, 0, 0, 0, 0, 1, 0);
  cam.setToCenter();

  overlayTex = new VTexture2D(vgl.gl());
  overlayTex.loadFromFile(dataPath("overlay2.png"), true);

  fxMan = new EffectManager(vgl.gl());

  scene = new CustomScene();
  fxMan.AddEffect(scene);

  // Process all effects now!
  fxMan.process();

  if(!offlineRenderSequence) timer = new VTimer();
  else timer = new VTimer(VTimer.OFFLINE);
  timer.start();
}

void draw() {
  float time = timer.getCurrTime();
  timer.update();

  vgl.begin();
  vgl.background(0.93);

  scene.Render(time);
  scene.Update(time);

  // Render overlay image
  vgl.ortho();
  vgl.gl().glDisable(GL.GL_CULL_FACE);
  vgl.setDepthWrite(false);
  vgl.setDepthMask(false);
  vgl.enableTexture(false);
  overlayTex.enable();
  vgl.fill(1, 0.25);
  vgl.setFlipV(true);
  if(overlayTex._targetID == GL.GL_TEXTURE_RECTANGLE_ARB)
    vgl.texCoordScale(width, height);
  vgl.rect(1, 1);
  vgl.texCoordScale(1, 1);
  overlayTex.disable(); // must turn off gl_texture_rectangle
  vgl.setFlipV(false);
  vgl.setDepthWrite(true);
  vgl.setDepthMask(true);
  vgl.end();

  // Offline rendering
  if(offlineRenderSequence) {
    save(sketchPath("SEQ/frame"+nf(frameCount,7)+".png"));
    if(frameCount%30 == 0) println("count: " + frameCount);
    if(time > 29.0) System.exit(0);
  }
}

void stop() {
  vgl.release();
  super.stop();
}