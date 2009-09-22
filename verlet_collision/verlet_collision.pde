PVector coords, pcoords, force, gravity;
float mass = 1;
float radius = 30;
float diameter = radius * 2;
float gradius = 100;
float gdiameter = gradius * 2;
boolean nudge = false;

void setup() {
  size(800, 800, P3D);
  pcoords = new PVector(-50, -100);
  coords = new PVector(-45, -95);
  gravity = new PVector(150, 0);
  reset();
}

void draw() {
  background(0);
  translate(width/2, height/2);

  if(nudge) {
    PVector mv = new PVector((mouseX - width/2), (mouseY - height/2));
    PVector dv = PVector.sub(mv, coords);
    dv.mult(0.01);
    force.add(dv);
  }

  fill(200, 200);
  stroke(255);
  ellipse(gravity.x, gravity.y, gdiameter, gdiameter);

  bounce();
  move();
  constrain();

  fill(200, 200);
  ellipse(pcoords.x, pcoords.y, 20, 20);
  ellipse(coords.x, coords.y, diameter, diameter);
}

void bounce() {
  float r = radius + gradius + 1;
  PVector c = PVector.sub(gravity, coords);
  if (c.mag() <= r) {
    PVector f = PVector.sub(coords, gravity);
    f.normalize();
    PVector dcoords = PVector.sub(coords, pcoords);
    f.mult(dcoords.mag() * 2);
    force.add(f);
  }
}

void constrain() {
  PVector c = PVector.sub(gravity, pcoords);
  float r = radius + gradius;
  PVector dcoords = PVector.sub(coords, pcoords);
  float dcoords_mag = dcoords.mag();
  if((dcoords_mag >= (c.mag() - r)) && (c.dot(dcoords) > 0)) {
    PVector n = dcoords.normalize(new PVector());
    float d = n.dot(c);
    float f = pow(c.mag(), 2) - pow(d, 2);
    float rsq = pow(r, 2);
    if (f <= rsq) {
      float t = rsq - f;
      float m = d - sqrt(t);
      PVector ndcoords;
      if (m <= dcoords_mag) {
        c.normalize();
        float qmag = dcoords.dot(c);
        PVector q = PVector.mult(c, qmag);
        PVector poo = PVector.sub(dcoords, q);
        ndcoords = PVector.mult(n, m);
        ndcoords.add(poo);
        coords = PVector.add(pcoords, ndcoords);
      }
    }
  }
}

void reset() {
  force = new PVector(0, 0, 0);
}

PVector acceleration() {
  return PVector.div(force, mass);
}

void move() {
    PVector a = acceleration();
    PVector ncoords = PVector.mult(coords, 1.9);
    ncoords = PVector.sub(ncoords, PVector.mult(pcoords, 0.9));
    ncoords = PVector.add(ncoords, a);
    pcoords = coords;
    coords = ncoords;
    reset();
}

void mousePressed() {
  nudge = true;
}

void mouseReleased() {
  nudge = false;
}
