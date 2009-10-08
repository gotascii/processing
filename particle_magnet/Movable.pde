class Movable {
  PeasyCam cam;
  float mass, charge, diameter;
  int len = 80;
  PVector [] tail;
  PVector pcoords;
  PVector v;
  PVector coords, force;

  void initialize(PeasyCam cam, float mass, PVector coords, float charge, float diameter) {
    this.cam = cam;
    this.mass = mass;
    this.coords = coords;
    this.pcoords = coords;
    this.v = new PVector(0, 0, 0);
    this.charge = charge;
    this.diameter = diameter;
    tail = new PVector[len];
    for(int i = 0; i < len; i++) {
      PVector t = new PVector();
      t.set(coords);
      tail[i] = t;
    }
    reset();
  }

  void tail() {
    for(int i = (len - 1); i > 0; i--) {
      tail[i] = tail[i - 1];
    }
    PVector t = new PVector();
    t.set(coords);
    tail[0] = t;
  }

  float radius() {
    return diameter / 2;
  }

  void reset() {
    this.force = new PVector(0, 0, 0);
    tail();
  }

  void stop() {
    if(verlet) {
      pcoords = new PVector();
      pcoords.set(coords);
    } else {
      v = new PVector();
    }
    reset();
  }

  float dist(Movable p) {
    return coords.dist(p.coords);
  }

  void accelerate(PVector force) {
    this.force.add(force);
  }

  PVector acceleration() {
    return PVector.div(force, mass);
  }

  void move() {
    PVector a = acceleration();
    if(verlet) {
      move_verlet(a);
    } else {
      move_euler(a);
    }
    reset();
  }

  void move_verlet(PVector a) {
    PVector ncoords = PVector.mult(coords, 1.9);
    ncoords = PVector.sub(ncoords, PVector.mult(pcoords, 0.9));
    ncoords = PVector.add(ncoords, a);
    this.pcoords = coords;
    this.coords = ncoords;
  }

  void move_euler(PVector a) {
    v.add(a);
    coords.add(v);
    v.mult(0.9);
  }

  void face_cam() {
    float dx = cam.getPosition()[0] - coords.x;
    float dy = cam.getPosition()[1] - coords.y;
    float dz = cam.getPosition()[2] - coords.z;
    float angle_z = atan2(dy, dx);
    float hyp = sqrt(sq(dx) + sq(dy));
    float angle_y = atan2(hyp, dz);
    rotateZ(angle_z);
    rotateY(angle_y);
  }
}
