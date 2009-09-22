class Orbiter {
  float vel;
  float radius;
  float distance;
  float theta = 0;
  Orbiter [] orbiters;

  Orbiter(float vel, float radius, float distance) {
    this.vel = vel;
    this.radius = radius;
    this.distance = distance;
    this.orbiters = new Orbiter[0];
  }

  void add_orbiter(Orbiter orbiter) {
    orbiters = (Orbiter[])append(orbiters, orbiter);
  }

  void spin() {
    for(int i = 0; i < orbiters.length; i++) {
      orbiters[i].spin();
    }
    theta += vel;
  }

  void display() {
    pushMatrix();
    rotateY(theta);
    translate(distance, 0);
    sphere(radius);

    for(int i = 0; i < orbiters.length; i++) {
      orbiters[i].display();
    }

    popMatrix();
  }
}
