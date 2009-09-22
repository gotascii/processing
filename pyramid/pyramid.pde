float xt = 0.0;
float yt = 0.0;

void setup() {
  size(200, 200, P3D);
}

void draw() {
  background(144);

  float dx = PI*mouseX/width;
  float dy = PI*mouseY/height;
  xt += radians(dx);
  yt += radians(dy);

  translate(100, 100, 0);
  rotateX(dx);
  rotateY(dy);
//  rotateZ(xt+yt);
  drawPyramid(50);

  translate(50, 50, 20);
  drawPyramid(10);
}

void drawPyramid(int t) {
  stroke(0);

  // this pyramid has 4 sides, each drawn as a separate triangle
  // each side has 3 vertices, making up a triangle shape
  // the parameter "t" determines the size of the pyramid

  fill(150, 0, 0, 127);

  beginShape(TRIANGLES);
  vertex(-t,-t,-t);
  vertex( t,-t,-t);
  vertex( 0, 0, t);

  fill(0,150,0,127);
  vertex( t,-t,-t);
  vertex( t, t,-t);
  vertex( 0, 0, t);

  fill(0,0,150,127);
  vertex( t, t,-t);
  vertex(-t, t,-t);
  vertex( 0, 0, t);

  fill(150,0,150,127);
  vertex(-t, t,-t);
  vertex(-t,-t,-t);
  vertex( 0, 0, t);
  endShape();
}

