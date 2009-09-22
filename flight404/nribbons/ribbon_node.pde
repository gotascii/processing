
class Node{
  Ribbon r;
  Node n;
  
  Orbit orbit;
  int index;
  
  float decay;
  
  float x;
  float y;
  float z;
  
  boolean isFirst;
  
  Node(int indexSent, float xSent, float ySent, float zSent, Ribbon rSent){
    isFirst   = true;
    init(xSent, ySent, zSent, indexSent, rSent);
  }
  
  Node(int indexSent, Node nSent, Ribbon rSent){
    isFirst   = false;
    n         = nSent;
    init(n.x, n.y, n.z, indexSent, rSent);
  }
  
  
  
  void init(float xSent, float ySent, float zSent, int indexSent, Ribbon rSent){
    index     = indexSent;
    r         = rSent;
    x         = xSent;
    y         = ySent;
    z         = zSent;
    
    orbit = new Orbit(r, this, index);
  }
  
  void exist(){
    findPosition();
    orbit.exist();
  }
  
  void findPosition(){
    if (isFirst){
      x = r.getX();
      y = r.getY();
      z = r.getZ();
    } else {
      x -= (x - n.getX()) * r.decay;
      y -= (y - n.getY()) * r.decay;
      z -= (z - n.getZ()) * r.decay;
      
      float noiseVal = (noise(x/500.0, y/500.0, z/500.0) - .3) * 10.0;
      x += noiseVal;
    }
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
  
  void setX(float xSent){
    x = xSent;
  }
  
  void setY(float ySent){
    y = ySent;
  }
  
  void setZ(float zSent){
    z = zSent;
  }
}
