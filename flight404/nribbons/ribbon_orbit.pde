
class Orbit{
  Node n;
  Ribbon r;
  
  int index;
  
  float x;
  float y;
  float z;
  
  float counter;
  float aug;

  Orbit(Ribbon rSent, Node nSent, int indexSent){
    n       = nSent;
    r       = rSent;
    
    index   = indexSent;
    
    counter = r.initRot + index / 8.0;
    aug     = r.rotSpeed;
  }
  
  void exist(){
    findPosition();
    counter += aug;
  }
  
  void findPosition(){
    //x = n.getX() + (cos(counter) * (r.radius - index/50.0));
    //y = n.getY() + (sin(counter) * (r.radius - index/50.0));
    //z = n.getZ() + (sin(counter) * (r.radius - index/50.0));
    float noiseVal = noise(x/500.0, y/500.0, z/500.0) * 15.0 + r.initRot;
    
    x = n.getX() + cos(noiseVal) * (r.radius - index/50.0);
    y = n.getY() + sin(noiseVal) * (r.radius - index/50.0);
    z = n.getZ() + (sin(counter) * (r.radius - index/50.0));
  }

  
  
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  float getZ(){
    return z;
  }
}
