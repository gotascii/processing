class Ribbon {
  float x, xDist, xInc;
  float y, yDist, yInc;
  float z, zDist, zInc;

  float decay;
  float accel = random(4.0, 15.0);
  float friction = random(0.880, 0.965);
  float radius = random(15.0, 20.0);
  float rot = random(TWO_PI * 2.0);
  float drot = random(-0.3, 0.3);

  Magnet magnet;
  int count;
  Node [] nodes;

  Ribbon(Magnet magnet) {
    this.count = 1000;
    this.magnet = magnet;
    nodes = new Node[count];
    nodes[0] = new Node(0, 0, 0, this);
    for(int i = 1; i < count; i ++) {
      nodes[i] = new Node(nodes[i-1]);
    }
  }

  /*
    Update my position based on the magnet.
    Then update all of the nodes.
    Generate a new random decay.
    Result is the ribbon shrinks and grows.
  */
  void exist() {
    followMagnet();
    for(int i = 0; i < count; i++){
      nodes[i].exist();
    }
    decay = abs(noise(x/1000.0, y/1000.0, z/1000.0)) + .5;
    decay = constrain(decay, .5, .85);
  }

  /*
    Determines the distance to the magnet.
    Move that distance to the magnet.
  */
  void followMagnet() {
    xDist = magnet.x - x;
    yDist = magnet.y - y;
    zDist = magnet.z - z;
    xInc = (xDist/accel + xInc) * friction;
    yInc = (yDist/accel + yInc) * friction;
    zInc = (zDist/accel + zInc) * friction;
    x += xInc;
    y += yInc;
    z += zInc + (yInc + xInc)/8.0;
  }

  void display() {
    fill(0, 100);
    noStroke();
    beginShape(QUAD_STRIP);
    for(int i = 0; i < count; i++) {
      vertex(nodes[i].x, nodes[i].y, nodes[i].z);
      vertex(nodes[i].orbit.x, nodes[i].orbit.y, nodes[i].orbit.z);
    }
    endShape();

    noFill();
    beginShape();
    vertex(nodes[0].x, nodes[0].y, nodes[0].z);
    for (int j = 1; j < count; j++) {
      vertex(nodes[j].orbit.x, nodes[j].orbit.y, nodes[j].orbit.z);
    }
    endShape();
  }
}



