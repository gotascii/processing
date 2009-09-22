float noiseVal;
float noiseScale = 0.005;
float noiseCount = 0.0;
float noiseSpeed = 0.05;

float xCount, xSpeed;
float yCount, ySpeed;

float theta;
float angle;
float angleDelta;
float xv, yv;
float speed = 10;

boolean lines = false;

int noiseRes = 6;
  

Vehicle[][] vehicle;

int xSize = 400;
int ySize = 400;

int xTotal = int(xSize / noiseRes);
int yTotal = int(ySize / noiseRes);
  
  
void setup(){
  size(xSize,ySize);
  smooth();
  ellipseMode(CENTER_DIAMETER);
  colorMode(HSB, 360);
  
  background(51);
  
  vehicle = new Vehicle[yTotal][xTotal];
  for (int y=0; y<yTotal; y++){
    for (int x=0; x<xTotal; x++){
      vehicle[y][x] = new Vehicle(x, y);
    }
  }
}

void loop() {
  background(51);
  xSpeed = ((width/2) - mouseX)/10.0f;
  ySpeed = ((height/2) - mouseY)/10.0f;
  
  xCount += xSpeed;
  yCount += ySpeed;
  
  //noStroke();
  //fill(0,200);
  //rect(0,0,width,height);
  
  if (mousePressed){
    noiseDetail(6, .5f);
    noiseScale -= (noiseScale - 0.02) * .2;
  } else {
    noiseDetail(2, .5f);
    noiseScale -= (noiseScale - 0.005) * .2;
  }
  
  for(int y=0; y<=height; y++) {
    for(int x=0; x<=width; x++) {

      if (x%noiseRes == 0 && y%noiseRes == 0){
        noiseVal=noise((x - xCount)*noiseScale, (y - yCount)*noiseScale, noiseCount);
        float g = noiseVal*720.0f;
        theta = (-(g * PI))/180.0f;
        xv = cos(theta) * speed;
        yv = sin(theta) * speed;
        
        if (lines){
          stroke(g - 180, 360, 360, 100);
          line (x - (xv/2), y - (yv/2), x, y);
        }
        //point(x - xv, y - yv);
        //stroke(255,0,0, 25);
        //line (x + (xv), y + (yv), x, y);
      }
    }
  }
  
  noiseCount += noiseSpeed;
  for (int y=0; y<yTotal; y++){
    for (int x=0; x<xTotal; x++){
      vehicle[y][x].exist();
    }
  }
}


void keyPressed(){
  if (key == ' '){
    if (lines){
      lines = false;
    } else {
      lines = true;
    }
  }
}


class Vehicle {
  float x;
  float y;

  float xv, yv;
  float xf, yf;

  float theta;
  float angle;
  float angleDelta;
  float speed = random(2.0f, 10.0f);

  Vehicle (int xSent, int ySent){
    x = xSent * noiseRes;
    y = ySent * noiseRes;
  }
  
  void exist(){
    findVelocity();
    move();
    render();
  }
  
  void findVelocity(){
    noiseVal=noise((x - xCount)*noiseScale, (y - yCount)*noiseScale, noiseCount);
    angle -= (angle - noiseVal*720.0f) * .4f;
    theta = (-(angle * PI))/180.0f;
    xv = cos(theta) * speed;
    yv = sin(theta) * speed;
  }
  
  void move(){
    x -= xv;
    y -= yv;
    
    if (x < -50){
      x += width + 100;
    } else if (x > width + 50){
      x -= width + 100;
    }
    
    if (y < -50){
      y += height + 100;
    } else if (y > height + 50){
      y -= height + 100;
    }
      
  }
  
  void render(){

    stroke((angle - 180)/3, 100,360);
    line(x,y, x+(xv/2.0), y+(yv/2.0));
  }
}
