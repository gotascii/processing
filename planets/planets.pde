float theta = 0;
Orbiter sun, earth, moon;

void setup () {
  size(1500, 600, P3D);
  noStroke();
  stroke(100, 40);
//  smooth();
  sun = new Orbiter(0, 200, 0);
  earth = new Orbiter(0.005, 20, 350);
  moon = new Orbiter(0.09, 5, 30);
  earth.add_orbiter(moon);
}

void draw() {
  background(150);
  lights();
  translate(width/2, height/2);
  rotateX(radians(mouseY%360));

  sun.display();
  earth.spin();
  earth.display();
}
