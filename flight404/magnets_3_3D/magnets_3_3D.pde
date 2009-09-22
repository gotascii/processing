//  FLIGHT404 v7
//
//  Magnetic particle experiment.
//
//  Positively charged particle behavior in a gravitational field.
//
//  Thanks to Tom Carden (http://www.tom-carden.co.uk/p5/) for assistance with 
//  the vector vs. cartesian debate. He was very helpful in getting this experiment
//  to work properly.
//
//  Project began in April 2004 as an attempt to execute an explanation of the
//  physics behind magnetic particles written by 'miked' on the processing.org forum.
//  http://processing.org/discourse/yabb/YaBB.cgi?board=Contribution_Simlation;action=display;num=1082567431;start=
//

// applet size variables
int xSize           = 400;
int ySize           = 400;
int xMid            = xSize/2;
int yMid            = ySize/2;

// gravity variables
int xGrav           = 0;
int yGrav           = 0;
int zGrav           = 0;
float gxv;
float gyv;
float gzv;
float gravity       = 0.1;

// camera variables
float xMouse, yMouse;
float rotationVar;
float elevation, azimuth, twist, distance;

int totalParticles  = 0;
int maxParticles    = 720;
Particle[] particle;

BImage myField;

boolean gravLines = false;
boolean connections = false;
boolean orbs = true;
boolean planes = false;
boolean centerLit = false;

int counter = 0;

void setup(){
  size(xSize, ySize);

  background(255);
  colorMode(RGB,255);

  elevation = radians(15.0f);
  azimuth = radians(0.0f);
  distance = 150.0f;
  
  myField = loadImage("field.gif");
  brightToAlpha(myField);
  particle  = new Particle[maxParticles];
}

void loop(){
  background(0,25,35);
  doCamera();
  
  if (mousePressed && counter == 0 && totalParticles < maxParticles - 1){
    particle[totalParticles] = new Particle(mouseX - xMid, mouseY - yMid, sin(totalParticles/4.0) * 20.0, totalParticles, 1.0);
    totalParticles ++;
    counter ++;
  }

  if (mouseX != pmouseX && mouseY != pmouseY){
    counter = 0;
  }

  for (int i=0; i<totalParticles; i++){
    particle[i].field();
  }
  for (int i=0; i<totalParticles; i++){
    particle[i].applyGravity();
  }
  for (int i=0; i<totalParticles; i++){
    particle[i].move();
  }
  for (int i=0; i<totalParticles; i++){
    particle[i].render();
  }

}


void doCamera(){
  distance      = 100.0 + (totalParticles * 0.25);
  xMouse       -= (xMouse - (xMid - mouseX)) * .2f;
  yMouse       -= (yMouse - (yMid - mouseY)) * .2f;
  //xMouse += 3.2;
  //yMouse += 7.5;
  beginCamera();
  perspective(60.0f, (float)xSize / (float)ySize, 1.0f, 500);
  translate(0, 0, -distance);
  twist         = radians(xMouse / 2.0f);
  elevation     = radians(yMouse / 2.0f);
  
  rotateY(-twist);
  rotateX(elevation);
  rotateZ(-azimuth);
  endCamera();
}

void keyReleased(){
 if (key == 'o' || key == 'O'){
   if (orbs){
     orbs = false;
   } else {
     orbs = true;
   }
 } else if (key == 'g' || key == 'G'){
   if (gravLines){
     gravLines = false;
   } else {
     gravLines = true;
   }
 } else if (key == 'c' || key == 'C'){
   if (connections){
     connections = false;
   } else {
     connections = true;
   }
 } else if (key == 'p' || key == 'P'){
   if (planes){
     planes = false;
   } else {
     planes = true;
   }
 } else if (key == 'l' || key == 'L'){
   if (centerLit){
     centerLit = false;
   } else {
     centerLit = true;
   }
 } else if (key == '1'){
   gravity = 0.1;
 } else if (key == '2'){
   gravity = 0.2;
 } else if (key == '3'){
   gravity = 0.3;
 } else if (key == '4'){
   gravity = 0.5;
 } else if (key == '5'){
   gravity = 0.8;
 }
}


void mouseReleased(){
  counter = 0;
}

class Particle {
  int index;                // particle ID
  
  float x;                  // x position of particle
  float y;                  // y position of particle
  float z;                  // z position of particle
  
  float xv;                 // x velocity of particle
  float yv;                 // y velocity of particle
  float zv;                 // z velocity of particle

  float damp = 0.97;
  
