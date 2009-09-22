// always define variables at the top for now
//int circleX = 100;
//int circleY = 100;

float diameter = 10;
float ddiameter = 0.5;

void setup() {
  size(200, 200);
  stroke(0);
  fill(175);
}

void draw() {
  background(255);

  ellipse(mouseX, mouseY, diameter, diameter);
  diameter += ddiameter;
}

void mouseClicked() {
  ddiameter *= -1;
}
