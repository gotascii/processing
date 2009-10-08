class Magnetism implements IDisplayable, IActable {

  Particles particles;

  Magnetism(Particles particles) {
    this.particles = particles;
  }

  void act() {
    int count = particles.size();
    boolean [][] visited = new boolean[count][count];
    for(int i = 0; i < count; i++) {
      Movable pi = (Movable)particles.get(i);
      for(int j = 0; j < count; j++) {
        Movable pj = (Movable)particles.get(j);
        if ((pi != pj) && !visited[i][j]) {
          pull(pi, pj);
          visited[j][i] = true;
        }
      }
    }
  }

  void pull(Movable to, Movable from) {
    float distance = from.dist(to);
    float e = to.charge / pow(distance, 2);
    float f = from.charge * e;
    PVector direction = PVector.sub(from.coords, to.coords);
    direction.normalize();
    PVector force = PVector.mult(direction, f);
    if (force.mag() < 20) {
      from.accelerate(force);
      force.mult(-1);
      to.accelerate(force);
    }
  }

//  void constrain() {
//    int count = particles.size();
//    boolean [][] visited = new boolean[count][count];
//    for(int i = 0; i < count; i++) {
//      Movable pi = (Movable)particles.get(i);
//      for(int j = 0; j < count; j++) {
//        Movable pj = (Movable)particles.get(j);
//        if ((pi != pj) && !visited[i][j]) {
//          float r = pi.radius() + pj.radius();
//          float d = pi.dist(pj);
//          if (d < r) {
//            PVector dv = PVector.sub(pj.coords, pi.coords);
//            dv.normalize();
//            pj.coords.add(PVector.mult(dv, 5));
//            pi.coords.add(PVector.mult(dv, -5));
//            pi.reset();
//            pi.pcoords = pi.coords;
//            pj.reset();
//            pj.pcoords = pj.coords;
//          }
//          visited[j][i] = true;
//        }
//      }
//    }
//  }

  void display() {
    int count = particles.size();
    boolean [][] visited = new boolean[count][count];
    for(int i = 0; i < count; i++) {
      Movable pi = (Movable)particles.get(i);
      for(int j = 0; j < count; j++) {
        Movable pj = (Movable)particles.get(j);
        if ((pi != pj) && !visited[i][j]) {
          float distance = pi.dist(pj);
          float len = (distance/2);
          float len1 = len - 2;
          float len2 = len1 + 4;
          if (distance < 30) {
            PVector dv = PVector.sub(pj.coords, pi.coords);
            dv.normalize();

            PVector v1 = PVector.mult(dv, len1);
            v1.add(pi.coords);

            PVector v2 = PVector.mult(dv, len2);
            v2.add(pi.coords);

            PVector v3 = PVector.mult(dv, distance);
            v3.add(pi.coords);

            stroke(255, 100);
            line(pi.coords.x, pi.coords.y, pi.coords.z, v1.x, v1.y, v1.z);
            line(v2.x, v2.y, v2.z, v3.x, v3.y, v3.z);

            stroke(128, 0, 0);
            line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);

            visited[j][i] = true;
          }
        }
      }
    }
  }
}


