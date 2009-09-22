float theta = 0;
int steps = 20;
float dt = 0;
float maxt = 0;

PVector start, end;

void setup() {
  size(400, 400, P3D);
}

void draw() {
  background(255);
  stroke(0);
  noStroke();
  translate(width/2, height/2);
//  rotateY(radians(-45));
  rotateY(theta);
  theta += 0.01;
  dt = maxt/steps;
//  start = new PVector(0, 0, 0);
//  end = new PVector(200, 0, 0);
//  darc(start, end, 1000, 40, 100);

  start = new PVector(0, 0, 0);
  end = new PVector(100, 0, 0);
  darc(start, end, 500, 90, 80);

  maxt += 0.04;
  maxt = constrain(maxt, 0, 1);
}

void darc(PVector start, PVector end, float hump, float lean, float tall) {
  PVector sspline = new PVector(start.x, start.y + hump, start.z);
  PVector espline = new PVector(end.x, end.y + hump, start.z);
  stroke(0);
  curve(sspline.x, sspline.y, sspline.z + lean, start.x, start.y, start.z, end.x, end.y, end.z, espline.x, espline.y, espline.z + lean);
  curve(sspline.x, sspline.y - tall, sspline.z + lean, start.x, start.y, start.z, end.x, end.y, end.z, espline.x, espline.y - tall, espline.z + lean);
//  curve(sspline.x, sspline.y, sspline.z - lean, start.x, start.y, start.z, end.x, end.y, end.z, espline.x, espline.y, espline.z - lean);
//  curve(sspline.x, sspline.y - tall, sspline.z - lean, start.x, start.y, start.z, end.x, end.y, end.z, espline.x, espline.y - tall, espline.z - lean);
//  fill(100);
//  side(start, end, sspline, espline, tall, lean);
//  side(start, end, sspline, espline, tall, -lean);
//  fill(200);
//  top(start, end, sspline, espline, tall, lean);
//  fill(10);
//  bottom(start, end, sspline, espline, tall, lean);
}

void bottom(PVector start, PVector end, PVector sspline, PVector espline, float tall, float lean) {
  float t = 0;
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= steps; i++) {
    float x = curvePoint(sspline.x, start.x, end.x, espline.x, t);
    float y = curvePoint(sspline.y - tall, start.y, end.y, espline.y - tall, t);
    float z = curvePoint(sspline.z + lean, start.z, end.z, espline.z + lean, t);
    vertex(x, y, z);

    x = curvePoint(sspline.x, start.x, end.x, espline.x, t);
    y = curvePoint(sspline.y - tall, start.y, end.y, espline.y - tall, t);
    z = curvePoint(sspline.z - lean, start.z, end.z, espline.z - lean, t);
    vertex(x, y, z);
    t += dt;
  }
  endShape();
}

void top(PVector start, PVector end, PVector sspline, PVector espline, float tall, float lean) {
  float t = 0;
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= steps; i++) {
    float x = curvePoint(sspline.x, start.x, end.x, espline.x, t);
    float y = curvePoint(sspline.y, start.y, end.y, espline.y, t);
    float z = curvePoint(sspline.z + lean, start.z, end.z, espline.z + lean, t);
    vertex(x, y, z);

    x = curvePoint(sspline.x, start.x, end.x, espline.x, t);
    y = curvePoint(sspline.y, start.y, end.y, espline.y, t);
    z = curvePoint(sspline.z - lean, start.z, end.z, espline.z - lean, t);
    vertex(x, y, z);
    t += dt;
  }
  endShape();
}

void side(PVector start, PVector end, PVector sspline, PVector espline, float tall, float lean) {
  float t = 0;
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= steps; i++) {
    float x = curvePoint(sspline.x, start.x, end.x, espline.x, t);
    float y = curvePoint(sspline.y, start.y, end.y, espline.y, t);
    float z = curvePoint(sspline.z + lean, start.z, end.z, espline.z + lean, t);
    vertex(x, y, z);

    x = curvePoint(sspline.x, start.x, end.x, espline.x, t);
    y = curvePoint(sspline.y - tall, start.y, end.y, espline.y - tall, t);
    z = curvePoint(sspline.z + lean, start.z, end.z, espline.z + lean, t);
    vertex(x, y, z);
    t += dt;
  }
  endShape();
}
