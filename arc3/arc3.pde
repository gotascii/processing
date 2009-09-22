float theta = 0;
int segments = 150;
int points = 4;
float radius = 10;
PVector verts[] = new PVector[points + 1];
PVector path[] = new PVector[segments + 1];

void setup() {
  size(400, 400, P3D);
}

void draw() {
  background(208);
  translate(width/2, height/2);
  rotateX(theta);
  theta += 0.01;

  PVector start = new PVector(0, 0, 0);
  PVector end = new PVector(100, 0, 0);

  for(int i = 0; i <= segments; i++) {
    float mod_i = map(i, 0, segments - 1, 0, 1);
    path[i] = arcPoint(start, end, mod_i, 100);
  }

  for(int i = 0; i < segments; i++) {
    PVector c = path[i];
    PVector prev;
    if(i == 0) {
      prev = start;
    } else {
      prev = path[i-1];
    }
    PVector n = PVector.sub(c, prev);
    n.normalize();
    PVector k = new PVector(-n.y, n.x, 0);
    PVector u = n.cross(k);
    u.normalize();
    PVector v = n.cross(u);
    if(i == 0) {
      beginShape();
    } else {
      beginShape(QUAD_STRIP);
    }
    float a = 45;
    for(int j = 0; j <= points; j++) {
      if(i > 0) {
        vertex(verts[j].x, verts[j].y, verts[j].z);
      }
      PVector tu = PVector.mult(u, cos(radians(a)));
      PVector tv = PVector.mult(v, sin(radians(a)));
      PVector tutv = PVector.add(tu, tv);
      PVector rtutv = PVector.mult(tutv, c.y/5);
      PVector p = PVector.add(c, rtutv);

      verts[j] = new PVector(p.x, p.y, p.z);
      vertex(verts[j].x, verts[j].y, verts[j].z);
      a += 360/points;
    }
    endShape();
  }
}

PVector arcPoint(PVector start, PVector end, float i, float h) {
  float a = map(i, 0, 1, 0, 180);
  float mod = sin(radians(a));
  float y = -mod * h;
  float x = map(i, 0, 1, start.x, end.x);
  float z = map(i, 0, 1, start.z, end.z);
  return new PVector(x, y, z);
}
