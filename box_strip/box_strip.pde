int segments = 10;
int points = 4;
float rY = 0;
float radius = 30;
PVector verts[] = new PVector[points + 1];

void setup() {
  size(400, 400, P3D);
}

void draw() {
  background(208);
  translate(width/2, height/2);
  rotateY(rY);
  rY += 0.01;

  int z = 0;
  for(int cseg = 0; cseg <= segments; cseg++) {
    int angle = 45;
    if(cseg == 0) {
      beginShape();
    } else {
      beginShape(QUAD_STRIP);
    }
    for(int v = 0; v <= points; v++) {
      if(cseg > 0) {
        vertex(verts[v].x, verts[v].y, verts[v].z);
      }
      float theta = radians(angle);
      float nx = cos(theta)*radius;
      float ny = sin(theta)*radius;
      verts[v] = new PVector(nx, ny, z);
      vertex(verts[v].x, verts[v].y, verts[v].z);
      angle += 360/points;
    }
    z += 10;
    endShape();
  }

}
