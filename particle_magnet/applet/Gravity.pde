class Gravity extends Movable implements IDisplayable, IActable, IConstrainable {
  Particles particles;
  float fcharge, bounce;

  Gravity(Camera cam, float mass, PVector coords, float charge, float diameter, float fcharge, Particles particles) {
    initialize(cam, mass, coords, charge, diameter);
    this.particles = particles;
    this.fcharge = fcharge;
    this.bounce = 1;
  }

  void act() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      Movable p = (Movable)particles.get(i);
      pull(p);
    }
  }

  void pull(Movable from) {
    float distance = from.dist((Movable)this);
    float f = fcharge / distance;
    PVector direction = PVector.sub(from.coords, coords);
    direction.normalize();
    PVector force = PVector.mult(direction, f);
    from.accelerate(force);
  }

  void constrain() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      Movable p = (Movable)particles.get(i);
      constrain(p);
    }
  }

  void constrain(Movable p) {
    PVector c = PVector.sub(coords, p.pcoords);
    float r = p.radius() + radius();
    PVector dcoords = PVector.sub(p.coords, p.pcoords);
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

          ndcoords = PVector.mult(n, m);
          PVector npcoords = PVector.add(p.pcoords, ndcoords);




          PVector q = PVector.sub(p.pcoords, npcoords);

          c.normalize();
          float qmag = c.dot(q);

          PVector poo = PVector.mult(c, qmag);

          q.sub(poo);

          npcoords.sub(q);

          p.coords = npcoords;
        }
      }
    }
  }

  void display() {
    noStroke();
    pushMatrix();
    translate(coords.x, coords.y, coords.z);
    face_cam();
    fill(15, 250);
    ellipse(0, 0, diameter, diameter);
    popMatrix();
  }
}
