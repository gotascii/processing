float theta = 0;

void setup() {
  size(400, 400, P3D);
}

void draw() {
  background(208);
  translate(width/2, height/2);
//  rotateY(theta);
  theta += 0.01;

  // radius
  float r = 50;
  // center
  PVector c = new PVector(10, 10, 10);
  point(c.x, c.y, c.z);
  // unit normal for plane circle is in
  PVector n = new PVector(10, 2, 5);
  n.normalize();
  line(c.x, c.y, c.z, c.x + n.x*r, c.y + n.y*r, c.z + n.z*r);
  // throw away vector used to find orthogonal vector to n
  PVector k = new PVector(1, 1, 1);
  // vector from c towards point on circle
  PVector u = n.cross(k);
  u.normalize();
  line(c.x, c.y, c.z, c.x + u.x*r, c.y + u.y*r, c.z + u.z*r);

  PVector v = n.cross(u);

  for(int a = 0; a < 180; a++) {
    PVector tu = PVector.mult(u, cos(radians(a)));
    PVector tv = PVector.mult(v, sin(radians(a)));
    PVector tutv = PVector.add(tu, tv);
    PVector rtutv = PVector.mult(tutv, r);
    PVector p = PVector.add(c, rtutv);
    point(p.x, p.y, p.z);
  }
}
