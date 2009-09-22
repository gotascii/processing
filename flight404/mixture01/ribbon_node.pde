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
  
  Node(int indexSent, float xSent, float ySent, float zSent, Ribbon rSent, float thickSent){
    isFirst   = true;
    init(xSent, ySent, zSent, indexSent, rSent, thickSent);
  }
  
  Node(int indexSent, Node nSent, Ribbon rSent,float thickSent){
    isFirst   = false;
    n         = nSent;
    init(n.x, n.y, n.z, indexSent, rSent,thickSent);
  }
  
  void init(float xSent, float ySent, float zSent, int indexSent, Ribbon rSent, float thickSent){
    index     = indexSent;
    r         = rSent;
    x         = xSent;
    y         = ySent;
    z         = zSent;
    
    orbit = new Orbit(r, this, index, thickSent);
  }
  
  void exist(){
    findPosition();
    orbit.exist();
  }
  
  void findPosition(){
    if (isFirst){
      x = r.x;
      y = r.y;
      z = r.z;
    } else {
      x -= (x - n.x) * r.decay;
      y -= (y - n.y) * r.decay;
      z -= (z - n.z) * r.decay;
      
      float noiseVal = (noise(x/500.0, y/500.0, z/500.0) - .3) * 10.0;
      x += noiseVal;
    }
  }
}

