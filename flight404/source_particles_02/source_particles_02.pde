
// Source Code release 1
// Particle Emitter
//
// February 11th 2008
//
// Built with Processing v.135 which you can download at http://www.processing.org/download
//
// Robert Hodgin
// flight404.com
// barbariangroup.com

// features:
//           Toxi's magnificent PVector library
//           perlin noise flow fields
//           ribbon trails
//           OpenGL additive blending
//           OpenGL display lists
//
// 
// Uses the very useful PVector library by Karsten Schmidt (toxi)
// You can download it at http://code.google.com/p/toxiclibs/downloads/list
//
// Please post suggestions and improvements at the flight404 blog. When nicer/faster/better
// practices are suggested, I will incorporate them into the source and repost. I think that
// will be a reasonable system for now.
//
// Future additions will include:
//           Rudimentary camera movement
//           Magnetic repulsion
//           More textures means more iron
//
// UPDATES
//
// February 11th 2008
// Reorganized some of the OpenGL calls as per Simon Gelfius' suggestion.
//     http://www.kinesis.be/
//
// -------------------------------------------------------------------------------------------
//
// February 12th 2008
// Added a simple camera using Kristian Damkjer's OCD library.
//     http://www.cise.ufl.edu/~kdamkjer/processing/libraries/ocd/
// Added basic smoke effects.
// Added fake-lighting textures on the floor plane.
// Particles can now split if they hit the floor with enough force.
// Loaded images are now in the Images class. Organizational change more than a functional one.
// Saves out image sequences when the 's' key is pressed.  Hit 's' again to turn of feature.

import damkjer.ocd.*;
import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;

PGraphicsOpenGL pgl;
GL gl;
POV pov;
Images images;
Emitter emitter;
PVector gravity;

float floorLevel;
float minNoise = 0.499;
float maxNoise = 0.501;

int counter;
int saveCount;
int xSize, ySize;
int xMid, yMid;

boolean SAVING;
boolean ALLOWNEBULA;
boolean ALLOWGRAVITY = true;
boolean ALLOWPERLIN;
boolean ALLOWTRAILS;
boolean ALLOWFLOOR = true;

void setup(){
  size(750, 750, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  colorMode(RGB, 1.0);

  pgl = (PGraphicsOpenGL)g;
  gl = pgl.gl;
  gl.setSwapInterval(1);

  initGL();

  xSize = width;
  ySize = height;
  xMid = xSize/2;
  yMid = ySize/2;
  
  pov = new POV(this);
  images = new Images();
  emitter = new Emitter();
  gravity = new PVector(0, .9, 0);
  floorLevel = 0;
}

void draw(){
  background(0.0);
  pov.exist();

  gl.glClear(GL.GL_DEPTH_BUFFER_BIT) ;
  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glDepthMask(true);
  if(ALLOWFLOOR)
    drawFloor();
    
  gl.glDepthMask(false);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);

  pgl.beginGL();
  emitter.exist();
  pgl.endGL();

  if(mousePressed && mouseButton == LEFT)
    emitter.addParticles(10);

  gl.glDepthMask(true);
  counter++;

  if(SAVING) {
    saveFrame("images/image_" + saveCount + ".png");
    saveCount++;
  }
}

void drawFloor() {
  pgl.beginGL();
  gl.glBegin(GL.GL_POLYGON);
  gl.glColor3f(0, 0, 0);
  gl.glTexCoord2f(0, 0); gl.glVertex3f(-xSize * 2.0, floorLevel + .5, -xSize * 2.0);
  gl.glTexCoord2f(1, 0); gl.glVertex3f(xSize * 2.0, floorLevel + .5, -xSize * 2.0);
  gl.glTexCoord2f(1, 1); gl.glVertex3f(xSize * 2.0, floorLevel + .5,  xSize * 2.0);
  gl.glTexCoord2f(0, 1); gl.glVertex3f(-xSize * 2.0, floorLevel + .5,  xSize * 2.0);
  gl.glEnd();
  pgl.endGL();
}

void keyPressed() {
  if( key == 'g' || key == 'G' )
    ALLOWGRAVITY = !ALLOWGRAVITY;
    
  if( key == 'p' || key == 'P' )
    ALLOWPERLIN  = !ALLOWPERLIN;
  
  if( key == 't' || key == 'T' )
    ALLOWTRAILS  = !ALLOWTRAILS;
    
  if( key == 'f' || key == 'F' )
    ALLOWFLOOR   = !ALLOWFLOOR;
  
  if( key == 'n' || key == 'N' )
    ALLOWNEBULA  = !ALLOWNEBULA;
    
  if( key == 's' || key == 'S' )
    SAVING       = !SAVING;
}

void mousePressed(){
  if( mouseButton == RIGHT ){
    pov.ISDRAGGING = true;
  }
}

void mouseReleased(){
  if( mouseButton == RIGHT ){
    pov.ISDRAGGING = false;
  }
}

float getRads(float val1, float val2, float mult, float div) {
  float rads = noise(val1/div, val2/div, counter/div);
  if (rads < minNoise) minNoise = rads;
  if (rads > maxNoise) maxNoise = rads;
  rads -= minNoise;
  rads *= 1.0/(maxNoise - minNoise);
  return rads * mult;
}
