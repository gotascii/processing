float ra = 30;
float rb = 100;
float da = ra * 2;
float db = rb * 2;
PVector a, b, v;

void setup() {
  size(800, 800, P3D);
  a = new PVector(-50, -100);
  v = new PVector(150, 30);
  b = new PVector(150, 0);

  background(0);
  translate(width/2, height/2);

  fill(200, 200);

  stroke(255);
  ellipse(a.x, a.y, da, da);
  ellipse(b.x, b.y, db, db);
  ellipse(a.x + v.x, a.y + v.y, da, da);

  stroke(255, 0, 0);
  line(a.x, a.y, a.x + v.x, a.y + v.y);

  PVector c = PVector.sub(b, a);
  float distance = c.mag();
  float r = ra + rb;
  float v_mag = v.mag();

  // if movement vector is as long or longer than the shortest distance
  // between the two circles minus the combined radii you might have a collision
  if(v_mag >= (distance - r)) {
    stroke(0, 255, 0);
    line(a.x, a.y, a.x + c.x, a.y + c.y);
    // vector from a to b projected onto the movement vector will
    // be positive if the movement is towards a
    if (c.dot(v) > 0) {
      // vector projected onto a normalized vector returns the magnitude of
      // the component of the projected vector in the direction of normalized
      // the distance between the center of a and the closest point on v to b
      PVector n = v.normalize(new PVector());
      float d = n.dot(c);
      
      PVector dv = PVector.mult(n, d);
      stroke(0, 0, 255, 100);
      line(a.x, a.y, a.x + dv.x, a.y + dv.y);

      float f = pow(c.mag(), 2) - pow(d, 2);
      if (f <= pow(r, 2)) {
        stroke(255, 255, 0);
        line(b.x, b.y, a.x + dv.x, a.y + dv.y);
        
        float t = pow(r, 2) - f;
        float m = d - sqrt(t);
        if (m <= v_mag) {
          v = PVector.mult(n, m);
          stroke(255);
          ellipse(a.x + v.x, a.y + v.y, da, da);
        }
      }
    }
  }
}
