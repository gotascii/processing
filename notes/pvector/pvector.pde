PVector v1, v2, v3;

void setup() {
  background(0);
  stroke(255);
  size(400, 400);
  translate(width/2, height/2);
  v1 = new PVector(100, 15);
  v2 = new PVector(80, 100);
  println(v1.mag());  // dist(0, 0, v1.x, v1.y)
  println(v2.mag());  // dist(0, 0, v2.x, v2.y)

  stroke(255, 0, 0);
  line(0, 0, v1.x, v1.y);

  stroke(0, 255, 0);
  line(0, 0, v2.x, v2.y);

  stroke(0, 0, 255);
  line(v1.x, v1.y, v2.x, v2.y);

  println(degrees(PVector.angleBetween(v1, v2)));

  stroke(255, 255, 0);
  v3 = PVector.mult(v1, -1);
  v3.limit(20);
  line(0, 0, v3.x, v3.y);

  stroke(0, 255, 255);
  v1.add(v2);
  line(0, 0, v1.x, v1.y);
}
