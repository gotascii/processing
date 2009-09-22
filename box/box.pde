void setup() {
  size(200, 200, P3D);
}

void draw() {
  background(144);
  translate(100, 100);
  rotateY(PI*(2.0*mouseX/width));
  rotateX(PI*(2.0*mouseY/width));
  box(50);
}
