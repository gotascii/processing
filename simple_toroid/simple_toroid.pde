int points = 0;
int segments = 0;
float radius = 40;
float lradius = 50;

PVector template[], vertices[];

void setup() {
  size(400, 400, P3D);
  smooth();
  stroke(255);
  // has one extra point
  template = new PVector[points + 1];
  vertices = new PVector[points + 1];
  float angle = 0;
  // notice <= points, which means the same point at begnning and end of array
  for(int i = 0; i <= points; i++) {
    vertices[i] = new PVector();

    // determines distance from center
    float x = lradius + sin(radians(angle))*radius;
    float z = cos(radians(angle))*radius;
    template[i] = new PVector(x, 0, z);
    angle += 360.0/points;
  }
}

void draw() {
  background(255);
  fill(200);
  stroke(0);
  translate(width/2, height/2);
//  rotateX(frameCount*PI/170);
  rotateY(radians(90));
//  rotateY(frameCount*PI/170);

  float angle = 0;
  // notice <= segments, this always draw a set of points from the last segments
  // back to the first
  for(int i = 0; i <= segments; i++) {
    beginShape(QUAD_STRIP);
    // because <= points, a point is always drawn in the same place as the first
    // thereby closing the shape
    for(int j = 0; j <= points; j++) {
      // if we are not at the first segment
      if (i > 0){
        vertex(vertices[j].x, vertices[j].y, vertices[j].z);
      }

      // x, y determines angle around lathe circle
      // template[j].x determines distance from center
      vertices[j].x = sin(radians(angle))*template[j].x;
      vertices[j].y = cos(radians(angle))*template[j].x;
      vertices[j].z = template[j].z;
      (vertices[j].x, vertices[j].y, vertices[j].z);
      vertex(vertices[j].x, vertices[j].y, vertices[j].z);
    }
    endShape();
    angle += 360.0/segments;
  }
}
