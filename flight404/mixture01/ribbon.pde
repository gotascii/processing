class Ribbon {
  float life;
  float decayspeed;
  int index;
  int totalNodes = 30;
  Node[] node;
  color col;
  float x, xDist, xInc;
  float y, yDist, yInc;
  float z, zDist, zInc;
  
  float rads, rads2;
  float accel     = random(100.0, 400.0);      // acceleration variable
  float friction  = random(0.880, 0.965);    // friction variable
  
  float radius    = random(15.0, 20.0);
  float initRot   = random(TWO_PI * 2.0);
  float rotSpeed  = random(-0.1, 0.1);

  float decay;
  
  float startx,starty,startz;
  
  float counter   = random(TWO_PI);
  
  color fillColor;
  color strokeColor;
  float rotX;
  Magnet magnet;

  Ribbon(int sentIndex,float thickSent, int len, Magnet _magnet, float _startx,float _starty, float _startz,float _rotX){    
    life = 255;
    startx = _startx;
    starty = _starty;
    startz = -_startz;
    rotX = _rotX;
    decayspeed = random(2.5,3.5);
    col= color(255);
    //col = color(random(55,115),random(120,180),random(220,255));
    //col = color(random(255),random(255),random(255));
    totalNodes = len;
    index     = sentIndex;
    node      = new Node[totalNodes];
    node[0]   = new Node((int)_startx, (int)_starty, (int)_startz, 0, this, thickSent);
    for (int i=1; i<totalNodes; i++){
      node[i] = new Node(i, node[i-1], this, thickSent);
    }
    magnet = _magnet;
  }
  
  void update(){
    life-=decayspeed;
    for (int i=0; i<totalNodes; i++){
      node[i].exist();
    }
    //if(node[0]!=null && random(1)>0.92)
    //{
      //heads.add(new Head(x,y));
      //heads.add(new Head(x,y));
      //int totalPoints = 300;
      //if(point.size()<totalPoints)
      //{
      //  flock.addBoid(new Boid(new Vector3D(x,y), 10.0f, 0.05f));
      //}
      //heads.add(new Head(x,y));
    //}
    findPosition();
    render();
    
    float decayVar = abs(noise(x/1000.0, y/1000.0, z/1000.0)) + .5;
    decay = constrain(decayVar, .5, .85);
  }
  
  void findPosition(){
    xDist   = (magnet.x - x);
    yDist   = (magnet.y - y);
    zDist   = (magnet.z - z);
    xInc    = (xDist/accel + xInc) * friction;
    yInc    = (yDist/accel + yInc) * friction;
    zInc    = (zDist/accel + zInc) * friction;
    x      += xInc;
    y      += yInc;
    z      += zInc + (yInc + xInc)/8.0;
  }
  
  void render(){
    pushMatrix();
    //translate(width/2,height/2);
    translate(startx,starty,startz);
    rotateZ(rotX);
    
    noStroke();
    beginShape(QUAD_STRIP);
    fill(col,life / 4);
    //fill(255);
    vertex(node[0].orbit.x, node[0].orbit.y, node[0].orbit.z);
    vertex(node[0].x, node[0].y, node[0].z);
    for (int i=1; i<totalNodes; i++){ 
      if (i%2 == 0){
        vertex(node[i].x,node[i].y,node[i].z);
        //vertex(node[i].x*((float)(totalNodes-i)/totalNodes)  +   node[i].orbit.x*((float)i/totalNodes), node[i].y*((float)(totalNodes-i)/totalNodes)  +   node[i].orbit.y*((float)i/totalNodes), node[i].z*((float)(totalNodes-i)/totalNodes)  +   node[i].orbit.z*((float)i/totalNodes));    
      } else {
        //vertex(node[i].orbit.x,node[i].orbit.y,node[i].z);
        vertex(node[i].x*((float)i/totalNodes)  +   node[i].orbit.x*((float)(totalNodes-i)/totalNodes), node[i].y*((float)i/totalNodes)  +   node[i].orbit.y*((float)(totalNodes-i)/totalNodes), node[i].z*((float)i/totalNodes)  +   node[i].orbit.z*((float)(totalNodes-i)/totalNodes));    
      }
    }
    endShape();
    popMatrix();
  }
}



