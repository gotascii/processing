class Unit
{
  int life = (int)random(255,400);
  Magnet magnet;
  
  float a0,a1;
  
  float startx,starty,startz;
  
  float rotX;

  Unit()
  {
    startx = width/2 + random(-width/4 , width/4);
    starty =  random( width/2 * cos(camerax));
    startz = height/2 + random(width * -sin(camerax));
    //startz = 0;
    a0= random(width);
    a1 =random(height);
    
    rotX = random(TWO_PI);

    magnet = new Magnet(width/2,height/2,cd);
    
    for(int i=0;i<(int)random(7,10);i++)
    {
      ribbons.add(new Ribbon(0,random(0.5,0.75),(int)random(20,100), magnet,startx,starty,startz,rotX));
    }
  }

  void update()
  {
    life -=3;
    a0++;
    a0%=width;
    a1++;
    a1%=height;
    at[0] = 0.05*a0;
    at[1] = 0.05*a1;
    cd.at = at;
    cn.noise(cd);

    magnet.findOffset();
    magnet.exist();
  }

}
