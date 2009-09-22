int sizex = 400;
int sizey = 400;
int cellw = 50;
int cellh = 5;
int x = sizex/2;
int y = 0;
float theta = 0;
float uh;
void setup() {
  size(sizex, sizey, P3D);
  noStroke();
//  stroke(255);
  fill(10, 100);
}

void draw() {
  background(100);
  translate(x, y);
  rotateY(theta);
  beginShape(QUAD_STRIP);
//  beginShape(POINTS);

  for(int i = 0; i < 80; i++) {
    float d = sin((i*0.05)+uh) * 100;
    vertex(0, 0 + (cellh*i), d);
    vertex(0 + cellw, 0 + (cellh*i), d*-0.5);
  }
  endShape();
  uh += 0.05;
  theta += 0.01;
}
