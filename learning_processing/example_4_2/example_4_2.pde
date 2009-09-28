// always define variables at the top for now
//int circleX = 100;
//int circleY = 100;

void setup() {
  size(200, 200);
}

void draw() {
  background(255);
  stroke(0);
  fill(175);

  ellipse(100, 100, 50, 50);
//  use system variable mouseX and mouseY
//  ellipse(mouseX, mouseY, 50, 50);
//  use our own variables
//  ellipse(circleX, circleY, 50, 50);
//  variables varry, so lets add some variation
//  circleX = circleX + 1;
}
