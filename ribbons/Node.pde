class Node {
  float x, y, z, i;
  Node parent;
  Ribbon ribbon;
  Orbit orbit;

  Node(float x, float y, float z, Ribbon ribbon) {
    init(x, y, z, ribbon, 0);
  }

  Node(Node parent) {
    this.parent = parent;
    init(parent.x, parent.y, parent.z, parent.ribbon, parent.i + 1);
  }
  
  void init(float x, float y, float z, Ribbon ribbon, float i) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.i = i;
    this.ribbon = ribbon;
    this.orbit = new Orbit(this);
  }

  boolean isFirst() {
    return (parent == null);
  }

  void exist(){
    findPosition();
    orbit.exist();
  }

  /*
    Move first node to where the ribbon is.
    Determine distance to parent node and move a scaled distance to the parent.
    Results in ribbon.decay creating a trail of nodes.
  */
  void findPosition(){
    if (isFirst()){
      x = ribbon.x;
      y = ribbon.y;
      z = ribbon.z;
    } else {
      x += (parent.x - x) * ribbon.decay;
      y += (parent.y - y) * ribbon.decay;
      z += (parent.z - z) * ribbon.decay;
      float noiseVal = (noise(x/500.0, y/500.0, z/500.0) - .3) * 2.0;
      x += noiseVal;
    }
  }
  
  void display() {
    pushMatrix();
    translate(x, y, z);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
}
