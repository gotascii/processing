float u_angle = 0;
float x = 75;
float y = 75;
float radius = 50;
float diameter = radius*2;
float freq = 1;
float j = 0;

float dx(float x, float angle, float radius) {
  return x + cos(radians(angle)) * radius;
}

float dy(float y, float angle, float radius) {
  return y + sin(radians(angle)) * radius;
}

void draw_f() {
  stroke(200);
  float f_angle = 0;
  int i = 0;
  while(f_angle < 360) {
    point(x+radius+i, dy(y, f_angle, radius));
    f_angle += freq;
    i++;
  }
}

void draw_u() {
  noStroke();
  fill(255);
  ellipse(x, y, diameter, diameter);
}

void draw_radius() {
  stroke(0);
  line(x, y, dx(x, u_angle, radius), dy(y, u_angle, radius));
  u_angle += freq;
}

void draw_fx() {
  noStroke();
  fill(0);

  if (u_angle%360 == 0) {
    j = 0;
  }
  ellipse(x+radius+j, dy(y, u_angle, radius), 5, 5);
  j += freq;
}

void setup() {
  size(515, 150);
  smooth();
}

void draw() {
  background(127);

  draw_u();
  draw_f();
  draw_fx();
  draw_radius();
}
