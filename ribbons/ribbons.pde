int count = 5;
Ribbon [] ribbon = new Ribbon[count];
Magnet magnet;
Camera cam;

void setup() {
  size(800, 800, P3D);
  magnet = new Magnet();
  cam = new Camera(magnet);
  for(int i = 0; i < count; i++) {
    ribbon[i] = new Ribbon(magnet);
  }
}

void draw() {
  exist();
}

void exist() {
  background(100);
  magnet.exist();
  cam.exist();
  for(int i = 0; i < count; i++) {
    ribbon[i].exist();
    ribbon[i].display();
  }
}
