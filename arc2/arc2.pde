int steps = 20;
float maxt1 = 0;
float maxt2 = 0;
float theta = 0;

PVector start, end;

void setup() {
  size(400, 400, P3D);
  noStroke();
}

void draw() {
  background(255);
  translate(width/2, height/2);
  rotateY(radians(-73.3));
  theta += 0.01;

  darc(150, 100, 20, 20, maxt1);

  pushMatrix();
  rotateY(45);
  darc(100, 50, 20, 10, maxt2);
  popMatrix();

  maxt1 += 0.01;
  maxt1 = constrain(maxt1, 0, 1);

  maxt2 += 0.03;
  maxt2 = constrain(maxt2, 0, 1);
}

PVector arcPoint(PVector start, PVector end, float i, float h) {
  float a = map(i, 0, 1, 0, 180);
  float mod = sin(radians(a));
  float y = -mod * h;
  float x = map(i, 0, 1, start.x, end.x);
  float z = map(i, 0, 1, start.z, end.z);
  return new PVector(x, y, z);
}

void darc(float len, float hump, float w, float h, float maxt) {
  PVector start = new PVector(0, 0, 0);
  PVector end = new PVector(len, 0, 0);
  float dt = maxt/steps;

  float t = 0;
  fill(150);
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= steps; i++) {
    PVector ap = arcPoint(start, end, t, hump);
    float a = map(t, 0, 1, 0, 180);
    float mod = sin(radians(a));
    float mod_y = ap.y + (mod*h);
    float mod_z = ap.z + (mod*(w/2));

    vertex(ap.x, ap.y, mod_z);
    vertex(ap.x, mod_y, mod_z);
    t += dt;
  }
  endShape();

  t = 0;
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= steps; i++) {
    PVector ap = arcPoint(start, end, t, hump);
    float a = map(t, 0, 1, 0, 180);
    float mod = sin(radians(a));
    float mod_y = ap.y + (mod*h);
    float mod_z = ap.z - (mod*(w/2));
  
    vertex(ap.x, ap.y, mod_z);
    vertex(ap.x, mod_y, mod_z);
    t += dt;
  }
  endShape();
  
  t = 0;
  fill(200);
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= steps; i++) {
    PVector ap = arcPoint(start, end, t, hump);
    float a = map(t, 0, 1, 0, 180);
    float mod = sin(radians(a));
    float mod_z1 = ap.z + (mod*(w/2));
    float mod_z2 = ap.z - (mod*(w/2));
  
    vertex(ap.x, ap.y, mod_z1);
    vertex(ap.x, ap.y, mod_z2);
    t += dt;
  }
  endShape();
  
  t = 0;
  fill(100);
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= steps; i++) {
    PVector ap = arcPoint(start, end, t, hump);
    float a = map(t, 0, 1, 0, 180);
    float mod = sin(radians(a));
    float mod_y = ap.y + (mod*h);
    float mod_z1 = ap.z + (mod*(w/2));
    float mod_z2 = ap.z - (mod*(w/2));
  
    vertex(ap.x, mod_y, mod_z1);
    vertex(ap.x, mod_y, mod_z2);
    t += dt;
  }
  endShape();
}