  float E;                  // energy
  float tempR;              // xy distance
  float R;                  // total distance
  float F;                  // force
  float P;                  // Pauli force
  float A;                  // accel
  float Angle;              // xy angle to field center
  float ZAngle;             // z angle to field center
  float Q;                  // charge
  float M;                  // mass

  float zDepth;
  
  float gAngle;
  float gDist;
  float gZAngle;

  int totalConnections;
  
  float strokeAlpha = 0.0;
  
  float mySize;
  
  Particle(float xSent, float ySent, float zSent, int sentIndex, float sentQ){
    x         = xSent;
    y         = ySent;
    z         = zSent;

    index     = sentIndex;
    
    M         = 1.0;
    Q         = sentQ;
  }
  
  void field(){
    totalConnections = 0;
    for (int i=0; i<totalParticles; i++){
      if (i != index){

        R             = findDistance(x, y, z, particle[i].x, particle[i].y, particle[i].z);
        E             = particle[i].Q/(R * R);
        P             = abs(Q) * abs(particle[i].Q) / pow(R,12);
        F             = (Q * E) + P;
        A             = (F/M) * 5.0;
        if (R > 0.01) { 
           xv           += A * (x - particle[i].x) / R; 
           yv           += A * (y - particle[i].y) / R; 
           zv           += A * (z - particle[i].z) / R; 
         }

        if (R < 35.0){
          totalConnections ++;
          
          if (connections){
            strokeAlpha -= (strokeAlpha - ((35.0 - R) * 7.0)) * .1;
          } else {
            strokeAlpha -= (strokeAlpha - 0) * .1;
          }

          stroke(225,245,255, strokeAlpha);
          line(particle[i].x, particle[i].y, particle[i].z, x, y, z);
        }
      }
    }
    xv *= damp;
    yv *= damp;
    zv *= damp;
    
    //Q -= (Q - ((totalConnections / 5.0) + 0.5)) * .1;
  }

  void applyGravity(){
    gDist = findDistance(xGrav,yGrav,zGrav,x,y,z); 

    if (gDist > 0.1) { 
      gxv   = gravity * (xGrav - x) / gDist; 
      gyv   = gravity * (yGrav - y) / gDist; 
      gzv   = gravity * (zGrav - z) / gDist; 
  
      xv        += gxv; 
      yv        += gyv; 
      zv        += gzv; 
    }
    
    if (gravLines && gDist < 200){
      stroke(255,0,0);
      line(x, y, z, x + gxv*14.0, y + gyv*14.0, z + gzv*14.0);
    }
  }
  
  void move(){
    x += xv;
    y += yv;
    z += zv;
  }

  void render(){
    if (!orbs){
      mySize -= (mySize - 1.0) * .1;
    } else {
      mySize -= (mySize - ((totalConnections/4.0) + (255 - zDepth)/20.0)) * .5;
    }
    
    push();
    translate(x, y, z);
    zDepth = ((screenZ(0,0,0) * 100.0) - 99.0) * 500.0;
    rotateZ(azimuth);
    rotateX(-elevation);
    rotateY(twist);
    
    if (orbs){
      if (centerLit){
        tint(255 - (gDist*gDist)/5.0, 255 - (gDist*gDist)/5.0, 255 - (gDist*gDist)/5.0);
      } else {
        tint(255 - (zDepth * 0.5), 255 - (zDepth * 0.7), 255 - (zDepth * 1.0));
      }
    } else {
      tint(255,255,255);
    }
    //println(tempColor);
    image(myField, 0 - mySize/2.0, 0 - mySize/2.0, mySize, mySize);

    pop();
  }
}


// create alpha for a bitmap by analyzing brightness (code by Ryan Alexander of Motion Theory)
void brightToAlpha(BImage b){
  b.format = RGBA;
  for(int i=0; i < b.pixels.length; i++) {
    b.pixels[i] = color(255,255,255,255 - brightness(b.pixels[i]));
  }
}


// find distance between 2 points in 2D space
float findDistance(float x1, float y1, float x2, float y2){
  float xd = x1 - x2;
  float yd = y1 - y2;
  
  float td = sqrt(xd * xd + yd * yd);
  return td;
}

// find distance between 2 points in 3D space
float findDistance(float x1, float y1, float z1, float x2, float y2, float z2){
  float xd = x1 - x2;
  float yd = y1 - y2;
  float zd = z1 - z2;
  
  float xyd = sqrt(xd * xd + yd * yd);
  float td = sqrt(zd * zd + xyd * xyd);
  return td;
}

// find angle in radians between 2 points in 2D space
float findAngle(float x1, float y1, float x2, float y2){
  float xd = x1 - x2;
  float yd = y1 - y2;

  float t = atan2(yd,xd);
  return t;
}





//

