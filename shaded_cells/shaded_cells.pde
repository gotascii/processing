int cols = 20;
int rows = 20;
int csize = 20;
float theta;

void setup() {
  size(cols*csize, rows*csize);
  theta = 0;
}

void draw() {
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      fill(sin(i+j+theta)*127 + 127);
      rect(i*csize, j*csize, csize, csize);
      theta += 0.0001;
    }
  }
}
