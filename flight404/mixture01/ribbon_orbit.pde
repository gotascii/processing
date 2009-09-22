class Orbit{
  Node n;
  Ribbon r;

  int index;

  float x;
  float y;
  float z;

  float counter;
  float aug;
  float thick;

  Orbit(Ribbon rSent, Node nSent, int indexSent, float thickSent){
    n       = nSent;
    r       = rSent;
    thick = thickSent;

    index   = indexSent;

    counter = r.initRot + index / 8.0;
    aug     = r.rotSpeed; 
  }

  void exist(){
    findPosition();
    counter += aug;
  }

  void findPosition(){
    float noiseVal = noise(x/500.0, y/500.0, z/500.0) * 15.0 + r.initRot;

    x = n.x + cos(noiseVal) * (r.radius - index/50.0) * thick;
    y = n.y + sin(noiseVal) * (r.radius - index/50.0)* thick;
    z = n.z + (sin(counter) * (r.radius - index/50.0))* thick;
  }
}

