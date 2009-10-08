class Movable implements IMovable {
  Camera cam;
  float mass, charge, diameter;
  PVector pcoords;
  PVector coords, force;

  void initialize(Camera cam, float mass, PVector coords, float charge, float diameter) {
    this.cam = cam;
    this.mass = mass;
    this.coords = coords;
    this.pcoords = coords;
    this.charge = charge;
    this.diameter = diameter;
    reset();
  }

  float radius() {
    return diameter / 2;
  }

  void reset() {
    this.force = new PVector(0, 0, 0);
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
    PVector ncoords = PVector.mult(coords, 1.9);
    ncoords = PVector.sub(ncoords, PVector.mult(pcoords, 0.9));
    ncoords = PVector.add(ncoords, a);
    this.pcoords = coords;
    this.coords = ncoords;
    reset();
  }

  void face_cam() {
    float dx = cam.position()[0] - coords.x;
    float dy = cam.position()[1] - coords.y;
    float dz = cam.position()[2] - coords.z;
    float angle_z = atan2(dy, dx);
    float hyp = sqrt(sq(dx) + sq(dy));
    float angle_y = atan2(hyp, dz);
    rotateZ(angle_z);
    rotateY(angle_y);
  }
}
