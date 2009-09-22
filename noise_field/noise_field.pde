float t = 0;
float dt = 0.01;

int i, j;

int s = 400;
int res = 5;
int count = int(s / res);

boolean show_vectors = false;

Mouse m = new Mouse(0.01);
Field f = new Field(0.005);
Particle [][] particles = new Particle[count][count];
Vector [][] vectors = new Vector[count][count];

void setup() {
  smooth();
  size(s, s);
  noiseDetail(1);
  stroke(255);

  for(i = 0; i < count; i++) {
    for(j = 0; j < count; j++) {
      float speed = random(1, 10);
      particles[i][j] = new Particle(i*res, j*res, 0.1, f);
    }
  }

  for(i = 0; i < count; i++) {
    for(j = 0; j < count; j++) {
      vectors[i][j] = new Vector(i*res, j*res, res, f);
    }
  }
}

void draw() {
  background(0);
  m.move();
  f.shift(m.x, m.y, t);
  for(int i = 0; i < count; i++) {
    for(int j = 0; j < count; j++) {
      if (show_vectors) {
        vectors[i][j].spin();
        vectors[i][j].display();
      }

      particles[i][j].move();
      particles[i][j].display();
    }
  }
  t += dt;
}

void mouseClicked() {
  show_vectors = !show_vectors;
}
