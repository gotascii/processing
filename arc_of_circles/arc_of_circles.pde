float theta = 0;
int count = 100;
PVector path[] = new PVector[count];

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

  for(int i = 0; i < count; i++) {
    float mod_i = map(i, 0, count - 1, 0, 1);
    path[i] = arcPoint(start, end, mod_i, 100);
    point(path[i].x, path[i].y, path[i].z);
  }

  float r = 10;
  for(int i = 0; i < count; i++) {
    PVector c = path[i];
    PVector prev;
    if(i == 0) {
      prev = path[i+1];
    } else {
      prev = path[i-1];
    }
    PVector n = PVector.sub(c, prev);
    n.normalize();
    PVector k = new PVector(1, 1, 1);
    PVector u = n.cross(k);
    u.normalize();
    PVector v = n.cross(u);
    for(int a = 0; a < 360; a++) {
      PVector tu = PVector.mult(u, cos(a));
      PVector tv = PVector.mult(v, sin(a));
      PVector tutv = PVector.add(tu, tv);
      PVector rtutv = PVector.mult(tutv, r);
      PVector p = PVector.add(c, rtutv);
      point(p.x, p.y, p.z);
    }
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
