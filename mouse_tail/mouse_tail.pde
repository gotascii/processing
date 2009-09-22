int len = 50;
float max_diam = 50.0;
float diam_step = max_diam/len;
float clr_step = 255/len;
int [] x_pos = new int[len];
int [] y_pos = new int[len];

void setup() {
  size(300, 300);
  smooth();
  background(0);
  noStroke();
}

void draw() {
  background(0);

  int j;
  for(j = 0; j < len-1; j++) {
    x_pos[j] = x_pos[j+1];
    y_pos[j] = y_pos[j+1];
  }

  x_pos[len - 1] = mouseX;
  y_pos[len - 1] = mouseY;
  float diam = 0;
  float clr = 0;
  for(j = 0; j < len; j++) {
    fill(clr);
    ellipse(x_pos[j], y_pos[j], diam, diam);
    diam += diam_step;
    clr += clr_step;
  }
}
