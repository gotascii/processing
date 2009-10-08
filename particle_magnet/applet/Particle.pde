class Particle extends Movable implements IDisplayable {
  color fill_color;

  Particle(Camera cam, float mass, PVector coords, float charge, float diameter, color fill_color) {
    initialize(cam, mass, coords, charge, diameter);
    this.fill_color = fill_color;
  }

  void display() {
    noStroke();
    fill(fill_color);
    pushMatrix();
    translate(coords.x, coords.y, coords.z);
    face_cam();
    ellipse(0, 0, diameter, diameter);
    popMatrix();
  }
}

// class Particle {
//   PVector coords;
//   PVector velocity;
// 
//   float mass = 1;
//   float diameter = 5;
//   float charge = 7;
// 
//   color fillc;
// 
//   Particle() {
//     init(new PVector(0, 0, 0));
//   }
// 
//   Particle(PVector coords) {
//     init(coords);
//   }
// 
//   Particle(PVector coords, float mass, float charge) {
//     this.mass = mass;
//     this.charge = charge;
//     init(coords);
//   }
// 
//   void init(PVector coords) {
//     this.coords = coords;
//     this.velocity = new PVector(0, 0);
//     this.fillc = color(200);
//   }
// 
//   float radius() {
//     return diameter/2;
//   }
// 
//   float dist(Particle p) {
//     return coords.dist(p.coords);
//   }
// 
//   void stop() {
//     velocity.limit(0);
//   }
// 
//   void accelerate(PVector force) {
//     force.div(mass);
//     velocity.add(force);
//   }
// 
//   void move() {
//     coords.add(velocity);
//   }
// 
//   void display() {
// //    stroke(200, 100);
//     noStroke();
//     fill(fillc, 128);
//     pushMatrix();
//     translate(coords.x, coords.y, coords.z);
//     rotateY(cam.attitude()[0]);
//     rotateX(-cam.attitude()[1]);
// //    sphere(radius());
// //    ellipse(coords.x, coords.y, diameter, diameter);
//     ellipse(0, 0, diameter/2, diameter/2);
// //    line(coords.x, coords.y, coords.z, coords.x + velocity.x*3, coords.y + velocity.y*3, coords.z + velocity.z*3);
// //    line(0, 0, 0, velocity.x*2, velocity.y*2, velocity.z*2);
//     popMatrix();
//   }
// }
