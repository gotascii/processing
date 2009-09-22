float FLARESPEED = 3;
float FLARESPEEDVARY = 0.5;
float FLARESIZE = 45;
float FLARE2FACTOR = 0.0015;

class Flare
{
  float x,y,z;
  float xspeed,yspeed,zspeed;
  PImage img;
  float size;
  int life;
  float hue;
  
  
  Flare(float _x, float _y,float _z)
  {
    life = (int)random(200,300);
    hue = h;
    x = _x;
    y = _y;
    z = _z;
    
    size = random(FLARESIZE);
    
    xspeed = random(-FLARESPEED,FLARESPEED);
    yspeed = random(-FLARESPEED,FLARESPEED);
    zspeed = random(-FLARESPEED,FLARESPEED);
    
    img = source;
  }
  
  void render()
  {
    pushMatrix();
    translate(x,y,z);
    //imageMode(CENTER);
    //translate(-img.width/2,-img.height/2);
    translate(-size/2,-size/2);
    rotateX(-camerax);
    colorMode(HSB);
    tint(255,z*-sin(camerax)+200);
    //tint(hue,255,255,z*-sin(camerax)+200);
    image(img,0,0,size,size);
    popMatrix();
  }
  
  void update()
  {
    switch (mode)
    {
      case 0:
      x+=xspeed;
      y+=yspeed;
      z+=zspeed;
    
      xspeed+=random(-FLARESPEEDVARY,FLARESPEEDVARY);
      yspeed+=random(-FLARESPEEDVARY,FLARESPEEDVARY);
      zspeed+=random(-FLARESPEEDVARY,FLARESPEEDVARY);
      break;
      
      case 1:
      x+=xspeed;
      y+=yspeed;
      z+=zspeed;
      
      float degree = atan2((width/2 - x),(height/2 -y));
      float len = dist(x,y,width/2,height/2);

      xspeed += len*sin(degree+HALF_PI) * FLARE2FACTOR + random(-FLARESPEEDVARY,FLARESPEEDVARY);
      yspeed += len*cos(degree+HALF_PI) * FLARE2FACTOR+ random(-FLARESPEEDVARY,FLARESPEEDVARY);
      zspeed += -z * FLARE2FACTOR + random(-FLARESPEEDVARY,FLARESPEEDVARY);
      
      xspeed *= 0.995;
      yspeed *= 0.995;
      zspeed *= 0.995;
      
      break;
      
    }  
    life--;
    render();
  }
}
