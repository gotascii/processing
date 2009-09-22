import processing.opengl.*;
import javax.media.opengl.*;
import CellNoise.*;

float x1,x2,x3,x4,y1,y2,y3,y4;

PGraphicsOpenGL pgl;
GL gl;

PImage source;
PImage butterflySource;

PFont font;
int DEFAULTAMOUNT = 1;

int count = DEFAULTAMOUNT;
int count2 = DEFAULTAMOUNT;

int mode=0;

float h = 0;

boolean hide = false;

int idle = 0;

float camerax=0;
float cameray=0;
float cameraz=0;

ArrayList flares;
ArrayList butterflies;

//noise
CellNoise cn;
CellDataStruct cd;
double[] at = new double[2];

//ribbon
ArrayList ribbons;

//units
ArrayList units;

PImage output;

int time = millis();

void setup()
{
  frameRate(30);
  size(1280,800,OPENGL);
  flares = new ArrayList();
  source = loadImage("flare.png");
  butterflySource = loadImage("betterfly4.png");
  font = createFont("arial",15);
  textFont(font);
  
  cn = new CellNoise(this);
  cd = new CellDataStruct(this, 2, at, cn.EUCLIDEAN);
  
  ribbons = new ArrayList();
  units = new ArrayList();
  
  butterflies = new ArrayList();
    
  x1=0;
  y1=0;
  x2=width;
  y2=0;
  x3=width;
  y3=height;
  x4=0;
  y4=height;
  output = new PImage(width,height);
}

void draw(){
  
  
  idle++;

  //some codes copy from flight404
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
  pgl.beginGL();

  // This fixes the overlap issue
  gl.glDepthMask(false); 
  gl.glDisable(GL.GL_DEPTH_TEST);

  // Turn on the blend mode
  gl.glEnable(GL.GL_BLEND);

  // Define the blend mode
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);



  h+=0.3;
  h%=256;

  background(0);
  
  
  if(mode == 1)
  {
    camerax+= 0.01;
    camerax %= TWO_PI;
  }
  else
  {
    camerax *=0.99;
  }
  //pushMatrix();
  //translate(width/2,height/2,height*0.865);
  //tint(255,130);
  //image(output,0,0);
  //popMatrix();
  
  pushMatrix();
  translate(width/2,height/2,height*0.8);
  
  rotateX(camerax);
  rotateY(cameray);
  rotateZ(cameraz);
  translate(0,height/2*-sin(camerax),height*-0.2);

  for(int i=0;i<count2;i++)
  {
    flares.add(new Flare(mouseX,mouseY * cos(camerax),constrain(mouseY * -sin(camerax),-100,300)));
  }
  if(random(1)>0.7)
  {
    butterflies.add(new Butterfly(mouseX,mouseY * cos(camerax),constrain(mouseY * -sin(camerax),-100,300)));
  }
  if(random(1)>0.9)
  {
    units.add(new Unit());
  }
  
  count2 = DEFAULTAMOUNT;

  ArrayList templist = new ArrayList();

  for(int i=0;i<flares.size();i++)
  {
    Flare temp = (Flare)flares.get(i);
    temp.update();
    if(temp.life>0)
      templist.add(temp);
  }
  flares = templist;
  updateButterflies();
  updateUnit();
  translate(0,height/4 + (height)*-sin(camerax));
  updateRibbon();
  
  popMatrix();
  if(idle<20 && !hide)
  {
    pushMatrix();
    translate(width/2,height/2,height*0.75);
    fill(255,255-idle*10);
    text("Enter : Change modes \nHold space : Explode effect \nBackspace : Show/Hide hints and cursor\nHold Q/W/A/S and move cursor to adjust display area",20,height-40);
    popMatrix();
  }
  
  
  //println("ribbon = "+ribbons.size()+" unit = "+units.size());

  pgl.endGL(); 
  
  
  //displayWithCalibration();
  
  
  //show frame rate
  //println(1000/(millis() - time));
  //time = millis();
}

//***********************
//       problem
//***********************
void displayWithCalibration()
{
  loadPixels();
  output.pixels = (int[])pixels.clone();
  output.updatePixels();
  background(0);
  
  beginShape();
  tint(255);
  texture(output);
  vertex(x1,y1,0,0);
  vertex(x2,y2,output.width,0);
  vertex(x3,y3,output.width,output.height);
  vertex(x4,y4,0,output.height);
  
  endShape();
}

void keyPressed()
{
  idle = 0;
  if(key == ' ')
  {
    count+=20;
  }
  else if (key == ENTER)
  {
    mode++;
    mode%=2;
  }
  else if (key == BACKSPACE)
  {
    hide = !hide;
    if(hide)
    {
      noCursor();
    }
    else
    {
      cursor();
    } 
  }
  else if(key == 'q')
  {
    x1 += mouseX - pmouseX;
    y1 += mouseY - pmouseY;
    
    lines();
  }
  else if(key == 'w')
  {
    x2 += mouseX - pmouseX;
    y2 += mouseY - pmouseY;
    
    lines();
  }
  else if(key == 'a')
  {
    x4 += mouseX - pmouseX;
    y4 += mouseY - pmouseY;
    
    lines();
  }
  else if(key == 's')
  {
    x3 += mouseX - pmouseX;
    y3 += mouseY - pmouseY;
    
    lines();
  }
}

void lines()
{
  stroke(255);
  line(x1,y1,x2,y2);
  line(x1,y1,x3,y3);
  line(x1,y1,x4,y4);
  line(x2,y2,x3,y3);
  line(x2,y2,x4,y4);
  line(x3,y3,x4,y4);
  noStroke();
}


void updateRibbon()
{
  //for (int i=0; i<totalRibbons; i++){
  //  ribbon[i].exist();
  //}
  
  ArrayList templist = new ArrayList();
  for(int i=0;i<ribbons.size();i++)
  {
    Ribbon temp = (Ribbon)ribbons.get(i);
    if(temp.life>0)
    {
      temp.update();
      templist.add(temp);
    }

  }
  ribbons = templist;
}

void updateUnit()
{
  ArrayList templist = new ArrayList();
  for(int i=0;i<units.size();i++)
  {
    Unit temp = (Unit)units.get(i);
    if(temp.life>0)
    {
      temp.update();
      templist.add(temp);
    }

  }
  units = templist;
}


void updateButterflies()
{
  ArrayList templist = new ArrayList();
  for(int i=0;i<butterflies.size();i++)
  {
    Butterfly temp = (Butterfly)butterflies.get(i);
    if(temp.life>0)
    {
      temp.update();
      templist.add(temp);
    }

  }
  butterflies = templist;
}


void keyReleased()
{
  count2 = constrain(count,1,800);
  count = DEFAULTAMOUNT;
}

void mouseMoved()
{
  idle = 0;
}


void mouseReleased()
{
  for(int i=0;i<1;i++)
    units.add(new Unit());
}
