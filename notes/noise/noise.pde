float xt = 0;
float yt = 100;
float dt = 300;
float d = 10;

void setup() {
  noStroke();
  smooth();
}

void draw() {
  background(0);
  ellipse(noise(xt)*width, noise(yt)*height, noise(dt)*d, noise(dt)*d);
  xt += 0.001;
  yt += 0.001;
  dt += 0.01;
}
