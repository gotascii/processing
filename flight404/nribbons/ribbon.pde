class Ribbon {
  int index;
  int totalNodes = 1000;
  Node[] node;

  float x, xDist, xInc;
  float y, yDist, yInc;
  float z, zDist, zInc;
  
  float rads, rads2;
  float accel     = random(4.0, 15.0);      // acceleration variable
  float friction  = random(0.880, 0.965);      // friction variable
  
  float radius    = random(15.0, 20.0);
  float initRot   = random(TWO_PI * 2.0);
  float rotSpeed  = random(-0.3, 0.3);

  float decay;
  
  float counter   = random(TWO_PI);
  
  color fillColor;
  color strokeColor;
  
  float hh;
  float ss;
  float bb;
  float aa;
  
  float hhOffset = random(100) + 200;
  float ssOffset = random(50) + 100;

  Ribbon(int sentIndex){
    index     = sentIndex;
    node      = new Node[totalNodes];
    node[0]   = new Node(0, 0, 0, 0, this);
    
    for (int i=1; i<totalNodes; i++){
      node[i] = new Node(i, node[i-1], this);
    }
  }
  
  void exist(){
    for (int i=0; i<totalNodes; i++){
      node[i].exist();
    }
    findPosition();
    render();
    
    float decayVar = abs(noise(x/1000.0, y/1000.0, z/1000.0)) + .5;
    decay = constrain(decayVar, .5, .85);
  }
  
  void findPosition(){
    xDist   = magnet.getX() - x;
    yDist   = magnet.getY() - y;
    zDist   = magnet.getZ() - z;
    xInc    = (xDist/accel + xInc) * friction;
    yInc    = (yDist/accel + yInc) * friction;
    zInc    = (zDist/accel + zInc) * friction;
    x      += xInc;
    y      += yInc;
    z      += zInc + (yInc + xInc)/8.0;
  }
  
  void render(){

    noStroke();
    beginShape(QUAD_STRIP);
    fill(0,0,360);
    vertex(node[0].getX(), node[0].getY(), node[0].getZ());
    vertex(node[0].orbit.getX(), node[0].orbit.getY(), node[0].orbit.getZ());
    for (int i=1; i<totalNodes; i++){
    
      rads    = abs(getRadians(node[i].getX(), node[i].getY(), node[i-1].getX(), node[i-1].getY()) - HALF_PI)/2.0;
      
      if (rads > 0.5 && rads < 0.8){
        rads += abs(rads - 0.65) * 2.0;
      } else {
        rads -= 0.5;
      }
      
      rads2   = abs(getRadians(node[i].getX(), node[i].getY(), node[i].orbit.getX(), node[i].orbit.getY())) / 3.0;
      
      hh = hhOffset + (rads - rads2) * 10.0;
      ss = ssOffset + (rads - rads2) * 15.0 + 150; 
      bb = (rads + rads2) * 50.0 + node[i].getZ()/5.0;
      
      if (i < 7){
        bb += (7-i) * 25.0;
        ss += (7-i) * 25.0;
      }
        
      aa = 360 - i*0.1;
      
      if (rads > 0.6 && rads < 0.7){
        bb += abs(rads - 0.65) * 200.0;
        ss += 50.0;
      } else {
        ss -= 50;
      }
      
      if (i%2 == 0){
        fill(hh - 20, ss, bb, aa);
        vertex(node[i].getX(), node[i].getY(), node[i].getZ());
        fill(hh + 60, ss, bb, aa);
        vertex(node[i].orbit.getX(), node[i].orbit.getY(), node[i].orbit.getZ());
      } else {
        fill(hh - 60, ss, bb, aa);
        vertex(node[i].orbit.getX(), node[i].orbit.getY(), node[i].orbit.getZ());
        fill(hh + 60, ss, bb, aa);
        vertex(node[i].getX(), node[i].getY(), node[i].getZ());
      }
    }
    endShape();
    
    beginShape(LINE_STRIP);
    vertex(node[0].getX(), node[0].getY(), node[0].getZ());
    for (int i=1; i<totalNodes; i++){
      rads    = abs(getRadians(node[i].getX(), node[i].getY(), node[i-1].getX(), node[i-1].getY()) - HALF_PI)/2.0;
      if (rads > 0.5 && rads < 0.8){
        rads += abs(rads - 0.65);
      } else {
        rads -= .5;
      }
      
      rads2   = abs(getRadians(node[i].getX(), node[i].getY(), node[i].orbit.getX(), node[i].orbit.getY())) / 3.0;
      
      hh = hhOffset + (rads - rads2) * 5.0;
      ss = ssOffset + (rads - rads2) * 15.0 + 150;
      bb = (rads + rads2) * 100.0 + node[i].getZ()/2.0;
      
      if (rads > 0.6 && rads < 0.7){
        bb += abs(rads - 0.65) * 100.0;
      } else {
        
      }
      
      aa = 360 - i*0.025;
      
      stroke(hh, ss, bb, aa);
      vertex(node[i].orbit.getX(), node[i].orbit.getY(), node[i].orbit.getZ());
    }
    endShape();

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


