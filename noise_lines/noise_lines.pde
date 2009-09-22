int cols = 80;
Vector [][] vectors = new Vector[cols][cols];
float t = 0;
int d = 6;
int s = cols * d;

void setup() {
  smooth();
  size(s, s);
  noiseDetail(1);
  stroke(255);
  for(int i = 0; i < cols; i++) {
    for(int j = 0; j < cols; j++) {
      vectors[i][j] = new Vector(i*d + d/2, j*d + d/2, d);
    }
  }
}

void draw() {
  background(0);
  for(int i = 0; i < cols; i++) {
    for(int j = 0; j < cols; j++) {
      vectors[i][j].spin(t);
      vectors[i][j].display();
    }
  }
  t += 0.08;
}
