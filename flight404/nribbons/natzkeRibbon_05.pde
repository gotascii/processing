// This is a port of an experiment originally done by Erik Natzke.
// It was such a beautiful experiment, I just had to see how it would look once Processed.

// import pitaru.sonia_v2_9.*;

int xSize           = 500;
int ySize           = 350;
int xMid            = xSize/2;
int yMid            = ySize/2;

float xOff;
float yOff;

int totalDevices    = 4;

int totalRibbons    = 7;

Ribbon[] ribbon;
Magnet magnet;
Camera camera;

//PowerMateController pmc;
Listener listener;

float counter = 0.0;

void setup(){
  size(xSize, ySize);
  hint(NO_FLYING_POO);
  ellipseMode(CENTER);
  colorMode(HSB,360);
  //smooth();
  noiseDetail(4,0.4);
  ribbon         = new Ribbon[totalRibbons];
  magnet         = new Magnet();
  camera         = new Camera(400, 60.0);
  
  for (int i=0; i<totalRibbons; i++){
    ribbon[i] = new Ribbon(i);
  }
  
  //listener       = new Listener();
  //pmc            = new PowerMateController(listener);
  //pmc.initializePowerMates(2, 20);
  //pmc.startListening();
  //pmc.reorderPowermates();
}

void draw(){
  background(50);
  push();
  findOffset();
  setOffset();
  magnet.exist();
  camera.exist();
  for (int i=0; i<totalRibbons; i++){
    ribbon[i].exist();
  }
  
  pop();
  counter ++;
  //saveFrame("screenGrabs/frame-####.tif");
}


void findOffset(){
  xOff = (mouseX - xMid) / 5.0;
  yOff = (mouseY - yMid) / 5.0;
}

void setOffset(){
  //translate(-(magnet.x - xMid), -(magnet.y - yMid), magnet.z);
}





float getDistance(float x1, float y1, float z1, float x2, float y2, float z2){
  float xd = x1 - x2;
  float yd = y1 - y2;
  float zd = z1 - z2;
  float td = sqrt(xd * xd + yd * yd + zd * zd);
  return td;
}

float getRadians(float x1, float y1, float x2, float y2){
  float xd = x1 - x2;
  float yd = y1 - y2;

  float rads = atan2(yd,xd);
  return rads;
}

float getDegrees(float x1, float y1, float x2, float y2){
  float xd = x1 - x2;
  float yd = y1 - y2;

  float rads = atan2(yd,xd);
  float degs = degrees(rads);
  return degs;
}

public void stop(){
  //pmc.closePowerMates();
}
